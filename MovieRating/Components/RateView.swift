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
                button.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                button.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }

    override func bind() {
        super.bind()

        for i in 0..<5 {
            let button = UIButton()
            button.setImage(UIImage(systemName: "star"), for: .normal)
            button.tag = i
            buttons += [button]
            stackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
        }
    }

    @objc private func didTapButton(sender: UIButton) {
        let end = sender.tag

        for i in 0...end {
            buttons[i].setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        for i in end + 1..<starNumber {
            buttons[i].setImage(UIImage(systemName: "star"), for: .normal)
        }
        currentStar = end + 1
        sendActions(for: .valueChanged)
    }
}
