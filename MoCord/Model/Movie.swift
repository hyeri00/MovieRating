//
//  Model.swift
//  MovieRating
//
//  Created by 혜리 on 2023/06/04.
//

import Foundation

class Movie: CustomStringConvertible {
    let id: Int
    let posterPath: String?
    let title: String
    let year: String
    let genres: [Genre]
    let voteAverageString: String
    var userRate: Double
    var isBookmarked: Bool
    
    init(id: Int, posterPath: String?, title: String, year: String, genres: [Genre], voteAverageString: String, userRate: Double, isBookmarked: Bool) {
        self.id = id
        self.posterPath = posterPath
        self.title = title
        self.year = year
        self.genres = genres
        self.voteAverageString = voteAverageString
        self.userRate = userRate
        self.isBookmarked = isBookmarked
    }
    
    var description: String {
        return "Movie(id: \(id) \n title: \(title) \n userRate: \(userRate))"
    }
}
