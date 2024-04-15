//
//  MovieDetailResult.swift
//  MovieRating
//
//  Created by 혜리 on 2023/07/10.
//

import Foundation

class MovieDetailResult {
    
    var movies: Array<Movie>
    
    init(movies: Array<Movie>) {
        self.movies = movies
    }
    
    static let EMPTY = MovieDetailResult(movies: Array())
}

class MovieDetailResponse {
    
    let movies: Array<Movie>
    
    init(movies: Array<Movie>) {
        self.movies = movies
    }
}
