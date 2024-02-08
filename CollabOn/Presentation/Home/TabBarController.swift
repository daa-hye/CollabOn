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

        let dmView = {
            let view = DirectMessageViewController()
            view.tabBarItem.image = .message
            view.tabBarItem.title = String(localized: "DM")
            return view
        }()

        let searchView = {
            let view = SearchViewController()
            view.tabBarItem.image = .profile
            view.tabBarItem.title = String(localized: "검색")
            return view
        }()

        let settingView = {
            let view = SettingViewController()
            view.tabBarItem.image = .setting
            view.tabBarItem.title = String(localized: "설정")
            return view
        }()

        let tabs: [UIViewController] = [homeView, dmView, searchView, settingView]
        setViewControllers(tabs.map{ UINavigationController(rootViewController: $0) }, animated: true)

    }


}
