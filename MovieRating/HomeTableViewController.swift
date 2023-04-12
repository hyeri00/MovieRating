//
//  HomeTableViewController.swift
//  MovieRating
//
//  Created by 혜리 on 2023/04/03.
//

import UIKit
import SDWebImage
import SafariServices

class HomeTableViewController: UITableViewController {
    
    private var movieTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .white
        view.rowHeight = 120
        view.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var movies = [Movie]()
    var query: String?
    var data =  [(thumbnailImage: UIImage?, titleAndYear: String?)]()
    var cells: [MovieTableViewCell] = []
    private let toast = ToastMessage()
    var selectedData: Any?
    
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
        view.addSubview(movieTableView)
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
            movieTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            movieTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            movieTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            movieTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
                self.movies = response.results
                DispatchQueue.main.async {
                    self.movieTableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getDataCell(at indexPath: IndexPath) -> Any {
        let cell = cells[indexPath.row]
        let thumbnailImage = cell.thumbnailImage.image
        let titleAndYearLabel = cell.titleAndYearLabel.text
        return (thumbnailImage, titleAndYearLabel)
    }
    
    @objc private func storageButtonTapped(_ sender: UIButton) {
        let selectedData = getDataCell(at: IndexPath(row: sender.tag, section: 0))
        if let (thumbnailImage, titleAndYearLabel) = selectedData as? (UIImage?, String?) {
            print("Selected thumbnailImage: \(String(describing: thumbnailImage))")
            print("Selected titleAndYearLabel: \(String(describing: titleAndYearLabel))")
        } else {
            print("Error: Failed to get selected data")
        }
        movieTableView.deselectRow(at: IndexPath(row: sender.tag, section: 0), animated: true)
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
            cell.thumbnailImage.sd_setImage(with: posterURL, placeholderImage: UIImage(named: "placeholder"))
        }
        cell.titleAndYearLabel.text = "\(movie.title) (\(movie.year))"
        cell.genreLabel.text = movie.genres.map { $0.name }.joined(separator: ", ")
        cell.ratingLabel.text = "\(movie.voteAverage ?? 0.0)"
        cells.append(cell)
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
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.movieTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text, searchTerm.isEmpty == false else { return }
        
        DispatchQueue.main.async {
            self.movieTableView.reloadData()
        }
        
        if let text = searchBar.text {
            query = text
            
            searchMovies(query: query!)
            print("\(text)")
        }
    }
}
