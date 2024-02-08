//
//  CancelButton.swift
//  CollabOn
//
//  Created by 박다혜 on 1/30/24.
//

import UIKit

class CancelButton: PrimaryButton {

    init() {
        super.init(title: String(localized: "취소"))

        var titleAttribute = AttributedString.init(String(localized: "취소"))
        titleAttribute.font = UIFont.title2
        titleAttribute.foregroundColor = .white

        configuration = .filled()
        configuration?.imagePadding = 8
        configuration?.attributedTitle = titleAttribute
        configuration?.background.backgroundColor = .inactive

        configurationUpdateHandler = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
