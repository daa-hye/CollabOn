//
//  OnboardingViewController.swift
//  CollabOn
//
//  Created by 박다혜 on 1/2/24.
//

import UIKit

final class OnboardingViewController: BaseViewController {

    private let onboardingImage = UIImageView()
    private let onboardingLabel = UILabel()
    private let startButton = BaseButton(title: String(localized: "시작하기"))
    override func configHierarchy() {
        view.addSubview(onboardingImage)
        view.addSubview(onboardingLabel)
        view.addSubview(startButton)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setLayout() {

        onboardingLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(39)
            $0.height.equalTo(60)
        }

        onboardingImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.height.equalTo(onboardingImage.snp.width)
        }

        startButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(44)
        }
    }

    override func setUIProperties() {
        onboardingImage.image = .onboarding

        onboardingLabel.text = String(localized: "CollabOn을 사용하면 어디서나\n팀을 모을 수 있습니다")
        onboardingLabel.font = .title1
        onboardingLabel.textAlignment = .center
        onboardingLabel.numberOfLines = 2

        startButton.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
    }

    @objc
    private func startButtonDidTap() {
        let vc = AuthSheetViewController()
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.custom { _ in return 269 }]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 10
        }

        present(vc, animated: true)
    }

}
