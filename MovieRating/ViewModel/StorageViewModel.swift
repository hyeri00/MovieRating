//
//  StorageViewModel.swift
//  MovieRating
//
//  Created by 혜리 on 2023/07/09.
//

import Foundation

class StorageViewModel {
    
    private let movieRepository: MovieRepository! = MovieRepository.shared

    let movieStorageResult: Observer<MovieStorageResult> = Observer(MovieStorageResult.EMPTY)
    
    init() {
        
    }
    func getStorageMovieList() {
        movieRepository.getStorageMovieList { movie in
            self.movieStorageResult.value.movies = movie
        }
    }
    
    func updateEvaluationLabel() {
//        movieRepository.updateEvaluation(movie: <#T##Movie#>, changedRating: <#T##CGFloat#>) { <#Bool#> in
//            <#code#>
//        }
    }
}
