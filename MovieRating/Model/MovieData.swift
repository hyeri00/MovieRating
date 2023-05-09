//
//  MovieData.swift
//  MovieRating
//
//  Created by 혜리 on 2023/04/29.
//

import RealmSwift

class MovieData: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var thumbnailImageData: Data?
    @objc dynamic var title: String = ""
    @objc dynamic var year: String = ""
    @objc dynamic var genre: String = ""
    @objc dynamic var rating: String = ""
    @objc dynamic var userRate: Double = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
