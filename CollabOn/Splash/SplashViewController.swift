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

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.input.viewDidLoad.onNext(())

    }

    override func bindRx() {

        viewModel.output.isLoggedIn
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, value in
                if value {
                    let vc = HomeViewController()
                    let nav = UINavigationController(rootViewController: vc)
                    let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                    guard let sceneDelegate else { return }
                    sceneDelegate.window?.rootViewController = nav
                } else {
                    let vc = OnboardingViewController()
                    vc.modalPresentationStyle = .overFullScreen
                    owner.present(vc, animated: false)
                }
            }
            .disposed(by: disposeBag)

    }


    override func configHierarchy() {
        view.addSubview(mainImage)
        view.addSubview(mainLabel)
    }

    override func setLayout() {

        mainLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            //$0.height.equalTo(60)
        }

        mainImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
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
