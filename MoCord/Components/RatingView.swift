//
//  RatingView.swift
//  MovieRating
//
//  Created by 혜리 on 2023/04/19.
//

import UIKit

class RatingView: UIControl {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {}
    func bind() {}
}
