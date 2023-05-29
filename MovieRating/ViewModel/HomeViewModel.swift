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
        ) { response in
            
            let newMovies = response.results
            let totalResults = response.totalResults
            self.totalPages = response.totalPages
            
            var indexPaths = [IndexPath]()
            var resultMovies = self.movieSearchResult.value.movies
            
            if self.currentPage == 1 {
                resultMovies = newMovies.map { $0 }
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
    
    func resetPages() {
        currentPage = 1
        movieSearchResult.value = MovieSearchResult.EMPTY
    }
    
    func clear() {
        query = ""
    }
}
