//
//  SocialLoginButton.swift
//  CollabOn
//
//  Created by 박다혜 on 1/6/24.
//

import UIKit

final class SocialLoginButton: PrimaryButton {

    init(type: ButtonType) {

        super.init(title: type.title)

        var titleAttribute = AttributedString.init(type.title)
        titleAttribute.font = UIFont.title2
        titleAttribute.foregroundColor = type.titleColor

        configuration = .filled()
        configuration?.imagePadding = 8
        configuration?.attributedTitle = titleAttribute
        configuration?.background.backgroundColor = type.backgroundColor

        self.setImage(type.image, for: .normal)

        configurationUpdateHandler = nil

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SocialLoginButton {

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
