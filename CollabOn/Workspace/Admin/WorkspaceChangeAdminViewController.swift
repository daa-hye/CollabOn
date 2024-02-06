//
//  WorkspaceChangeAdminViewController.swift
//  CollabOn
//
//  Created by 박다혜 on 2/5/24.
//

import UIKit
import RxSwift
import RxCocoa

final class WorkspaceChangeAdminViewController: BaseViewController {

    private let listTableView = UITableView()

    let disposeBag = DisposeBag()

    private let viewModel = WorkspaceChangeAdminViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.input.viewDidLoad.onNext(())
        setNavItem()
    }

    override func bindRx() {

        viewModel.output.members
            .filter { $0.count <= 1 }
            .bind(with: self) { owner, _ in
                owner.showAlert(mainTitle: String(localized: "워크스페이스 관리자 변경 불가"),
                                subTitle: String(localized: "워크스페이스 멤버가 없어 관리자 변경을 할 수 없습니다.\n새로운 멤버를 워크스페이스에 초대해보세요."),
                                buttonType: .confirm, isTwoButtonType: false) {
                    owner.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)

        viewModel.output.members
            .bind(to: listTableView.rx.items(cellIdentifier: MemberListTableViewCell.className, cellType: MemberListTableViewCell.self)) { (row, element, cell) in
                cell.setData(element)
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)

        listTableView.rx.modelSelected(Member.self)
            .bind(with: self) { owner, member in
                owner.showAlert(mainTitle: String(localized: "\(member.nickname) 님을 관리자로 지정하시겠습니까?"),
                                subTitle: String(localized: """
                                                    워크스페이스 관리자는 다음과 같은 권한이 있습니다.
                                                     · 워크스페이스 이름 또는 설명 변경
                                                     · 워크스페이스 삭제
                                                     · 워크스페이스 멤버 초대
                                                    """),
                                buttonType: .confirm, isTwoButtonType: false) {
                    owner.viewModel.input.selectedMember.onNext(member)
                    owner.dismiss(animated: true) {
                        guard let rootView = owner.presentingViewController else { return }
                        rootView.showToast(message: String(localized: "워크스페이스 관리자가 변경되었습니다"), offset: -24)
                    }
                }
            }
            .disposed(by: disposeBag)
    }

    override func configHierarchy() {
        view.addSubview(listTableView)
    }

    override func setLayout() {
        listTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func setUIProperties() {
        listTableView.register(MemberListTableViewCell.self, forCellReuseIdentifier: MemberListTableViewCell.className)
        listTableView.rowHeight = 60
        listTableView.separatorStyle = .none
        listTableView.backgroundColor = .clear
    }

}

extension WorkspaceChangeAdminViewController {

    private func setNavItem() {

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .backgroundSecondary
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.title = String(localized: "워크스페이스 관리자 변경")

        let closeButton = UIBarButtonItem(
            image: .close,
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
