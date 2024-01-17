//
//  HomeViewController.swift
//  CollabOn
//
//  Created by 박다혜 on 1/14/24.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: BaseViewController {

    let mainImage = UIImageView()
    let mainLabel = UILabel()
    let subLabel = UILabel()
    let createButton = PrimaryButton(title: String(localized: "워크스페이스 생성"))
    let navigationView = UIView()
    let divider = UIImageView()
    let titleLabel = UILabel()
    let thumbnailView = UIImageView()
    let profileView = UIImageView()

    private var dataSource: UICollectionViewDiffableDataSource<Int, Channel>! = nil
    private var collectionView: UICollectionView! = nil

    private var snapshot = NSDiffableDataSourceSnapshot<Int, Channel>()

    var disposeBag = DisposeBag()

    private let viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.viewDidLoad.onNext(())
    }

    override func bindRx() {

        createButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                let vc = WorkspaceAddViewController()
                let nav = UINavigationController(rootViewController: vc)
                self.present(nav, animated: true)
            }
            .disposed(by: disposeBag)

    }

    override func configHierarchy() {
        view.addSubview(mainImage)
        view.addSubview(navigationView)
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        view.addSubview(createButton)
        navigationView.addSubview(titleLabel)
        navigationView.addSubview(thumbnailView)
        navigationView.addSubview(profileView)
        navigationView.addSubview(divider)
    }

    override func setLayout() {
        navigationController?.navigationBar.isHidden = true

        mainImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(12)
        }

        navigationView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(58)
        }

        divider.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }

        thumbnailView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-12)
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(32)
        }

        profileView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-12)
            $0.trailing.equalToSuperview().offset(-16)
            $0.size.equalTo(32)
        }

        mainLabel.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(35)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }

        subLabel.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }

        titleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-12)
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(8)
            $0.trailing.equalTo(profileView.snp.trailing).offset(10)
        }

        createButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(24)
        }
    }

    override func setUIProperties() {
        mainImage.image = .workspaceEmpty

        mainLabel.font = .title1
        mainLabel.textAlignment = .center
        mainLabel.text = String(localized: "워크스페이스를 찾을 수 없어요")

        subLabel.font = .body
        subLabel.textAlignment = .center
        subLabel.numberOfLines = 2
        subLabel.text = String(localized: "관리자에게 초대를 요청하거나, 다른 이메일로 시도하거나\n새로운 워크스페이스를 생성해주세요. ")

        navigationView.backgroundColor = .backgroundSecondary

        divider.image = .divider

        titleLabel.font = .title1
        titleLabel.textAlignment = .left
        titleLabel.text = String(localized: "No Workspace")

        thumbnailView.layer.cornerRadius = 8
        thumbnailView.image = .dummy
        thumbnailView.clipsToBounds = true

        profileView.layer.cornerRadius = 16
        profileView.layer.borderWidth = 2
        profileView.image = .dummy
        profileView.layer.borderColor = UIColor.selected.cgColor
        profileView.clipsToBounds = true
    }

}

extension HomeViewController {

    

}
