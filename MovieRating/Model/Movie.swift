//
//  Movie.swift
//  MovieRating
//
//  Created by 혜리 on 2023/04/05.
//

import UIKit

struct Response: Codable {
    let results: [Movie]
}

struct Movie: Codable, Equatable {
    let id: Int
    let posterPath: String?
    let title: String
    let releaseDate: String
    let genreIds: [Int]
    let voteAverage: Double?
    let isStorageButtonSelected = false

    var genres: [Genre] {
        return genreIds.compactMap { id in
            return GenreList.shared.genres.first { $0.id == id }
        }
    }

    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: releaseDate) else { return "" }

        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }

    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id &&
               lhs.posterPath == rhs.posterPath &&
               lhs.title == rhs.title &&
               lhs.releaseDate == rhs.releaseDate &&
               lhs.genreIds == rhs.genreIds &&
               lhs.voteAverage == rhs.voteAverage
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case posterPath = "poster_path"
        case title = "title"
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
        case voteAverage = "vote_average"
    }
}


struct Genre: Codable {
    let id: Int
    let name: String
}

struct GenreList {
    static let shared = GenreList()
    let genres: [Genre]
    
    private init() {
        genres = [
            Genre(id: 12, name: "Adventure"),
            Genre(id: 14, name: "Fantasy"),
            Genre(id: 16, name: "Animation"),
            Genre(id: 18, name: "Drama"),
            Genre(id: 27, name: "Horror"),
            Genre(id: 28, name: "Action"),
            Genre(id: 35, name: "Comedy"),
            Genre(id: 36, name: "History"),
            Genre(id: 37, name: "Western"),
            Genre(id: 53, name: "Thriller"),
            Genre(id: 80, name: "Crime"),
            Genre(id: 99, name: "Documentary"),
            Genre(id: 878, name: "Science Fiction"),
            Genre(id: 9648, name: "Mystery"),
            Genre(id: 10402, name: "Music"),
            Genre(id: 10749, name: "Romance"),
            Genre(id: 10751, name: "Family"),
            Genre(id: 10752, name: "War"),
            Genre(id: 10770, name: "TV Movie")
        ]
    }
}
