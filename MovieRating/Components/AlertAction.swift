//
//  AlertAction.swift
//  MovieRating
//
//  Created by 혜리 on 2023/04/27.
//

import UIKit

class AlertAction: UIViewController {
    
    private var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var actionSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(deleteButton)
        return view
    }()
    
    var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("보관함에서 삭제하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var defaultHeight: CGFloat = 130
    private var alertActionViewTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        setBackgroundView()
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showActionSheet()
    }
    
    private func addViews() {
        view.addSubview(backgroundView)
        view.addSubview(actionSheetView)
        view.addSubview(deleteButton)
    }
    
    private func setBackgroundView() {
        let backgroundViewTap = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped(_:)))
        backgroundView.addGestureRecognizer(backgroundViewTap)
        backgroundView.isUserInteractionEnabled = true
    }
    
    private func setConstraints() {
        let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
        alertActionViewTopConstraint = actionSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            alertActionViewTopConstraint,
            actionSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            actionSheetView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            actionSheetView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            deleteButton.topAnchor.constraint(equalTo: actionSheetView.topAnchor, constant: 30),
            deleteButton.centerXAnchor.constraint(equalTo: actionSheetView.centerXAnchor)
        ])
    }
    
    private func showActionSheet() {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        
        alertActionViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - defaultHeight
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.backgroundView.alpha = 0.7
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func backgroundViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        alertActionViewTopConstraint.constant = safeAreaHeight + bottomPadding
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.backgroundView.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
}
