//
//  WorkspaceListViewController.swift
//  CollabOn
//
//  Created by 박다혜 on 1/19/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class WorkspaceListViewController: BaseViewController {

    let isExpanded = BehaviorRelay(value: false)
    let isDraggable = BehaviorRelay(value: false)

    let topView = UIView()
    let titlelabel = UILabel()
    let mainLabel = UILabel()
    let subLabel = UILabel()
    let sideCreateButton = PrimaryButton(title: String(localized: "워크스페이스 생성"))
    let addView = UIView()
    let addImage = UIImageView()
    let addLabel = UILabel()
    let helpView = UIView()
    let helpImage = UIImageView()
    let helpLabel = UILabel()

    let listTableView = UITableView()

    let disposeBag = DisposeBag()

    private let viewModel = WorkspaceListViewModel()

    override func bindRx() {

        viewModel.output.workspaces
            .bind(to: listTableView.rx.items(cellIdentifier: WorkspaceListTableViewCell.className, cellType: WorkspaceListTableViewCell.self)) { (row, element, cell) in
                cell.setData(element)
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)

        viewModel.output.workspaces
            .map { $0.count == 0 }
            .subscribe(with: self) { owner, value in
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
        view.addSubview(addView)
        view.addSubview(addImage)
        view.addSubview(addLabel)
        view.addSubview(helpView)
        helpView.addSubview(helpImage)
        helpView.addSubview(helpLabel)
        addView.addSubview(addImage)
        addView.addSubview(addLabel)
        view.addSubview(listTableView)
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

        helpView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            $0.height.equalTo(41)
        }

        helpImage.snp.makeConstraints {
            $0.size.equalTo(18)
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }

        helpLabel.snp.makeConstraints {
            $0.leading.equalTo(helpImage.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
        }

        addView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(helpView.snp.top)
            $0.height.equalTo(41)
        }

        addImage.snp.makeConstraints {
            $0.size.equalTo(18)
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }

        addLabel.snp.makeConstraints {
            $0.leading.equalTo(addImage.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
        }

        listTableView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(6)
            $0.bottom.equalTo(addView.snp.top)
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

        addLabel.text = String(localized: "워크스페이스 추가")
        addLabel.font = .body
        addLabel.textColor = .textSecondary

        addImage.image = .plus
        addImage.tintColor = .textSecondary

        helpLabel.text = String(localized: "도움말")
        helpLabel.font = .body
        helpLabel.textColor = .textSecondary

        helpImage.image = .help
        helpImage.tintColor = .textSecondary

        listTableView.register(WorkspaceListTableViewCell.self, forCellReuseIdentifier: WorkspaceListTableViewCell.className)
        listTableView.rowHeight = 72
        listTableView.separatorStyle = .none
    }

}

extension WorkspaceListViewController: WorkspaceListTableViewCellDelegate {

    func settingButtonDidTap() {
        // 액션시트 작업
    }
    
}
