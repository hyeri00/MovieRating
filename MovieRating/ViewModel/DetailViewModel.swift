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
        movieRepository.getStorageMovieList { movies in
            movieDetailResult.value = MovieDetailResult(movies: movies)
        }
    }
    
    func deleteStorageMovie(movieId: Int, callback: @escaping (Bool) -> Void) {
        movieRepository.deleteStorageMovie(movieId: movieId, callback: callback)
    }
    
    func updateUserRate(movieId: Int, rate: Double, callback: @escaping (Bool) -> Void) {
        movieRepository.updateUserRate(movieId: movieId, rate: rate, callback: callback)
    }
    
    func getUserRate(movieId: Int, callback: @escaping (Double?) -> Void) {
        movieRepository.getUserRate(movieId: movieId, callback: callback)
    }
}
