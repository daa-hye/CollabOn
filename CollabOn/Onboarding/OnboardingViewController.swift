//
//  OnboardingViewController.swift
//  CollabOn
//
//  Created by 박다혜 on 1/2/24.
//

import UIKit

final class OnboardingViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private let onboardingImage = UIImageView()
    private let onboardingLabel = UILabel()
    private let startButton = UIButton()

    override func configHierarchy() {
        view.addSubview(onboardingImage)
        view.addSubview(onboardingLabel)
        view.addSubview(startButton)
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(45)
            $0.height.equalTo(44)
        }
    }

    override func setUIProperties() {
        onboardingImage.image = .onboarding

        onboardingLabel.text = String(localized: "CollabOn을 사용하면 어디서나\n팀을 모을 수 있습니다")
        onboardingLabel.font = .title1
        onboardingLabel.textAlignment = .center
        onboardingLabel.numberOfLines = 2

        startButton.backgroundColor = .main
        startButton.titleLabel?.font = .title2
        startButton.setTitle(String(localized: "시작하기"), for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 8
    }

}
