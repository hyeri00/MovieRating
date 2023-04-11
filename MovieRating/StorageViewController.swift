//
//  StorageViewController.swift
//  MovieRating
//
//  Created by 혜리 on 2023/04/03.
//

import UIKit
import SDWebImage

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
    
    var movies: [Movie] = []
    var data = [(thumbnailImage: UIImage?, titleAndYear: String?)]()
    var savedData: [(thumbnailImage: UIImage, titleAndYear: String)] = []
    var selectedThumbnailImage: UIImage?
    var selectedTitle: String?
    var tableViewController: HomeTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        addViews()
        setNavigationBar()
        setCollectionView()
        setConstraints()
        
        tableViewController = navigationController?.viewControllers.first as? HomeTableViewController
    }
    
    func requestCellData(at indexPath: IndexPath) {
        if let tableViewController = tableViewController {
            let selectedData = tableViewController.getDataCell(at: IndexPath(row: indexPath.row, section: 0))
            if let (thumbnailImage, titleAndYearLabel) = selectedData as? (UIImage?, String?) {
                // 데이터 처리
            } else {
                print("Error: Failed to get selected data")
            }
        }
    }
    
    private func setup() {
        view.backgroundColor = .white
    }
    
    private func addViews() {
        view.addSubview(movieCollectionView)
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


extension StorageViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        if let tableVC = tableViewController, let selectedData = tableVC.getDataCell(at: IndexPath(row: indexPath.row, section: 0)) {
            cell.thumbnailImage.image = selectedData.thumbnailImage
            cell.titleLabel.text = selectedData.titleAndYear
        } else {
            cell.thumbnailImage.image = nil
            cell.titleLabel.text = ""
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let deatilVC = MovieDetailViewController()
        deatilVC.modalPresentationStyle = .overFullScreen
        self.present(deatilVC, animated: false, completion: nil)
    }
}
