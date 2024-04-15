//
//  RateView.swift
//  MovieRating
//
//  Created by 혜리 on 2023/04/19.
//

import UIKit

class RateView: RatingView {

    var starNumber: Int = 5 { didSet { bind() } }
    open var currentStar: Int = 0
    var buttons: [UIButton] = []

    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 12
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var starFillImage: UIImage? = {
        return UIImage(systemName: "star.fill")
    }()

    lazy var starEmptyImage: UIImage? = {
        return UIImage(systemName: "star")
    }()

    override func configure() {
        super.configure()

        starNumber = 5
        
        addViews()
        setConstraints()
    }

    private func addViews() {
        addSubview(stackView)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
    
    func updateButtonAppearance() {
        for (index, button) in buttons.enumerated() {
            if index <= currentStar - 1 {
                button.setImage(starFillImage, for: .normal)
            } else {
                button.setImage(starEmptyImage, for: .normal)
            }
        }
    }

    override func bind() {
        super.bind()

        for i in 0..<5 {
            let button = UIButton()
            button.setImage(starEmptyImage, for: .normal)
            button.tag = i
            buttons += [button]
            stackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
        }
    }

    @objc private func didTapButton(sender: UIButton) {
        let end = sender.tag

        for i in 0...end {
            buttons[i].setImage(starFillImage, for: .normal)
        }
        for i in end + 1..<starNumber {
            buttons[i].setImage(starEmptyImage, for: .normal)
        }
        
        currentStar = (end + 1 == currentStar) ? 0 : end + 1

        sendActions(for: .valueChanged)
    }
}
