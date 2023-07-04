//
//  HomeViewModel.swift
//  MovieRating
//
//  Created by 혜리 on 2023/05/29.
//

import Foundation

class HomeViewModel {
    
    private let movieRepository: MovieRepository! = MovieRepository.shared
    
    var query: String = ""
    private var currentPage = 1
    private var totalPages = 1
    
    let movieSearchResult: Observer<MovieSearchResult> = Observer(MovieSearchResult.EMPTY)
    
    let isBookmarkedMovie: Observer<Movie?> = Observer(nil)
    
    let isUnbookmarkedMovie: Observer<Movie?> = Observer(nil)
    
    init() {
        
    }
    
    func loadNextPage() {
        let hasNextPage = currentPage < totalPages
        
        if hasNextPage {
            if !query.isEmpty {
                currentPage += 1
                search(query: query)
            }
        }
    }
    
    func search(query: String) {
        self.query = query
        
        movieRepository.getMovieList(
            query: query,
            page: "\(currentPage)"
        ) { result in
            
            let newMovies = result.movies
            let totalResults = result.totalCount
            self.totalPages = result.totalPages
            
            var indexPaths = [IndexPath]()
            var resultMovies = self.movieSearchResult.value.movies
            
            if self.currentPage == 1 {
                resultMovies = newMovies
            } else {
                let lastRowIndex = self.movieSearchResult.value.movies.count - 1
                
                for (index, movie) in newMovies.enumerated() {
                    let indexPath = IndexPath(row: lastRowIndex + index + 1, section: 0)
                    resultMovies.append(movie)
                    indexPaths.append(indexPath)
                }
            }
            
            self.movieSearchResult.value = MovieSearchResult(movies: resultMovies, totalCount: totalResults, indexPaths: indexPaths)
            self.currentPage += 1
        }
    }
    
    func changeBookmark(movieId: Int) {
        if var movie = movieSearchResult.value.movies.first(where: { movie in movie.id == movieId}) {
            let isBookmarked = movie.isBookmarked
            movie.isBookmarked = !isBookmarked

            if (isBookmarked) {
                movieRepository.deleteStorageMovie(movieId: movieId) { isSucceed in
                    if (isSucceed) {
                        isUnbookmarkedMovie.value = movie
                    }
                }
            } else {
                movieRepository.addStorageMovie(movie: movie) { isSucceed in
                    if (isSucceed) {
                        isBookmarkedMovie.value = movie
                    }
                }
            }
            
        } else {
            print("not found movie \(movieId)")
        }
    }
    
    func resetPages() {
        currentPage = 1
        movieSearchResult.value = MovieSearchResult.EMPTY
    }
    
    func clear() {
        query = ""
    }
}
