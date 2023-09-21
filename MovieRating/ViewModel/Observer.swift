//
//  Observer.swift
//  MovieRating
//
//  Created by 혜리 on 2023/05/29.
//

import Foundation

final class Observer<T> {
    typealias Listener = (T) -> Void
  
    var listener: Listener?
    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func bind(listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
