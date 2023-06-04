//
//  MovieData.swift
//  MovieRating
//
//  Created by 혜리 on 2023/04/29.
//

import RealmSwift

class MovieData: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var posterPath: String?
    @objc dynamic var title: String = ""
    @objc dynamic var year: String = ""
    @objc dynamic var genreIds: [Int] = []
    @objc dynamic var voteAverageString: String = ""
    @objc dynamic var userRate: Double = 0
    @objc dynamic var isBookmarked = false
        
    override static func primaryKey() -> String? {
        return "id"
    }
}
