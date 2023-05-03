//
//  StorageViewController.swift
//  MovieRating
//
//  Created by 혜리 on 2023/04/03.
//

import UIKit
import RealmSwift

class StorageViewController: UIViewController {
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "보관함 비어있음."
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let movieCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .white
        view.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCollectionViewCell")
        return view
    }()
    
    private var realm: Realm!
    private var moviesData: Results<MovieData>!
    private var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        addViews()
        getMovies()
        getData()
        getNotificationToken()
        setNavigationBar()
        setCollectionView()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getMovies()
        movieCollectionView.reloadData()
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    private func setup() {
        view.backgroundColor = .white
    }
    
    private func addViews() {
        movieCollectionView.addSubview(emptyLabel)
        view.addSubview(movieCollectionView)
    }
    
    private func getMovies() {
        do {
            realm = try Realm()
            moviesData = realm.objects(MovieData.self)
            
            if moviesData.isEmpty {
                self.emptyLabel.isHidden = false
            } else {
                self.emptyLabel.isHidden = true
            }
            
            movieCollectionView.reloadData()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    private func getData() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateEvaluationLabel(_:)),
                                               name: NSNotification.Name("didChangeRate"),
                                               object: nil)
    }
    
    private func getNotificationToken() {
        guard let realm = realm else { return }
        notificationToken = realm.observe { [weak self] (notification, realm) in
            self?.movieCollectionView.reloadData()
        }
    }

    private func setNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        navigationItem.title = "보관함"
        
        let image = UIImage(systemName: "trash.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: image, style: .done,
            target: self, action: #selector(showMovieCollectionViewCellChooseDelete))
    }
    
    private func setCollectionView() {
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            movieCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            movieCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func deleteMovie(at indexPath: IndexPath) {
        let movie = moviesData[indexPath.row]
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(movie)
            }
            movieCollectionView.deleteItems(at: [indexPath])
            movieCollectionView.reloadData()
        } catch {
            print("Failed to delete movie: \(error.localizedDescription)")
        }
    }
    
    @objc func updateEvaluationLabel(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let rate = userInfo["rate"] as? CGFloat,
              let cellIndex = movieCollectionView.indexPathsForSelectedItems?.first else {
            return
        }
        
        let movie = moviesData[cellIndex.item]
        
        do {
            let realm = try Realm()
            try realm.write {
                movie.userRate = rate
            }
        } catch let error as NSError {
            print("Error updating movie userRate: \(error.localizedDescription)")
        }

        if let selectedCell = movieCollectionView.cellForItem(at: cellIndex) as? MovieCollectionViewCell {
            selectedCell.evaluationLabel.text = "평가 함 ⭐️\(rate)"
        }
    }
    
    @objc private func showMovieCollectionViewCellChooseDelete() {
        
    }
}


extension StorageViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("들어온 data count: \(moviesData.count)")
        return self.moviesData?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        let movie = moviesData[indexPath.item]
        cell.thumbnailImage.image = UIImage(data: movie.thumbnailImageData ?? Data())
        cell.titleLabel.text = "\(movie.title)"
        
        if movie.userRate > 0 {
            cell.evaluationLabel.text = "평가 함 ⭐️ \(movie.userRate)"
            cell.evaluationLabel.textColor = .black
        } else {
            cell.evaluationLabel.text = "평가 안 함 ⭐️ 0.0"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = MovieDetailViewController()
        detailVC.modalPresentationStyle = .overFullScreen
        
        let selectedMovie = realm.objects(MovieData.self)[indexPath.item]
        detailVC.moviesData = selectedMovie
        
        self.present(detailVC, animated: false, completion: nil)
    }
}
