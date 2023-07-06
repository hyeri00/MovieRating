//
//  UIViewController+SafariViewController.swift
//  MovieRating
//
//  Created by 혜리 on 2023/07/03.
//

import UIKit
import SafariServices

extension UIViewController {
    func presentSafariViewController(withMovieID movieID: Int) {
        let movieURLString = "https://www.themoviedb.org/movie/\(movieID)"
        guard let movieURL = URL(string: movieURLString) else { return }
        
        let safariViewController = SFSafariViewController(url: movieURL)
        present(safariViewController, animated: true, completion: nil)
    }
}
