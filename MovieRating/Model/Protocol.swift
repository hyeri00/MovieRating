//
//  Protocol.swift
//  MovieRating
//
//  Created by 혜리 on 2023/04/10.
//

import UIKit

protocol MovieTableViewCellDelegate: AnyObject {
    func didTapLikeButton(cell: MovieTableViewCell)
}
