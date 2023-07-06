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
    
    func getMovieList(query: String, page: String, callback: @escaping (MovieSearchResponse) -> Void) {
        remoteDataSource.getMovieList(query: query, page: page, callback: { response in
            callback(self.makeMovieSearchResponse(response: response))
        })
    }
    
    private func makeMovieSearchResponse(response: Response) -> MovieSearchResponse {
        let newMovies = response.results.map {
            if let storageMovie = self.getStorageMovie(id: $0.id) {
                return $0.toDto(userRate: storageMovie.userRate, isBookmarked: storageMovie.isBookmarked)
            } else {
                return $0.toDto(userRate: 0, isBookmarked: false)
            }
        }
        
        let totalResults = response.totalResults
        
        return MovieSearchResponse(movies: newMovies, totalCount: totalResults, totalPages: response.totalPages)
    }
    
    func getStorageMovieList(callback: ([Movie]) -> Void) {
        localDataSource.getStorageMovieList(callback: { movieDataList in
            let result: [Movie] = movieDataList.map { movieData in
                print("movieData: \(movieData)")
                return movieData.toDto()
            }

            callback(result)
        })
    }
    
    func addStorageMovie(movie: Movie, callback: (Bool) -> Void) {
        localDataSource.addStorageMovie(movieData: movie.toLocalModel(), callback: callback)
    }
    
    func deleteStorageMovie(movieId: Int, callback: (Bool) -> Void) {
        localDataSource.deleteStorageMovie(movieId: movieId, callback: callback)
    }
    
    func updateEvaluation(movie: Movie, changedRating: CGFloat, callback: (Bool) -> Void) {
        localDataSource.updateEvaluation(movie: movie.toLocalModel(), changedRating: changedRating, callback: callback)
    }
    
    func updateUserRate(movieId: Int, rate: Double, callback: (Bool) -> Void) {
        localDataSource.updateUserRate(movieId: movieId, rate: rate, callback: callback)
    }
    
    func getUserRate(movieId: Int, completion: (Double?) -> Void) {
        localDataSource.getUserRate(movieId: movieId, completion: completion)
    }
}
