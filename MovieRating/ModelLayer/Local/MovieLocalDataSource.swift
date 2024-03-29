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
    
    func getStorageMovie(movieId: Int) -> MovieData? {
        do {
            let realm = try Realm()
            return realm.object(ofType: MovieData.self, forPrimaryKey: movieId)
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            return nil
        }
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
    
    func getUserRate(movieId: Int, callback: (Double?) -> Void) {
        do {
            let realm = try Realm()
            if let movieData = realm.object(ofType: MovieData.self, forPrimaryKey: movieId) {
                callback(movieData.userRate)
            } else {
                callback(nil)
            }
        } catch {
            print("Failed to get user rate: \(error.localizedDescription)")
            callback(nil)
        }
    }
    
    func addStorageMovie(movieData: MovieData, callback: (Bool) -> Void) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(movieData)
                callback(true)
            }
        } catch let error as NSError {
            callback(false)
            print("Error: \(error.localizedDescription)")
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
    
    func updateUserRate(movieId: Int, rate: Double, callback: (Bool) -> Void) {
        do {
            let realm = try Realm()
            if let movieData = realm.object(ofType: MovieData.self, forPrimaryKey: movieId) {
                try realm.write {
                    movieData.userRate = rate
                }
                callback(true)
            } else {
                callback(false)
            }
        } catch {
            callback(false)
            print("Failed to update user rate: \(error.localizedDescription)")
        }
    }
    
    func deleteStorageMovie(movieId: Int, callback: (Bool) -> Void) {
        do {
            let realm = try Realm()
            try realm.write {
                if let storedMovie = realm.object(ofType: MovieData.self, forPrimaryKey: movieId) {
                    realm.delete(storedMovie)
                    callback(true)
                } else {
                    callback(false)
                }
            }
        } catch {
            callback(false)
            print("Failed to delete movie: \(error.localizedDescription)")
        }
    }
}
