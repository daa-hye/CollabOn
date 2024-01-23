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

    let topView = UIView()
    let titlelabel = UILabel()
    let mainLabel = UILabel()
    let subLabel = UILabel()
    let sideCreateButton = PrimaryButton(title: String(localized: "워크스페이스 생성"))

    let disposeBag = DisposeBag()

    private let viewModel = WorkspaceListViewModel()

    override func bindRx() {

        isExpanded
            .map{ !$0 }
            .subscribe(with: self) { owner, value in
                owner.topView.rx.isHidden.onNext(value)
                owner.titlelabel.rx.isHidden.onNext(value)
                owner.mainLabel.rx.isHidden.onNext(value)
                owner.subLabel.rx.isHidden.onNext(value)
                owner.sideCreateButton.rx.isHidden.onNext(value)
            }
            .disposed(by: disposeBag)

        isExpanded
            .asObservable()
            .bind(to: viewModel.input.isExpanded)
            .disposed(by: disposeBag)

        sideCreateButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let vc = WorkspaceAddViewController()
                let nav = UINavigationController(rootViewController: vc)
                owner.present(nav, animated: true)
            }
            .disposed(by: disposeBag)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
    }

    override func configHierarchy() {
        view.addSubview(topView)
        topView.addSubview(titlelabel)
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        view.addSubview(sideCreateButton)
    }

    override func setLayout() {
        topView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(98)
        }

        titlelabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(17)
        }

        mainLabel.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(183)
            $0.centerX.equalToSuperview()
        }

        subLabel.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(19)
            $0.centerX.equalToSuperview()
        }

        sideCreateButton.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(19)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
    }

    override func setUIProperties() {
        view.clipsToBounds = true

        topView.backgroundColor = .backgroundPrimary

        titlelabel.text = String(localized: "워크스페이스")
        titlelabel.font = .title1

        mainLabel.text = String(localized: "워크스페이스를 찾을 수 없어요.")
        mainLabel.font = .title1

        subLabel.text = String(localized: "관리자에게 초대를 요청하거나,\n다른 이메일로 시도하거나\n새로운 워크스페이스를 생성해주세요. ")
        subLabel.font = .body
        subLabel.textAlignment = .center
        subLabel.numberOfLines = 3

    }

}
