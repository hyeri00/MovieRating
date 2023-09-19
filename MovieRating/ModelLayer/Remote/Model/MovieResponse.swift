//
//  Movie.swift
//  MovieRating
//
//  Created by 혜리 on 2023/04/05.
//

import UIKit

struct Response: Codable {
    let results: [MovieResponse]
    let page: Int
    let totalResults: Int
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}

struct MovieResponse: Codable {
    let id: Int
    let posterPath: String?
    let title: String
    let releaseDate: String
    let genreIds: [Int]
    let voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case posterPath = "poster_path"
        case title = "title"
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
        case voteAverage = "vote_average"
    }
}
