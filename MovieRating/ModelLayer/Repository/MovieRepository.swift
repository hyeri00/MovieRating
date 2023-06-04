//
//  MovieRepository.swift
//  MovieRating
//
//  Created by 원우석 on 2023/05/15.
//

import Foundation
import RealmSwift

class MovieRepository {
    
    static let shared = MovieRepository()
    
    private let remoteDataSource: MovieRemoteDataSource!
    private let localDataSource: MovieLocalDataSource!
    
    
    private init() {
        remoteDataSource = MovieRemoteDataSource.shared
        localDataSource = MovieLocalDataSource.shared
    }
    
    func getStorageMovie(id: Int) -> Movie? {
        return localDataSource.getStorageMovie(movieId: id)?.toDto()
    }
    
    func getMovieList(query: String, page: String, callback: @escaping (Response) -> Void) {
        remoteDataSource.getMovieList(query: query, page: page, callback: callback)
    }
    
    func getStorageMovieList(callback: (Results<MovieData>) -> Void) {
        localDataSource.getStorageMovieList(callback: callback)
    }
    
    func addStorageMovie(movie: MovieData, callback: (Bool) -> Void) {
        localDataSource.addStorageMovie(movieData: movie, callback: callback)
    }
    
    func deleteStorageMovie(movieId: Int, callback: (Bool) -> Void) {
        localDataSource.deleteStorageMovie(movieId: movieId, callback: callback)
    }
    
    func updateEvaluation(movie: MovieData, changedRating: CGFloat, callback: (Bool) -> Void) {
        localDataSource.updateEvaluation(movie: movie, changedRating: changedRating, callback: callback)
    }
}
