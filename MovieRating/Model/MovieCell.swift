//
//  MovieCell.swift
//  MovieRating
//
//  Created by 혜리 on 2023/04/03.
//

import UIKit

class MovieCell: UITableViewCell {
        
    var thumbnailImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var titleAndYearLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var castLabel: UILabel = {
        let label = UILabel()
        label.text = "현빈"
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var ratingImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "star")
        return img
    }()
    
    var ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "9.4"
        label.textColor = .red
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    lazy var ratingStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [ratingImage, ratingLabel])
        view.spacing = 4
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var storageButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "bookmark")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addViews()
        setupAddTarget()
        setTableViewCell()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubview(thumbnailImage)
        addSubview(titleAndYearLabel)
        addSubview(castLabel)
        addSubview(ratingStackView)
        addSubview(storageButton)
    }
    
    private func setupAddTarget() {
        storageButton.addTarget(self, action: #selector(storageSend), for: .touchUpInside)
    }
    
    private func setTableViewCell() {
        selectionStyle = .none
        backgroundColor = .white
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            thumbnailImage.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            thumbnailImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            thumbnailImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            thumbnailImage.widthAnchor.constraint(equalToConstant: 80),
            
            titleAndYearLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            titleAndYearLabel.leadingAnchor.constraint(equalTo: thumbnailImage.trailingAnchor, constant: 15),
            titleAndYearLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            
            castLabel.topAnchor.constraint(equalTo: titleAndYearLabel.bottomAnchor, constant: 20),
            castLabel.leadingAnchor.constraint(equalTo: thumbnailImage.trailingAnchor, constant: 15),
            castLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            
            ratingImage.widthAnchor.constraint(equalToConstant: 15),
            ratingImage.heightAnchor.constraint(equalToConstant: 15),
            
            ratingStackView.topAnchor.constraint(equalTo: castLabel.bottomAnchor, constant: 5),
            ratingStackView.leadingAnchor.constraint(equalTo: thumbnailImage.trailingAnchor, constant: 15),
            ratingStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            
            storageButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            storageButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
        ])
    }
    
    @objc private func storageSend() {
        if storageButton.isSelected == true {
            storageButton.isSelected = false
            let image = UIImage(systemName: "bookmark")
            storageButton.setImage(image, for: .normal)
            
        } else {
            storageButton.isSelected = true
            let image = UIImage(systemName: "bookmark.fill")
            storageButton.setImage(image, for: .normal)
        }
    }
}
