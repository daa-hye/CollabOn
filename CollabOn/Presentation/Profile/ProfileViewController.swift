//
//  ProfileViewController.swift
//  CollabOn
//
//  Created by 박다혜 on 3/1/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileViewController: BaseViewController {

    private let viewModel = ProfileViewModel()

    let disposeBag = DisposeBag()

    private let profileView = UIView()
    private let profileImage = UIImageView()
    private let cameraImage = UIImageView()
    private let button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
    }

    override func bindRx() {
        viewModel.output.profile
            .bind(with: self) { owner, url in
                owner.profileImage.kf.setImage(with: url, options: [.requestModifier(ImageService.shared.getImage())])
            }
            .disposed(by: disposeBag)

        button.rx.tap
            .bind(with: self) { owner, _ in
                let vc = CoinShopViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }

    override func configHierarchy() {
        view.addSubview(profileView)
        profileView.addSubview(profileImage)
        profileView.addSubview(cameraImage)
        view.addSubview(button)
    }

    override func setLayout() {

        profileView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.centerX.equalToSuperview().offset(7)
            $0.width.equalTo(77)
            $0.height.equalTo(75)
        }

        cameraImage.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview()
            $0.size.equalTo(24)
        }

        profileImage.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.size.equalTo(70)
        }

        button.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(50)
        }

    }

    override func setUIProperties() {
        cameraImage.image = .camera
        profileImage.image = .workspace
        profileImage.layer.cornerRadius = 8
        profileImage.clipsToBounds = true
        button.backgroundColor = .main
    }

}

extension ProfileViewController {

    private func setNavItem() {

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .backgroundSecondary
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.title = String(localized: "내 정보 수정")

        let closeButton = UIBarButtonItem(
            image: .back,
            style: .done,
            target: self,
            action: #selector(closeButtonDidTap)
        )
        closeButton.tintColor = .black
        navigationItem.leftBarButtonItem = closeButton
    }

    @objc private func closeButtonDidTap() {
        dismiss(animated: true)
    }

}
