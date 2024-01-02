//
//  BaseButton.swift
//  CollabOn
//
//  Created by 박다혜 on 1/3/24.
//

import UIKit

class BaseButton: UIButton {

    init() {
        super.init(frame: .zero)
        self.backgroundColor = .main
        self.titleLabel?.font = UIFont.title2
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
