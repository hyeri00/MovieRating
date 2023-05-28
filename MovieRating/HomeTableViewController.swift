//
//  HomeTableViewController.swift
//  MovieRating
//
//  Created by 혜리 on 2023/04/03.
//

import UIKit
import Kingfisher
import SafariServices
import RealmSwift

class HomeTableViewController: UITableViewController {
    
    private let movieRepository: MovieRepository! = MovieRepository.shared
    private var query: String?
    private var movies = [Movie]()
    private var currentPage = 1
    private var totalPages = 1
    private var searchTask: DispatchWorkItem?
    private let toast = ToastMessage()
    
    private var emptyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "search")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        return imageView
    }()
    
    private var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Search Movies"
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
        label.text = "검색 결과가 없습니다."
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var realm: Realm!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        addViews()
        setTableView()
        setNavigationBar()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let searchText = query {
            navigationItem.searchController?.searchBar.text = searchText
        }
    }
    
    private func setup() {
        view.backgroundColor = .white
    }
    
    private func addViews() {
        movieTableView.addSubview(stackView)
        view.addSubview(totalCountLabel)
        view.addSubview(movieTableView)
        movieTableView.addSubview(emptySearchLabel)
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
        
        navigationItem.title = "홈"
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController?.searchBar.placeholder = "검색어를 입력하세요"
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
        movieRepository.getMovieList(
            query: query,
            page: "\(currentPage)"
        ) { response in
            let newMovies = response.results
            let totalResults = response.totalResults
            var allMovies = [Movie]()

            self.totalPages = response.totalPages

            DispatchQueue.main.async { [self] in
                if currentPage == 1 {
                    allMovies = newMovies
                    movies = allMovies.map { $0 }
                    movieTableView.reloadData()
                } else {
                    let lastRowIndex = self.movies.count - 1
                    var indexPaths = [IndexPath]()
                    for (index, movie) in newMovies.enumerated() {
                        let indexPath = IndexPath(row: lastRowIndex + index + 1, section: 0)
                        movies.append(movie)
                        indexPaths.append(indexPath)
                    }
                    movieTableView.insertRows(at: indexPaths, with: .automatic)
                }

                setTotalCountLabel(totalResults)

                if newMovies.isEmpty {
                    movieTableView.isHidden = true
                    stackView.isHidden = true
                    emptySearchLabel.isHidden = false
                } else {
                    movieTableView.isHidden = false
                    stackView.isHidden = true
                    emptySearchLabel.isHidden = true
                }

                currentPage += 1
            }
        }
    }

    private func getMovieData(at indexPath: IndexPath) -> MovieData? {
        guard let cell = movieTableView.cellForRow(at: indexPath) as? MovieTableViewCell else {
            return nil
        }

        let movie = MovieData()
        movie.id = String(movies[indexPath.row].id)
        movie.thumbnailImageData = cell.thumbnailImage.image?.pngData()
        movie.title = cell.titleAndYearLabel.text ?? ""
        movie.genre = cell.genreLabel.text ?? ""
        movie.rating = cell.ratingLabel.text ?? ""

        return movie
    }
    
    private func setTotalCountLabel(_ totalCount: Int) {
        let countString = String(format: "총 %02d개", totalCount)
        self.totalCountLabel.text = countString
        print("총 영화 개수: \(totalCount)")
    }
    
    @objc private func storageButtonTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? MovieTableViewCell,
              let indexPath = movieTableView.indexPath(for: cell),
              let movie = getMovieData(at: indexPath)
        else {
            return
        }
        
        let movieID = movie.id
        do {
            realm = try Realm()
            try realm.write {
                if let storedMovie = realm.object(ofType: MovieData.self, forPrimaryKey: movieID) {
                    print("아이디", movieID)
                    realm.delete(storedMovie)
                    
                    sender.isSelected = false
                    movie.isBookmarked = false
                    
                    sender.setImage(UIImage(systemName: "bookmark"), for: .normal)
                    toast.showToast(image: UIImage(named: "check-circle")!,
                                    message: "삭제 완료")
                } else {
                    realm.add(movie)
                    
                    sender.isSelected = true
                    movie.isBookmarked = true
                    
                    sender.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                    toast.showToast(image: UIImage(named: "check-circle")!,
                                    message: "보관함에 저장 완료")
                }
            }
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
        print("저장 된 영화 :", movie)
    }
}


extension HomeTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        
        guard indexPath.row < movies.count else { return cell }
        
        let movie = movies[indexPath.row]
        if let posterPath = movie.posterPath {
            let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
            cell.thumbnailImage.kf.setImage(with: posterURL,
                                            placeholder: UIImage(systemName: "photo")?.withTintColor(.black, renderingMode: .alwaysOriginal))
        }
        
        cell.titleAndYearLabel.text = "\(movie.title) (\(movie.year))"
        cell.genreLabel.text = movie.genres.map { $0.name }.joined(separator: ", ")
        cell.ratingLabel.text = String(format: "%.1f", movie.voteAverage ?? 0.0)
        
        cell.storageButton.addTarget(self, action: #selector(storageButtonTapped(_:)), for: .touchUpInside)
        cell.storageButton.tag = indexPath.row
        
        let realm = try! Realm()
        let movieID = String(movie.id)
        let isBookmarked = realm.object(ofType: MovieData.self, forPrimaryKey: movieID) != nil

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
        
        let movie = movies[indexPath.row]
        let movieURL = URL(string: "https://www.themoviedb.org/movie/\(movie.id)")!
        
        let safariViewController = SFSafariViewController(url: movieURL)
        present(safariViewController, animated: true, completion: nil)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.size.height {
            if currentPage < totalPages {
                currentPage += 1
                if let query = query {
                    searchMovies(query: query)
                }
            }
        }
    }
}

extension HomeTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentPage = 1
        movies = []
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

        query = searchText
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
        currentPage = 1
        movies = []

        if let text = searchBar.text {
            query = text
            searchMovies(query: query!)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        totalCountLabel.isHidden = true
        
        stackView.isHidden = false
        view.addSubview(stackView)
        
        movieTableView.reloadData()
        movieTableView.isHidden = true
    }
}
