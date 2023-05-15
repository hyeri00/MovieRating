//
//  MovieDetailViewController.swift
//  MovieRating
//
//  Created by 혜리 on 2023/04/05.
//

import UIKit
import SafariServices
import RealmSwift

class MovieDetailViewController: UIViewController {
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray.withAlphaComponent(0.7)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let detailView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var thumbnailImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var titleAndYearLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var genreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var ratingImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "star")
        return img
    }()
    
    private var ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [ratingImage, ratingLabel])
        view.spacing = 4
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let movieDetailSiteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("영화 상세정보 보기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let rateLabel: UILabel = {
       let label = UILabel()
        label.text = "영화 평가하기"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rateView: RateView = {
        let view = RateView()
        view.tintColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let removeMovieCellButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "trash")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        button.setTitle("  보관함에서 삭제하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var moviesData: MovieData?
    weak var delegate: MovieDetailDelegate?
    private var realm: Realm!
    private let toast = ToastMessage()
    private var detailViewTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        getMovies()
        getRateView()
        setupAddTarget()
        setSeparatorView()
        setBackgroundView()
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showDetailView()
    }
    
    private func addViews() {
        view.addSubview(backgroundView)
        view.addSubview(detailView)
        view.addSubview(thumbnailImage)
        view.addSubview(titleAndYearLabel)
        view.addSubview(genreLabel)
        view.addSubview(ratingStackView)
        view.addSubview(movieDetailSiteButton)
        view.addSubview(rateLabel)
        view.addSubview(rateView)
        view.addSubview(removeMovieCellButton)
    }
    
    private func getMovies() {
        do {
            realm = try Realm()
        } catch let error as NSError {
            print("Failed to open Realm: \(error.localizedDescription)")
        }
        
        if let movie = moviesData {
            if let imageData = movie.thumbnailImageData {
                let image = UIImage(data: imageData)
                thumbnailImage.image = image
            }
            titleAndYearLabel.text = "\(movie.title)"
            genreLabel.text = movie.genre
            ratingLabel.text = "\(movie.rating)"
        }
    }
    
    private func getRateView() {
        if let movie = moviesData {
            rateView.currentStar = Int(movie.userRate)
            rateView.updateButtonAppearance()
        }
    }
    
    private func setupAddTarget() {
        movieDetailSiteButton.addTarget(self, action: #selector(goMovieDeatilSite), for: .touchUpInside)
        rateView.addTarget(self, action: #selector(changeRate), for: .valueChanged)
        removeMovieCellButton.addTarget(self, action: #selector(deleteMovieCollectionView), for: .touchUpInside)
    }
    
    private func setSeparatorView() {
        for i in 1...2 {
            let separatorView = UIView()
            separatorView.backgroundColor = .lightGray
            separatorView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(separatorView)
            
            NSLayoutConstraint.activate([
                separatorView.topAnchor.constraint(equalTo: movieDetailSiteButton.bottomAnchor, constant: i == 1 ? 10 : 100),
                separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                separatorView.heightAnchor.constraint(equalToConstant: 1)
            ])
        }
    }
    
    private func setBackgroundView() {
        let backgroundTap = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped(_:)))
        backgroundView.addGestureRecognizer(backgroundTap)
        backgroundView.isUserInteractionEnabled = true
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            detailView.heightAnchor.constraint(equalToConstant: 350),
            
            thumbnailImage.topAnchor.constraint(equalTo: detailView.topAnchor, constant: 10),
            thumbnailImage.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 10),
            thumbnailImage.widthAnchor.constraint(equalToConstant: 80),
            thumbnailImage.heightAnchor.constraint(equalToConstant: 100),
            
            titleAndYearLabel.topAnchor.constraint(equalTo: detailView.topAnchor, constant: 15),
            titleAndYearLabel.leadingAnchor.constraint(equalTo: thumbnailImage.trailingAnchor, constant: 15),
            titleAndYearLabel.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -15),
            
            genreLabel.leadingAnchor.constraint(equalTo: thumbnailImage.trailingAnchor, constant: 15),
            genreLabel.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -15),
            genreLabel.bottomAnchor.constraint(equalTo: ratingStackView.topAnchor, constant: -10),
            
            ratingImage.widthAnchor.constraint(equalToConstant: 15),
            ratingImage.heightAnchor.constraint(equalToConstant: 15),
            
            ratingStackView.leadingAnchor.constraint(equalTo: thumbnailImage.trailingAnchor, constant: 15),
            ratingStackView.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -15),
            ratingStackView.bottomAnchor.constraint(equalTo: thumbnailImage.bottomAnchor),
            
            movieDetailSiteButton.topAnchor.constraint(equalTo: thumbnailImage.bottomAnchor, constant: 10),
            movieDetailSiteButton.centerXAnchor.constraint(equalTo: detailView.centerXAnchor),
            
            rateLabel.topAnchor.constraint(equalTo:  movieDetailSiteButton.bottomAnchor, constant: 30),
            rateLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 15),
            
            rateView.topAnchor.constraint(equalTo: movieDetailSiteButton.bottomAnchor, constant: 50),
            rateView.centerXAnchor.constraint(equalTo: detailView.centerXAnchor),
            
            removeMovieCellButton.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 15),
            removeMovieCellButton.bottomAnchor.constraint(equalTo: detailView.bottomAnchor, constant: -50)
        ])
    }
    
    private func showDetailView() {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
        detailViewTopConstraint = detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant)
        detailViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - 300
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func goMovieDeatilSite() {
    }
    
    @objc private func changeRate() {
        print(#function)
        
        let rate = CGFloat(rateView.currentStar)
        print("Rating changed to: \(rate)")
        let userInfo = ["rate": rate]
        NotificationCenter.default.post(name: NSNotification.Name("didChangeRate"),
                                        object: nil,
                                        userInfo: userInfo)
        
        let rateButton = rateView.currentStar
        print("button count: \(rateButton)")
        UserDefaults.standard.set(rateButton, forKey: "buttonState")
    }
    
    @objc private func deleteMovieCollectionView() {
        let alert = UIAlertController(title: "Warning", message: "정말 삭제하시겠습니까?\n삭제할 시 복구가 불가능합니다.", preferredStyle: .alert)

        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let action = UIAlertAction(title: "확인", style: .default) { [self] _ in
            self.toast.showToast(image: UIImage(named: "trash")!,
                            message: "삭제가 완료됐습니다.")

            guard let movie = self.moviesData else {
                return
            }
            do {
                let realm = try Realm()
                try realm.write {
                    realm.delete(movie)
                    self.dismiss(animated: false)
                }
                delegate?.updateCollectionView()
                self.navigationController?.popViewController(animated: true)
            } catch {
                print("Failed to delete movie: \(error.localizedDescription)")
            }
        }

        alert.addAction(cancel)
        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func backgroundViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        detailViewTopConstraint.constant = safeAreaHeight + bottomPadding
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.backgroundView.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
}
