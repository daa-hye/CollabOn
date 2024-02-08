//
//  OnboardingViewController.swift
//  CollabOn
//
//  Created by 박다혜 on 1/2/24.
//

import UIKit

final class OnboardingViewController: BaseViewController {

    private let mainImage = UIImageView()
    private let mainLabel = UILabel()
    private let startButton = PrimaryButton(title: String(localized: "시작하기"))

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func configHierarchy() {
        view.addSubview(mainImage)
        view.addSubview(mainLabel)
        view.addSubview(startButton)
    }

    override func setLayout() {

        mainLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(39)
            $0.height.equalTo(60)
        }

        mainImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.height.equalTo(mainImage.snp.width)
        }

        startButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
    }

    override func setUIProperties() {
        mainImage.image = .onboarding

        mainLabel.text = String(localized: "CollabOn을 사용하면 어디서나\n팀을 모을 수 있습니다")
        mainLabel.font = .title1
        mainLabel.textAlignment = .center
        mainLabel.numberOfLines = 2

        startButton.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
    }

    @objc private func startButtonDidTap() {
        let vc = AuthSheetViewController()
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.custom { _ in return 269 }]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 10
        }

        present(vc, animated: true)
    }

}
