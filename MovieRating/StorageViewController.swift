//
//  StorageViewController.swift
//  MovieRating
//
//  Created by 혜리 on 2023/04/03.
//

import UIKit

class StorageViewController: UIViewController {
    
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
    
    private var movies: [Movie] = []
    private var data: [(UIImage?, String?, String?, String?)] = []
    var selectedData: [(UIImage?, String?, String?, String?)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        addViews()
        getData()
        setNavigationBar()
        setCollectionView()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getData()
        movieCollectionView.reloadData()
    }
    
    private func setup() {
        view.backgroundColor = .white
    }
    
    private func addViews() {
        view.addSubview(movieCollectionView)
    }
    
    private func getData() {
        movies = []
        data = selectedData
        movieCollectionView.reloadData()
        print("Storage에 전달 받은 thumbnailImage: \(String(describing: selectedData.first?.0))")
        print("Storage에 전달 받은 titleAndYearLabel: \(String(describing: selectedData.first?.1))")
        print("Storage에 전달 받은 castLabel: \(String(describing: selectedData.first?.2))")
        print("Storage에 전달 받은 ratingLabel: \(String(describing: selectedData.first?.3))")
    }

    private func setNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        navigationItem.title = "보관함"
    }
    
    private func setCollectionView() {
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            movieCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            movieCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


extension StorageViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("들어온 data count: \(data.count)")
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        let movieData = data[indexPath.item]
        cell.thumbnailImage.image = movieData.0
        cell.titleLabel.text = movieData.1
        print("thumbnailImage: \(String(describing: movieData.0))")
        print("titleLabel: \(String(describing: movieData.1))")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let deatilVC = MovieDetailViewController()
        deatilVC.modalPresentationStyle = .overFullScreen
        deatilVC.selectedMovie = selectedData[indexPath.item]
        self.present(deatilVC, animated: false, completion: nil)
    }
}
