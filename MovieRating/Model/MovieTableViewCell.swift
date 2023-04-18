//
//  MovieTableViewCell.swift
//  MovieRating
//
//  Created by 혜리 on 2023/04/03.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
        
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
    
    var genreLabel: UILabel = {
        let label = UILabel()
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
    
    lazy var storageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addViews()
        setTableViewCell()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubview(thumbnailImage)
        addSubview(titleAndYearLabel)
        addSubview(genreLabel)
        addSubview(ratingStackView)
        contentView.addSubview(storageButton)
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
            titleAndYearLabel.trailingAnchor.constraint(equalTo: storageButton.trailingAnchor, constant: -15),
            
            genreLabel.leadingAnchor.constraint(equalTo: thumbnailImage.trailingAnchor, constant: 15),
            genreLabel.trailingAnchor.constraint(equalTo: storageButton.trailingAnchor, constant: -15),
            genreLabel.bottomAnchor.constraint(equalTo: ratingStackView.topAnchor, constant: -5),
            
            ratingImage.widthAnchor.constraint(equalToConstant: 15),
            ratingImage.heightAnchor.constraint(equalToConstant: 15),
            
            ratingStackView.leadingAnchor.constraint(equalTo: thumbnailImage.trailingAnchor, constant: 15),
            ratingStackView.trailingAnchor.constraint(equalTo: storageButton.trailingAnchor, constant: -15),
            ratingStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            
            storageButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            storageButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
        ])
    }
}
