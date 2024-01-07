//
//  PrimaryButton.swift
//  CollabOn
//
//  Created by 박다혜 on 1/3/24.
//

import UIKit

class PrimaryButton: UIButton {

    init(title: String) {

        var titleAttribute = AttributedString.init(title)
        titleAttribute.font = UIFont.title2
        titleAttribute.foregroundColor = .white

        super.init(frame: .zero)

        configuration = .filled()
        configuration?.imagePadding = 8
        configuration?.attributedTitle = titleAttribute

        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 8
        heightAnchor.constraint(equalToConstant: 44).isActive = true

        configurationUpdateHandler =  { button in
            switch button.state {
            case .disabled:
                button.configuration?.background.backgroundColor = .inactive
            default:
                button.configuration?.background.backgroundColor = .main
            }
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
