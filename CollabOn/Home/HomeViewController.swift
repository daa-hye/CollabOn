//
//  HomeViewController.swift
//  CollabOn
//
//  Created by 박다혜 on 1/14/24.
//

import UIKit

final class HomeViewController: BaseViewController {

    let mainImage = UIImageView()
    let navigationView = UIView()
    let titleLabel = UILabel()
    let thumbnailView = UIImageView()
    let profileView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func configHierarchy() {
        view.addSubview(mainImage)
        view.addSubview(navigationView)
        navigationView.addSubview(titleLabel)
        navigationView.addSubview(thumbnailView)
        navigationView.addSubview(profileView)
    }

    override func setLayout() {
        mainImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(12)
        }

        navigationView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(58)
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

        titleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-12)
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(8)
            $0.trailing.equalTo(profileView.snp.trailing).offset(10)
        }
    }

    override func setUIProperties() {
        mainImage.image = .workspaceEmpty

        navigationView.backgroundColor = .backgroundSecondary

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
