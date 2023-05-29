//
//  MovieSearchResult.swift
//  MovieRating
//
//  Created by 혜리 on 2023/05/29.
//

import Foundation


class MovieSearchResult {
    
    let movies: Array<Movie>
    let totalCount: Int
    let indexPaths: [IndexPath]
    
    init(movies: Array<Movie>, totalCount: Int, indexPaths: [IndexPath]) {
        self.movies = movies
        self.totalCount = totalCount
        self.indexPaths = indexPaths
    }
    
    static let EMPTY = MovieSearchResult(movies: Array(), totalCount: 0, indexPaths: [])
}

