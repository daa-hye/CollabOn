//
//  TabBarController.swift
//  CollabOn
//
//  Created by 박다혜 on 1/15/24.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.unselectedItemTintColor = .coGray
        tabBar.tintColor = .black

        let homeView = {
            let view = HomeViewController()
            view.tabBarItem.image = .home
            view.tabBarItem.title = String(localized: "홈")
            return view
        }()

        setViewControllers([homeView], animated: true)

    }


}
