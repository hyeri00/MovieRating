//
//  MovieMapper.swift
//  MovieRating
//
//  Created by 혜리 on 2023/06/04.
//

import Foundation

extension MovieResponse {
    func toDto(
        userRate: Double,
        isBookmarked: Bool
    ) -> Movie {
        let genres: [Genre] = makeGenres(genreIds: genreIds)
        
        let year = makeYear(releaseDate: releaseDate)
        
        let voteAverageString: String = makeVoteAverageString(voteAverage: voteAverage ?? 0)
        
        return Movie(
            id: id,
            posterPath: posterPath,
            title: title,
            year: year,
            genres: genres,
            voteAverageString: voteAverageString,
            userRate: userRate,
            isBookmarked: isBookmarked
        )
    }
    
    private func makeYear(releaseDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: releaseDate) else { return "" }
        dateFormatter.dateFormat = "yyyy"
        let year: String = dateFormatter.string(from: date)
        return year
    }
    
    private func makeVoteAverageString(voteAverage: Double) -> String {
        return String(format: "%.1f", voteAverage)
    }
    
}

extension Movie {
    func toLocalModel() -> MovieData {
        let movieData = MovieData()
        movieData.id = id
        movieData.posterPath = posterPath
        movieData.title = title
        movieData.genreIds = genres.map({ genre in
            genre.id
        })
        movieData.voteAverageString = voteAverageString
        movieData.userRate = 0
        movieData.isBookmarked = true
        
        return movieData
    }
}

extension MovieData {
    func toDto() -> Movie {
        return Movie(
            id: id,
            posterPath: posterPath,
            title: title,
            year: year,
            genres: makeGenres(genreIds: genreIds),
            voteAverageString: voteAverageString,
            userRate: userRate,
            isBookmarked: isBookmarked
        )
    }
}

func makeGenres(genreIds: [Int]) -> [Genre] {
    return genreIds.compactMap { id in
        return GenreList.shared.genres.first { $0.id == id }
    }
}
