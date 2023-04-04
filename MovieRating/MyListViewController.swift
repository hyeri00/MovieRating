//
//  MyListViewController.swift
//  MovieRating
//
//  Created by 혜리 on 2023/04/03.
//

import UIKit

class MyListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setNavigationBar()
    }
    
    private func setup() {
        view.backgroundColor = .white
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        navigationItem.title = "보관함"
    }
}
