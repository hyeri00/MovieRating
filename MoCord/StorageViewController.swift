//
//  StorageViewController.swift
//  MovieRating
//
//  Created by 혜리 on 2023/04/03.
//

import UIKit

import SnapKit

class StorageViewController: UIViewController {
    
    // MARK: - ViewModel
    
    private let storageViewModel: StorageViewModel! = StorageViewModel()
    
    // MARK: - UI
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = Storage.emptyState
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let movieCollectionView: UICollectionView = {
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
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setEmptyState()
        setupViewModel()
        showRatings()
        refresh()
    }
    
    // MARK: - Configure
    
    private func configure() {
        self.view.backgroundColor = .white
        
        self.setupViewModel()
        self.setEmptyState()
        self.showRatings()
        self.setNavigationBar()
        self.makeConstraints()
    }
    
    private func setupViewModel() {
        self.storageViewModel.getStorageMovieList { [weak self] in
            DispatchQueue.main.async {
                self?.refresh()
            }
        }
    }
    
    private func setEmptyState() {
        let movies = self.storageViewModel.movieStorageResult.value.movies
        self.emptyLabel.isHidden = !movies.isEmpty
        
        self.refresh()
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        navigationItem.title = Storage.navigationBarTitle
    }
    
    private func makeConstraints() {
        self.movieCollectionView.addSubview(self.emptyLabel)
        self.view.addSubview(self.movieCollectionView)
        
        self.emptyLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        self.movieCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func refresh() {
        self.movieCollectionView.reloadData()
    }
    
    private func showRatings() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateEvaluationLabel),
            name: NSNotification.Name("didChangeRate"),
            object: nil
        )
    }
    
    private func setEvaluation(
        forCell cell: MovieCollectionViewCell,
        withRate rate: CGFloat
    ) {
        cell.evaluationLabel.text = rate > 0.0 ? "\(Storage.evaluationState) \(rate)" : Storage.unevaluationState
        cell.evaluationLabel.textColor = rate > 0.0 ? .black : .lightGray
    }
    
    @objc
    private func updateEvaluationLabel(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let rate = userInfo["rate"] as? CGFloat,
              let cellIndex = movieCollectionView.indexPathsForSelectedItems?.first,
              let selectedCell = movieCollectionView.cellForItem(at: cellIndex) as? MovieCollectionViewCell else {
            return
        }
        
        self.setEvaluation(forCell: selectedCell, withRate: rate)
    }
}

// MARK: - UICollectionView

extension StorageViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 120, height: 180)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return storageViewModel.movieStorageResult.value.movies.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        let movie = storageViewModel.movieStorageResult.value.movies[indexPath.item]
        
        cell.thumbnailImage.setImage(withPosterPath: movie.posterPath)
        cell.titleLabel.text = movie.year.isEmpty ? "\(movie.title)" : "\(movie.title) (\(movie.year))"
        setEvaluation(forCell: cell, withRate: movie.userRate)
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let selectedMovie = storageViewModel.movieStorageResult.value.movies[indexPath.item]
        let detailVC = MovieDetailViewController()
        detailVC.modalPresentationStyle = .overFullScreen
        detailVC.selectedMovieId = selectedMovie.id
        detailVC.delegate = self
        self.present(detailVC, animated: false, completion: nil)
    }
}

// MARK: - Delegate

extension StorageViewController: MovieDetailDelegate {
    
    func updateCollectionView() {
        self.refresh()
    }
}
