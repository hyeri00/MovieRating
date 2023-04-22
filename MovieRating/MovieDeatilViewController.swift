//
//  MovieDetailViewController.swift
//  MovieRating
//
//  Created by 혜리 on 2023/04/05.
//

import UIKit
import SafariServices

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
        label.text = ""
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
    
    private let removeMovieCellButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "trash")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        button.setTitle("  보관함에서 삭제하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var movies = [Movie]()
    var collectionView: UICollectionView!
    private var defaultHeight: CGFloat = 300
    var selectedMovie: (UIImage?, String?, String?, String?)?
    private var detailViewTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        getData()
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
    
    private func getData() {
        if let movie = selectedMovie {
            thumbnailImage.image = movie.0
            titleAndYearLabel.text = movie.1
            genreLabel.text = movie.2
            ratingLabel.text = movie.3
        }
    }
    
    private func setupAddTarget() {
        movieDetailSiteButton.addTarget(self, action: #selector(goMovieDeatilSite), for: .touchUpInside)
        rateView.addTarget(self, action: #selector(didChangeRate), for: .valueChanged)
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
        detailViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - defaultHeight
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func goMovieDeatilSite() {
    }
    
    @objc func didChangeRate() {
        print(#function)

        let rate = CGFloat(rateView.currentStar)
        print("Rating changed to: \(rate)")
        let userInfo = ["rate": rate]
        NotificationCenter.default.post(name: NSNotification.Name("didChangeRate"), object: nil, userInfo: userInfo)
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

//@objc func didChangeRate() {
//    print(#function)
//
//    let rate = CGFloat(rateView.currentStar)
//    print("Rating changed to: \(rate)")
//    let userInfo = ["rate": rate]
//    NotificationCenter.default.post(name: NSNotification.Name("didChangeRate"), object: nil, userInfo: userInfo)
//}
//
//이게 MovieDetailViewController의 코드이며 이 rate의 값을
//
//private func getData() {
//    NotificationCenter.default.addObserver(self,
//                                           selector: #selector(updateEvaluationLabel(_:)),
//                                           name: NSNotification.Name("didChangeRate"),
//                                           object: nil)
//}
//
//@objc func updateEvaluationLabel(_ notification: Notification) {
//    guard let userInfo = notification.userInfo,
//          let rate = userInfo["rate"] as? CGFloat else { return }
//
//    if let collectionView = self.superview as? UICollectionView,
//       let indexPath = collectionView.indexPath(for: self),
//       indexPath.item == selectedCellIndex {
//        evaluationLabel.text = "평가 함 ⭐️\(rate)"
//        evaluationLabel.textColor = .black
//        evaluationLabel.font = .boldSystemFont(ofSize: 13)
//    }
//}
//
//collectionViewCell에 받아서 evaluationLabel의 text를 바꾸고 있는데 모든 셀이 아닌 선택한 셀의 evaluationLabel의 text만 바뀌게 하기
