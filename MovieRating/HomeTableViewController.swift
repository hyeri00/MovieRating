//
//  HomeTableViewController.swift
//  MovieRating
//
//  Created by 혜리 on 2023/04/03.
//

import UIKit
import Kingfisher
import SafariServices

class HomeTableViewController: UITableViewController {
    
    private let homeViewModel: HomeViewModel! = HomeViewModel()
    
    private var searchTask: DispatchWorkItem?
    private let toast = ToastMessage()
    
    private var emptyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "search")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        return imageView
    }()
    
    private var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = Home.emptyState
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [emptyImage, emptyLabel])
        view.spacing = 10
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var totalCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var movieTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .white
        view.rowHeight = 120
        view.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var emptySearchLabel: UILabel = {
        let label = UILabel()
        label.text = Home.emptySearchState
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupViewModel()
        addViews()
        setTableView()
        setNavigationBar()
        setConstraints()
    }
    
    private func setup() {
        view.backgroundColor = .white
    }
    
    private func setupViewModel() {
        homeViewModel.movieSearchResult.bind { result in
            print("movies \(result.movies.count) \(result.totalCount)")
            
            if !result.indexPaths.isEmpty {
                self.movieTableView.insertRows(at: result.indexPaths, with: .automatic)
            } else {
                self.movieTableView.reloadData()
            }
            self.setTotalCountLabel(result.totalCount)
            
            let isMovieNotEmpty = !result.movies.isEmpty
            self.emptySearchLabel.isHidden = isMovieNotEmpty
            self.stackView.isHidden = isMovieNotEmpty || !self.homeViewModel.query.isEmpty
            self.totalCountLabel.isHidden = !isMovieNotEmpty
        }
        
        homeViewModel.isBookmarkedMovie.bind { movie in
            if movie != nil {
                self.toast.showToast(image: UIImage(named: "check-circle")!,
                                     message: Toast.saveMessage)
            }
        }
        
        homeViewModel.isUnbookmarkedMovie.bind { movie in
            if movie != nil {
                self.toast.showToast(image: UIImage(named: "check-circle")!,
                                     message: Toast.deleteMessage)
            }
        }
    }
    
    private func addViews() {
        view.addSubview(totalCountLabel)
        view.addSubview(movieTableView)
        view.addSubview(stackView)
        view.addSubview(emptySearchLabel)
    }
    
    private func setTableView() {
        movieTableView.delegate = self
        movieTableView.dataSource = self
    }
    
    private func setNavigationBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        navigationItem.title = Home.navigationBarTitle
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController?.searchBar.placeholder = Home.searchBarPlaceHolder
        navigationItem.searchController?.searchBar.delegate = self
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            emptyImage.widthAnchor.constraint(equalToConstant: 100),
            emptyImage.heightAnchor.constraint(equalToConstant: 100),
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            
            totalCountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            totalCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            movieTableView.topAnchor.constraint(equalTo: totalCountLabel.bottomAnchor, constant: 5),
            movieTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            movieTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            movieTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptySearchLabel.centerXAnchor.constraint(equalTo: movieTableView.centerXAnchor),
            emptySearchLabel.centerYAnchor.constraint(equalTo: movieTableView.centerYAnchor)
        ])
    }
    
    private func searchMovies(query: String) {
        if query.isEmpty {
            emptySearchLabel.isHidden = true
            stackView.isHidden = false
            totalCountLabel.isHidden = true
            
            homeViewModel.resetPages()
            movieTableView.reloadData()
            return
        }
        
        homeViewModel.search(query: query)
    }
    
    private func getMovieData(at indexPath: IndexPath) -> Int! {
        guard let cell = movieTableView.cellForRow(at: indexPath) as? MovieTableViewCell else {
            return nil
        }
        
        return homeViewModel.movieSearchResult.value.movies[indexPath.row].id
    }
    
    private func setTotalCountLabel(_ totalCount: Int) {
        let countString = String(format: "총 %02d개", totalCount)
        self.totalCountLabel.text = countString
        print("총 영화 개수: \(totalCount)")
    }
    
    @objc private func storageButtonTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? MovieTableViewCell,
              let indexPath = movieTableView.indexPath(for: cell),
              let movieId = getMovieData(at: indexPath)
        else {
            return
        }
        
        if sender.isSelected {
            sender.isSelected = false
            sender.setImage(UIImage(systemName: "bookmark"), for: .normal)
        } else {
            sender.isSelected = true
            sender.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
        
        homeViewModel.changeBookmark(movieId: movieId)
    }
}


extension HomeTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.movieSearchResult.value.movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        
        let movies = homeViewModel.movieSearchResult.value.movies
        
        guard indexPath.row < movies.count else { return cell }
        
        let movie = movies[indexPath.row]
        if let posterPath = movie.posterPath {
            let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
            cell.thumbnailImage.kf.setImage(with: posterURL,
                                            placeholder: UIImage(systemName: "photo")?.withTintColor(.black, renderingMode: .alwaysOriginal))
        }
        
        if movie.year.isEmpty {
            cell.titleAndYearLabel.text = "\(movie.title)"
        } else {
            cell.titleAndYearLabel.text = "\(movie.title) (\(movie.year))"
        }
        
        if movie.genres.isEmpty {
            cell.genreLabel.text = movieInfo.emptyInfo
        } else {
            cell.genreLabel.text = movie.genres.map { $0.name }.joined(separator: ", ")
        }
        
        cell.ratingLabel.text = movie.voteAverageString
        
        cell.storageButton.addTarget(self, action: #selector(storageButtonTapped(_:)), for: .touchUpInside)
        cell.storageButton.tag = indexPath.row
        
        let isBookmarked = movie.isBookmarked
        if isBookmarked {
            cell.storageButton.isSelected = true
            cell.storageButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            cell.storageButton.isSelected = false
            cell.storageButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let movie = homeViewModel.movieSearchResult.value.movies[indexPath.row]
        let movieURL = URL(string: "https://www.themoviedb.org/movie/\(movie.id)")!
        
        let safariViewController = SFSafariViewController(url: movieURL)
        present(safariViewController, animated: true, completion: nil)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            homeViewModel.loadNextPage()
        }
    }
}

extension HomeTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        homeViewModel.resetPages()
        movieTableView.reloadData()
        
        searchTask?.cancel()
        
        let searchTask = DispatchWorkItem { [weak self] in
            if searchText.isEmpty {
                DispatchQueue.main.async {
                    self?.stackView.isHidden = false
                    self?.emptySearchLabel.isHidden = true
                    self?.movieTableView.reloadData()
                }
            } else {
                self?.searchMovies(query: searchText)
                DispatchQueue.main.async {
                    self?.movieTableView.reloadData()
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: searchTask)
        
        stackView.isHidden = true
        self.searchTask = searchTask
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchTask?.cancel()
        guard let searchTerm = searchBar.text, searchTerm.isEmpty == false else {
            searchMovies(query: "")
            return
        }
        
        DispatchQueue.main.async { [self] in
            movieTableView.reloadData()
        }
        homeViewModel.resetPages()
        
        if let text = searchBar.text {
            searchMovies(query: searchBar.text!)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        homeViewModel.clear()
        
        print(#function)
    }
}
