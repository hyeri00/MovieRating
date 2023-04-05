//
//  ToastMessage.swift
//  MovieRating
//
//  Created by 혜리 on 2023/04/05.
//

import UIKit
import SnapKit

class ToastMessage {
    var toastViews = [UIView?]()
    
    func showToast(image: UIImage, message: String, buttonTitle: String) {
        let toastView = UIView()
        toastViews.append(toastView)
        
        if let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            toastView.alpha = 0.0
            toastView.backgroundColor = .white
            toastView.layer.cornerRadius = 8
            
            window.addSubview(toastView)
            window.bringSubviewToFront(toastView)
            
            toastView.snp.makeConstraints({
                $0.width.equalTo(327)
                $0.height.equalTo(58)
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().offset(-320)
            })
            
            let img = UIImageView()
            img.image = image
            toastView.addSubview(img)
            img.snp.makeConstraints {
                $0.left.equalTo(20)
                $0.centerY.equalToSuperview()
            }
            
            let label = UILabel()
            toastView.addSubview(label)
            label.text = message
            label.textColor = .black
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 14)
            label.snp.makeConstraints({
                $0.left.equalTo(50)
                $0.centerY.equalToSuperview()
            })
            
            let button = UIButton(type: .custom)
            toastView.addSubview(button)
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .clear
            button.titleLabel?.font = .boldSystemFont(ofSize: 14)
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            button.snp.makeConstraints({
                $0.left.equalTo(250)
                $0.centerY.equalToSuperview()
            })
            
            UIView.animate(withDuration: 4.0, delay: 0.0, options: [.curveEaseOut], animations: {
                toastView.alpha = 1.0
            })
            UIView.animate(withDuration: 2.0, delay: 0.0, options: [.curveEaseIn], animations: {
                toastView.alpha = 0.0
            }, completion: {(isCompleted) in
                toastView.removeFromSuperview()
            })
        }
    }
    
    @objc func buttonAction() {
    }
}
