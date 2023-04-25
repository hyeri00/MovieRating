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
    
    private var emptyStateLabel: UILabel = {
       let label = UILabel()
        label.text = "검색 결과가 없습니다."
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var query: String?
    private var movies = [Movie]()
    private var searchTask: DispatchWorkItem?
    private let toast = ToastMessage()
    private var selectedData: [ (UIImage?, String?, String?, String?) ] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        addViews()
        setTableView()
        setNavigationBar()
        setConstraints()
    }
    
    private func setup() {
        view.backgroundColor = .white
    }
    
    private func addViews() {
        view.addSubview(totalCountLabel)
        view.addSubview(movieTableView)
        movieTableView.addSubview(emptyStateLabel)
    }
    
    private func setTableView() {
        movieTableView.delegate = self
        movieTableView.dataSource = self
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        navigationItem.title = "홈"
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController?.searchBar.placeholder = "검색어를 입력하세요"
        navigationItem.searchController?.searchBar.delegate = self
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            totalCountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            totalCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            movieTableView.topAnchor.constraint(equalTo: totalCountLabel.bottomAnchor, constant: 5),
            movieTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            movieTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            movieTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: movieTableView.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: movieTableView.centerYAnchor)
        ])
    }
    
    private func searchMovies(query: String) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        urlComponents.path = "/3/search/movie"
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: "73861d304f91be437d4465b52141a39b"),
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "language", value: "ko-KR")
        ]

        let currentPage = 1 // 시작 페이지
        var allMovies = [Movie]() // 모든 영화를 저장할 배열

        func fetchMovies(page: Int) {
            var urlComponents = urlComponents
            urlComponents.queryItems?.append(URLQueryItem(name: "page", value: "\(page)"))
            guard let url = urlComponents.url else {
                print("유효하지 않는 URL")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "Unknown error")
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Response.self, from: data)
                    allMovies += response.results

                    if page < response.totalPages {
                        fetchMovies(page: page+1)
                    } else {
                        self.movies = allMovies
                        DispatchQueue.main.async {
                            if self.movies.isEmpty {
                                self.emptyStateLabel.isHidden = false
                            } else {
                                self.emptyStateLabel.isHidden = true
                            }
                            self.movieTableView.reloadData()
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            task.resume()
        }
        fetchMovies(page: currentPage)
    }
    
//    모든 데이터를 불러오는 것이 아닌 20개씩 나눠서 맨 밑으로 가서 스크롤하면 20개 추가되고 또 맨 밑으로 가면 스크롤해서 20개씩 보여주기
    
    private func getDataCell(at indexPath: IndexPath) -> Any? {
        print(#function)
        guard let cell = movieTableView.cellForRow(at: indexPath) as? MovieTableViewCell else {
            return nil
        }

        let thumbnailImage = cell.thumbnailImage.image
        let titleAndYearLabel = cell.titleAndYearLabel.text
        let genreLabel = cell.genreLabel.text
        let ratingLabel = cell.ratingLabel.text
        let data = (thumbnailImage, titleAndYearLabel, genreLabel, ratingLabel)
        selectedData.append(data)

        return [data]
    }

    @objc private func storageButtonTapped(_ sender: UIButton) {
        print(#function)
        if sender.isSelected {
            sender.isSelected = false
            sender.setImage(UIImage(systemName: "bookmark"), for: .normal)
            sender.tintColor = .black
        } else {
            sender.isSelected = true
            sender.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            sender.tintColor = .black
            toast.showToast(image: UIImage(named: "check-circle")!,
                            message: "  보관함에 저장 되었습니다.")

            guard let indexPath = movieTableView.indexPath(for: sender.superview?.superview as! UITableViewCell) else {
                return
            }

            // 선택한 데이터를 배열 형태로 가져옴
            guard let selectedData = getDataCell(at: indexPath) as? [(UIImage?, String?, String?, String?)] else {
                print("Error: Failed to get selected data")
                return
            }

            // 모든 선택한 데이터를 Tab Bar Controller에 전달
            if let tabBarVC = self.tabBarController, let navController = tabBarVC.viewControllers?[1] as? UINavigationController, let storageVC = navController.topViewController as? StorageViewController {
                storageVC.selectedData.append(contentsOf: selectedData)
            } else {
                print("Error: Failed to get StorageViewController")
            }

            movieTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    private func setTotalCountLabel() {
        let totalCount = self.movies.count
        let countString = String(format: "총 %02d개", totalCount)
        self.totalCountLabel.text = countString
    }
}


extension HomeTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        let movie = movies[indexPath.row]
        if let posterPath = movie.posterPath {
            let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
            cell.thumbnailImage.kf.setImage(with: posterURL,
                                            placeholder: UIImage(systemName: "photo")?.withTintColor(.black))
        }
        cell.titleAndYearLabel.text = "\(movie.title) (\(movie.year))"
        cell.genreLabel.text = movie.genres.map { $0.name }.joined(separator: ", ")
        cell.ratingLabel.text = String(format: "%.1f", movie.voteAverage ?? 0.0)
        cell.storageButton.addTarget(self, action: #selector(storageButtonTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let movie = movies[indexPath.row]
        let movieURL = URL(string: "https://www.themoviedb.org/movie/\(movie.id)")!
        
        let safariViewController = SFSafariViewController(url: movieURL)
        present(safariViewController, animated: true, completion: nil)
    }
}

extension HomeTableViewController: UISearchBarDelegate {
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        for cell in movieTableView.visibleCells {
//            if let cell = cell as? MovieTableViewCell {
//                cell.storageButton.isSelected = false
//                cell.storageButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
//                cell.storageButton.tintColor = .black
//            }
//        }
//        searchTask?.cancel()
//
//        let searchTask = DispatchWorkItem { [weak self] in
//            self?.setTotalCountLabel()
//            self?.searchMovies(query: searchText)
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: searchTask)
//
//        if self.movies.isEmpty {
//            self.emptyStateLabel.isHidden = false
//        } else {
//            self.emptyStateLabel.isHidden = true
//        }
//        self.searchTask = searchTask
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        for cell in movieTableView.visibleCells {
            if let cell = cell as? MovieTableViewCell {
                cell.storageButton.isSelected = false
                cell.storageButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
                cell.storageButton.tintColor = .black
            }
        }
        searchTask?.cancel()

        let searchTask = DispatchWorkItem { [weak self] in
            self?.searchMovies(query: searchText)
            DispatchQueue.main.async {
                if self?.movies.isEmpty == true {
                    self?.emptyStateLabel.isHidden = false
                } else {
                    self?.emptyStateLabel.isHidden = true
                }
                self?.movieTableView.reloadData()
                self?.setTotalCountLabel()
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: searchTask)

        self.searchTask = searchTask
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.setTotalCountLabel()
        self.movieTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchTask?.cancel()
        guard let searchTerm = searchBar.text, searchTerm.isEmpty == false else { return }
        
        DispatchQueue.main.async {
            self.movieTableView.reloadData()
        }
        
        if let text = searchBar.text {
            query = text
            
            searchMovies(query: query!)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        
        emptyStateLabel.isHidden = true
        emptyStateLabel.removeFromSuperview()
        
        totalCountLabel.isHidden = true
        totalCountLabel.removeFromSuperview()
        
        self.movieTableView.reloadData()
    }
}
