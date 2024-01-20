//
//  WorkspaceListViewController.swift
//  CollabOn
//
//  Created by 박다혜 on 1/19/24.
//

import UIKit
import RxSwift
import RxCocoa

final class WorkspaceListViewController: BaseViewController {

    let isExpanded = BehaviorRelay(value: false)
    let isDraggable = BehaviorRelay(value: false)
    var panBaseLocation: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
    }

}
