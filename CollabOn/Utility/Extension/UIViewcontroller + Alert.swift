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

        let dimView = UIView()
        let backgroundView = UIView()
        let mainLabel = UILabel()
        let subLabel = UILabel()
        let cancelButton = CancelButton()
        let confirmButton: PrimaryButton
        let titleStackView = UIStackView()
        let buttonStackView = UIStackView()

        view.addSubview(dimView)
        
        mainLabel.text = mainTitle
        subLabel.text = subTitle
        confirmButton = PrimaryButton(title: buttonType.title)

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

        dimView.addSubview(backgroundView)
        backgroundView.addSubview(titleStackView)
        titleStackView.addArrangedSubview(mainLabel)
        titleStackView.addArrangedSubview(subLabel)
        backgroundView.addSubview(buttonStackView)

        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

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

        dimView.backgroundColor = .black.withAlphaComponent(0.5)

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

        _ = cancelButton.rx.tap
            .subscribe { _ in
                dimView.removeFromSuperview()
            }

        _ = confirmButton.rx.tap
            .subscribe { _ in
                dimView.removeFromSuperview()
                confirm?()
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

}
