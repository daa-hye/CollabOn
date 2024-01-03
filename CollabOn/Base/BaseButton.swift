//
//  BaseButton.swift
//  CollabOn
//
//  Created by 박다혜 on 1/3/24.
//

import UIKit

class BaseButton: UIButton {

    init(title: String) {
        super.init(frame: .zero)

        var config = UIButton.Configuration.filled()
        config.imagePadding = 8
        config.baseBackgroundColor = .main

        var titleAttribute = AttributedString.init(title)
        titleAttribute.font = UIFont.title2
        titleAttribute.foregroundColor = .white

        config.attributedTitle = titleAttribute

        self.configuration = config
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 8
        self.heightAnchor.constraint(equalToConstant: 44).isActive = true

    }

    init(type: ButtonType) {
        super.init(frame: .zero)

        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = type.backgroundColor
        config.imagePadding = 8

        var titleAttribute = AttributedString.init(type.title)
        titleAttribute.font = UIFont.title2
        titleAttribute.foregroundColor = type.titleColor
        config.attributedTitle = titleAttribute
        self.configuration = config

        self.setImage(type.image, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 8
        self.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension BaseButton {

    enum ButtonType {
        case apple
        case kakao

        var title: String {
            switch self {
            case .apple:
                return String(localized: "Apple로 계속하기")
            case .kakao:
                return String(localized: "카카오톡으로 계속하기")
            }
        }

        var image: UIImage {
            switch self {
            case .apple:
                return .apple
            case .kakao:
                return .kakao
            }
        }

        var backgroundColor: UIColor {
            switch self {
            case .apple:
                return .black
            case .kakao:
                return .kakao
            }
        }

        var titleColor: UIColor {
            switch self {
            case .apple:
                return .white
            case .kakao:
                return .black.withAlphaComponent(0.85)
            }
        }
    }

}
