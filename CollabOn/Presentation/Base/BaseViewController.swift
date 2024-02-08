//
//  BaseViewController.swift
//  CollabOn
//
//  Created by 박다혜 on 1/2/24.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.backgroundPrimary
        
        configHierarchy()
        setLayout()
        setUIProperties()
        bindRx()
    }

    func configHierarchy() {}
    func setLayout() {}
    func setUIProperties() {}
    func bindRx() {}
    
}
