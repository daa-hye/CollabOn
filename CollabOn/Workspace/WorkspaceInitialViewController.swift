//
//  WorkspaceInitialViewController.swift
//  CollabOn
//
//  Created by 박다혜 on 1/11/24.
//

import UIKit

class WorkspaceInitialViewController: BaseViewController {

    private let mainImage = UIImageView()
    private let mainLabel = UILabel()
    private let subLabel = UILabel()
    private let createButton = PrimaryButton(title: String(localized: "워크스페이스 생성"))

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func configHierarchy() {
        view.addSubview(mainImage)
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        view.addSubview(createButton)
    }

    override func setLayout() {

        mainLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }

        subLabel.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }

        mainImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.height.equalTo(mainImage.snp.width)
        }

        createButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
        }

    }

    override func setUIProperties() {
        mainImage.image = .launching

        mainLabel.text = String(localized: "출시 준비 완료!")
        mainLabel.font = .title1
        mainLabel.textAlignment = .center

        subLabel.text = String(localized: "님의 조직을 위해 새로운 새싹톡 워크스페이스를 \n시작할 준비가 완료되었어요!")
        subLabel.font = .body
        subLabel.textAlignment = .center
        subLabel.numberOfLines = 2
    }

}

extension WorkspaceInitialViewController {

    private func setNavItem() {

        navigationController?.navigationBar.backgroundColor = .backgroundSecondary
        navigationItem.title = String(localized: "시작하기")

        let closeButton = UIBarButtonItem(
            image: .close,
            style: .done,
            target: self,
            action: #selector(closeButtonDidTap)
        )
        closeButton.tintColor = .black
        navigationItem.leftBarButtonItem = closeButton
    }

    @objc
    private func closeButtonDidTap() {
        dismiss(animated: true)
    }

}
