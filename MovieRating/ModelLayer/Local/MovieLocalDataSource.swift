//
//  MovieLocalDataSource.swift
//  MovieRating
//
//  Created by 혜리 on 2023/05/15.
//

import Foundation
import RealmSwift

class MovieLocalDataSource {
    
    static let shared = MovieLocalDataSource()
    
    private init() {
        
    }
    
    func isSelectedMovie() {
        
    }
    
    func getStorageMovieList(callback: (Results<MovieData>) -> Void) {
        do {
            let realm = try Realm()
            let moviesData = realm.objects(MovieData.self)
            callback(moviesData)
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func deleteStorageMovie(movie: MovieData, callback: (Bool) -> Void) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(movie)
                
                callback(true)
            }
        } catch {
            callback(false)
            print("Failed to delete movie: \(error.localizedDescription)")
        }
    }
    
    func updateEvaluation(movie: MovieData, changedRating: CGFloat, callback: (Bool) -> Void) {
        do {
            let realm = try Realm()
            try realm.write {
                movie.userRate = changedRating
                callback(true)
            }
        } catch let error as NSError {
            callback(false)
            print("Error updating movie userRate: \(error.localizedDescription)")
        }
    }
}
