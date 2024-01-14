//
//  HomeViewController.swift
//  CollabOn
//
//  Created by 박다혜 on 1/14/24.
//

import UIKit

class HomeViewController: BaseViewController {

    let mainImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func configHierarchy() {
        view.addSubview(mainImage)
    }

    override func setLayout() {
        mainImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(12)
        }
    }

    override func setUIProperties() {
        mainImage.image = .workspaceEmpty
    }

}
