//
//  MovieStorageResult.swift
//  MovieRating
//
//  Created by 혜리 on 2023/07/09.
//

import Foundation

class MovieStorageResult {
    
    var movies: Array<Movie>
    
    init(movies: Array<Movie>) {
        self.movies = movies
    }
    
    static let EMPTY = MovieStorageResult(movies: Array())
}

class MovieStorageResponse {
    
    let movies: Array<Movie>
    
    init(movies: Array<Movie>) {
        self.movies = movies
    }
}
