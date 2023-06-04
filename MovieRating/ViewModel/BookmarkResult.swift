//
//  BookmarkResult.swift
//  MovieRating
//
//  Created by 혜리 on 2023/06/04.
//

import Foundation

class BookmarkResult {
    
    let movie: Movie
    
    init(movies: Array<Movie>, totalCount: Int, indexPaths: [IndexPath]) {
        self.movies = movies
        self.totalCount = totalCount
        self.indexPaths = indexPaths
    }
}
