//
//  Genre.swift
//  MovieRating
//
//  Created by 혜리 on 2023/06/04.
//

import Foundation

struct Genre: Codable, Equatable {
    let id: Int
    let name: String
    
    static func == (lhs: Genre, rhs: Genre) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
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
