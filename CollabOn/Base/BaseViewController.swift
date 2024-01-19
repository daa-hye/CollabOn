//
//  BaseViewController.swift
//  CollabOn
//
//  Created by 박다혜 on 1/2/24.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.backgroundPrimary
        
        configHierarchy()
        setLayout()
        setUIProperties()
        bindRx()
    }

    func configHierarchy() {}
    func setLayout() {}
    func setUIProperties() {}
    func bindRx() {}
}

extension BaseViewController {

    func showToast(message: String, constraintView: UIView, offset: Int) {
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.backgroundColor = .main
        toastLabel.textColor = UIColor.white
        toastLabel.font = .body
        toastLabel.textAlignment = .center
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 8
        toastLabel.clipsToBounds  =  true

        self.view.addSubview(toastLabel)
        toastLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(constraintView.snp.top).offset(offset)
            $0.width.equalTo(toastLabel.intrinsicContentSize.width + 32.0)
            $0.height.equalTo(36)
        }

        UIView.animate(withDuration: 3, delay: 1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

    func showToast(message: String, offset: Int) {
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.backgroundColor = .main
        toastLabel.textColor = UIColor.white
        toastLabel.font = .body
        toastLabel.textAlignment = .center
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 8
        toastLabel.clipsToBounds  =  true

        self.view.addSubview(toastLabel)
        toastLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(offset)
            $0.width.equalTo(toastLabel.intrinsicContentSize.width + 32.0)
            $0.height.equalTo(36)
        }

        UIView.animate(withDuration: 3, delay: 1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

}
