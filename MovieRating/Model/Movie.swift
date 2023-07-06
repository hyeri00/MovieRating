//
//  Model.swift
//  MovieRating
//
//  Created by 혜리 on 2023/06/04.
//

import Foundation

struct Movie: Equatable {
    let id: Int
    let posterPath: String?
    let title: String
    let year: String
    let genres: [Genre]
    let voteAverageString: String
    var userRate: Double
    var isBookmarked: Bool
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id &&
        lhs.posterPath == rhs.posterPath &&
        lhs.title == rhs.title &&
        lhs.year == rhs.year &&
        lhs.genres == rhs.genres &&
        lhs.voteAverageString == rhs.voteAverageString &&
        lhs.userRate == rhs.userRate &&
        lhs.isBookmarked == rhs.isBookmarked
    }
}

