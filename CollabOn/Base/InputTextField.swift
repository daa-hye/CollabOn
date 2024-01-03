//
//  InputTextField.swift
//  CollabOn
//
//  Created by 박다혜 on 1/3/24.
//

import UIKit

class InputTextField: UIView {

    private var label = UILabel()
    private var textField = UITextField()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.heightAnchor.constraint(equalToConstant: 76).isActive = true
        configHierarchy()
        setLayout()
        setUIProperties()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configHierarchy() {
        self.addSubview(label)
        self.addSubview(textField)
    }

    private func setLayout() {
        label.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }

        textField.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }

    private func setUIProperties() {
        label.font = .title2
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 12.0, height: 0.0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 12.0, height: 0.0))
        textField.rightViewMode = .always
    }

    func setText(label: String, placeHolder: String) {
        self.label.text = label
        let attributedString = NSMutableAttributedString.init(string: placeHolder)
        attributedString.addAttribute(.foregroundColor, value: UIColor.coGray, range: NSRange(location: 0, length: placeHolder.count))
        attributedString.addAttribute(.font, value: UIFont.body, range: NSRange(location: 0, length: placeHolder.count))
        textField.attributedPlaceholder = attributedString
    }

}
