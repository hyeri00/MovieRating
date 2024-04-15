//
//  UIImageView+Kingfisher.swift
//  MovieRating
//
//  Created by 혜리 on 2023/07/04.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(withPosterPath posterPath: String?) {
        if let path = posterPath,
            let imageURL = URL(string: "https://image.tmdb.org/t/p/w500/\(path)") {
            kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholderImage"))
        } else {
            image = UIImage(named: "placeholderImage")
        }
    }
}
