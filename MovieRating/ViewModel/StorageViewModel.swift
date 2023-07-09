//
//  StorageViewModel.swift
//  MovieRating
//
//  Created by 혜리 on 2023/07/09.
//

import UIKit
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
    
    func updateEvaluationLabel(movie: Movie, rate: CGFloat) {
        movieRepository.updateEvaluation(movie: movie, changedRating: rate) { isSuccess in
            let evaluationText = rate > 0.0 ? "\(Storage.evaluationState) \(rate)" : Storage.unevaluationState
            let textColor = rate > 0.0 ? UIColor.black : UIColor.lightGray
        }
    }
}
