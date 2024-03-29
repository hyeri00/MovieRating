//
//  MovieCollectionViewCell.swift
//  MovieRating
//
//  Created by 혜리 on 2023/04/05.
//

import UIKit
import RealmSwift

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
        label.text = Storage.unevaluationState
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
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        contentView.addSubview(thumbnailImage)
        contentView.addSubview(stackView)
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
}
