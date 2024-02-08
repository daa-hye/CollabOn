//
//  InputTextField.swift
//  CollabOn
//
//  Created by 박다혜 on 1/3/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol InputTextFieldDelegate: AnyObject {
    func setTextLimit(_ textField: InputTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}

final class InputTextField: UIView {

    private var label = UILabel()
    private var textField = UITextField()

    weak var delegate: InputTextFieldDelegate?

    let isValid = BehaviorSubject(value: true)

    var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.heightAnchor.constraint(equalToConstant: 76).isActive = true
        configHierarchy()
        setLayout()
        setUIProperties()

        textField.delegate = self
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var isEmpty: Observable<Bool> {
        textField.rx.text.orEmpty
            .map { $0.isEmpty }
            .asObservable()
    }

    var text: Observable<String> {
        textField.rx.text.orEmpty
            .distinctUntilChanged()
            .asObservable()
    }

    var count: Int {
        textField.text?.count ?? 0
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

        isValid
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, value in
                if value {
                    self.label.textColor = .black
                } else {
                    self.label.textColor = .error
                }
            }
            .disposed(by: disposeBag)

        label.font = .title2
        textField.autocapitalizationType = .none
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

    func setText(text: String) {
        self.textField.text = text
    }

    func setKeyboardType(_ type: UIKeyboardType) {
        textField.keyboardType = type
    }

    func setTextContentType(_ type: UITextContentType) {
        textField.textContentType = type
    }

    func setSecure() {
        textField.isSecureTextEntry = true
    }

    func setPhoneNumberFormat() {
        guard let text = textField.text else { return }
        if 12...13 ~= count {
            textField.text = text.formated(by: "###-####-####")
        } else {
            textField.text = text.formated(by: "###-###-####")
        }
    }

}

extension InputTextField: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let delegate else { return true }
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        return delegate.setTextLimit(self, shouldChangeCharactersIn: range, replacementString: string)
    }

}
