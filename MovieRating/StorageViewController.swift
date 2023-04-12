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
    
    var movie: (String?, String?)?
    var movies: [Movie] = []
    var data: [(UIImage?, String?)] = []
    var selectedData: (UIImage?, String?)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        addViews()
        setNavigationBar()
        setCollectionView()
        setConstraints()
        
        if let data = selectedData {
            print("collectionViewData: \(data)")
        } else {
            print("collectionViewData is nil")
        }
        if selectedData == nil {
            print("Error: selectedData is nil")
            return
        }
        if let selectedData = selectedData {
            data.append(selectedData)
            movieCollectionView.reloadData()
        } else {
            print("Error: selectedData is nil")
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedData = selectedData {
            // selectedData 값을 이용한 처리
            print("Selected thumbnailImage: \(String(describing: selectedData.0))")
            print("Selected titleAndYearLabel: \(String(describing: selectedData.1))")
        } else {
            print("Error: selectedData is nil")
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


extension StorageViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        cell.thumbnailImage.image = selectedData?.0
        cell.titleLabel.text = selectedData?.1
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let deatilVC = MovieDetailViewController()
        deatilVC.modalPresentationStyle = .overFullScreen
        self.present(deatilVC, animated: false, completion: nil)
    }
}
