//
//  SplashViewController.swift
//  CollabOn
//
//  Created by 박다혜 on 1/14/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SplashViewController: BaseViewController {

    private let mainImage = UIImageView()
    private let mainLabel = UILabel()

    let viewModel = SplashViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()



    }

    override func configHierarchy() {
        view.addSubview(mainImage)
        view.addSubview(mainLabel)
    }

    override func setLayout() {

        mainLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(39)
            $0.height.equalTo(60)
        }

        mainImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.height.equalTo(mainImage.snp.width)
        }

    }

    override func setUIProperties() {
        mainImage.image = .onboarding

        mainLabel.text = String(localized: "CollabOn을 사용하면 어디서나\n팀을 모을 수 있습니다")
        mainLabel.font = .title1
        mainLabel.textAlignment = .center
        mainLabel.numberOfLines = 2
    }

}
