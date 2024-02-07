//
//  UIViewcontroller + Alert.swift
//  CollabOn
//
//  Created by 박다혜 on 2/1/24.
//

import UIKit
import RxSwift
import RxCocoa

extension UIViewController {

    func showAlert(mainTitle: String, subTitle: String, buttonType: confirmButtonType, isTwoButtonType: Bool, confirm: (() -> ())?) {

        let alert = AlertView(mainTitle: mainTitle, subTitle: subTitle, buttonType: buttonType, isTwoButtonType: isTwoButtonType, confirm: confirm)
        view.addSubview(alert)
        alert.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}

private class AlertView: UIView {

    let backgroundView = UIView()
    let mainLabel = UILabel()
    let subLabel = UILabel()
    let cancelButton = CancelButton()
    let confirmButton: PrimaryButton
    let titleStackView = UIStackView()
    let buttonStackView = UIStackView()

    let disposeBag = DisposeBag()
    let confirmButtonDidTap: (() -> ())?

    init(mainTitle: String, subTitle: String, buttonType: confirmButtonType, isTwoButtonType: Bool, confirm: (() -> ())?) {
        mainLabel.text = mainTitle
        subLabel.text = subTitle
        confirmButton = PrimaryButton(title: buttonType.title)
        confirmButtonDidTap = confirm

        super.init(frame: .zero)

        if isTwoButtonType {
            buttonStackView.addArrangedSubview(cancelButton)
            buttonStackView.addArrangedSubview(confirmButton)
            buttonStackView.axis = .horizontal
            buttonStackView.distribution = .fillEqually
            buttonStackView.spacing = 8
        } else {
            buttonStackView.addArrangedSubview(confirmButton)
            buttonStackView.distribution = .fill
        }

        configHierarchy()
        setLayout()
        setUIProperties()
        bindRx()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configHierarchy() {
        addSubview(backgroundView)
        backgroundView.addSubview(titleStackView)
        titleStackView.addArrangedSubview(mainLabel)
        titleStackView.addArrangedSubview(subLabel)
        backgroundView.addSubview(buttonStackView)
    }

    func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
        }

        titleStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(16)
        }

        buttonStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(titleStackView.snp.bottom).offset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }

    func setUIProperties() {
        backgroundColor = .black.withAlphaComponent(0.5)

        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 16
        backgroundView.clipsToBounds = true

        mainLabel.textAlignment = .center
        mainLabel.font = .title2

        subLabel.textAlignment = .center
        subLabel.font = .body
        subLabel.textColor = .textSecondary
        subLabel.numberOfLines = 0

        titleStackView.axis = .vertical
        titleStackView.spacing = 8

    }

    func bindRx() {

        cancelButton.rx.tap
            .bind { [weak self] _ in
                self?.removeFromSuperview()
            }
            .disposed(by: disposeBag)

        confirmButton.rx.tap
            .bind { [weak self] _ in
                self?.removeFromSuperview()
                self?.confirmButtonDidTap?()
            }
            .disposed(by: disposeBag)
    }

}

enum confirmButtonType {
    case confirm
    case delete
    case leave
    case logout

    var title: String {
        switch self {
        case .confirm:
            return String(localized: "확인")
        case .delete:
            return String(localized: "삭제")
        case .leave:
            return String(localized: "나가기")
        case .logout:
            return String(localized: "로그아웃")
        }
    }
}
