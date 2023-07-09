//
//  DetailViewModel.swift
//  MovieRating
//
//  Created by 혜리 on 2023/07/10.
//

import Foundation

class DetailViewModel {
    
    private let movieRepository: MovieRepository! = MovieRepository.shared

    let movieDetailResult: Observer<MovieDetailResult> = Observer(MovieDetailResult.EMPTY)
    
    init() {
        
    }
    
    func isDetailMovieList() {
        
    }
}
