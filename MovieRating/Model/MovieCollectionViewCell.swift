//
//  MovieCollectionViewCell.swift
//  MovieRating
//
//  Created by 혜리 on 2023/04/05.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    var thumbnailImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    var evaluationLabel: UILabel = {
        let label = UILabel()
        label.text = "평가 안 함 ⭐️ 0.0"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 13)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, evaluationLabel])
        view.spacing = 5
        view.axis = .vertical
        view.distribution = .fillEqually
        view.alignment = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        getData()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        contentView.addSubview(thumbnailImage)
        contentView.addSubview(stackView)
    }
    
    private func getData() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateEvaluationLabel(_:)), name: NSNotification.Name("didChangeRate"), object: nil)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            thumbnailImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            thumbnailImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            thumbnailImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            thumbnailImage.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -10),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    @objc func updateEvaluationLabel(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
                let rate = userInfo["rate"] as? CGFloat else { return }
        evaluationLabel.text = "평가 함 ⭐️\(rate)"
        evaluationLabel.textColor = .black
        evaluationLabel.font = .boldSystemFont(ofSize: 13)
    }
}
