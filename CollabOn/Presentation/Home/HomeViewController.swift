//
//  HomeViewController.swift
//  CollabOn
//
//  Created by 박다혜 on 1/14/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import RxDataSources
import Kingfisher

final class HomeViewController: BaseViewController {

    private let mainImage = UIImageView()
    private let mainLabel = UILabel()
    private let subLabel = UILabel()
    private let createButton = PrimaryButton(title: String(localized: "워크스페이스 생성"))
    private let navigationView = UIView()
    private let divider = UIImageView()
    private let titleLabel = UILabel()
    private let thumbnailView = UIImageView()
    private let profileView = UIImageView()
    private let newMessageButton = UIImageView()

    private var sideMenuViewController: WorkspaceListViewController!
    private var sideMenuDimView = UIView()
    private var sideMenuWidth: CGFloat {
        (view.window?.windowScene?.screen.bounds.width ?? 0) * 0.8
    }
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<HomeViewSection>?
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())

    let disposeBag = DisposeBag()

    private let viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setDatasource()
    }

    override func bindRx() {

        collectionView.rx.modelSelected(HomeViewSectionItem.self)
            .bind(with: self) { owner, item in
                switch item {
                case .channelItem(let data, let _):
                    let viewModel = ChannelChattingViewModel(data)
                    let vc = ChannelChattingViewController(viewModel: viewModel)
                    owner.navigationController?.pushViewController(vc, animated: true)
                case .dmsItem(let data, let _):
                    print()
                }
            }
            .disposed(by: disposeBag)

        createButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = WorkspaceAddViewController()
                let nav = UINavigationController(rootViewController: vc)
                owner.present(nav, animated: true)
            }
            .disposed(by: disposeBag)

        view.rx.swipeGesture(.right)
            .when(.recognized)
            .bind(with: self) { owner, _ in
                owner.sideMenuViewController.isExpanded.accept(true)
                owner.tabBarController?.tabBar.isHidden = true
            }
            .disposed(by: disposeBag)

        titleLabel.rx.tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                owner.sideMenuViewController.isExpanded.accept(true)
                owner.tabBarController?.tabBar.isHidden = true
            }
            .disposed(by: disposeBag)

        view.rx.swipeGesture(.left)
            .when(.recognized)
            .bind(with: self) { owner, _ in
                owner.sideMenuViewController.isExpanded.accept(false)
                owner.tabBarController?.tabBar.isHidden = false
            }
            .disposed(by: disposeBag)

        sideMenuDimView.rx.tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                owner.sideMenuViewController.isExpanded.accept(false)
                owner.tabBarController?.tabBar.isHidden = false
            }
            .disposed(by: disposeBag)

        sideMenuViewController.isExpanded
            .skip(1)
            .distinctUntilChanged()
            .bind(with: self) { owner, value in
                UIView.animate(withDuration: 0.5) {
                    self.sideMenuDimView.alpha = value ? 0.5 : 0.01
                }
                owner.animateSideMenu(targetPosition: value ? 0 : -owner.sideMenuWidth)
            }
            .disposed(by: disposeBag)

        viewModel.output.profile
            .bind(with: self) { owner, url in
                owner.profileView.kf.setImage(with: url, options: [.requestModifier(ImageService.shared.getImage())])
            }
            .disposed(by: disposeBag)

//        view.rx.panGesture().when(.began, .ended, .cancelled)
//            .withLatestFrom(Observable.combineLatest(sideMenuViewController.isExpanded,
//                                                     sideMenuViewController.isDraggable)) { ($0, $1.0, $1.1) }
//            .subscribe { [weak self] (event, isExpanded, isDraggable) in
//                let position = event.translation(in: self?.view).x
//                let velocity = event.velocity(in: self?.view).x
//
//                switch event.state {
//                case .began:
//                    if velocity > 0 , isExpanded {
//                        event.state = .cancelled
//                    }
//                    else if velocity < 0, !isExpanded {
//                        self?.sideMenuViewController.isDraggable.accept(true)
//                    }
//
//                    if isDraggable {
//                        let velocityThreshold: CGFloat = 550
//                        if abs(velocity) > velocityThreshold {
//                            self?.sideMenuViewController.isDraggable.accept(false)
//                            self?.sideMenuViewController.isExpanded.accept(!isExpanded)
//                            return
//                        }
//                        self?.sideMenuViewController.panBaseLocation = 0.0
//                        if isExpanded {
//                            self?.sideMenuViewController.panBaseLocation = self?.sideMenuWidth ?? 0
//                        }
//                    }
//
//                case .changed:
//                    print()
//                    if isDraggable {
//                        let xLocation: CGFloat = (self?.sideMenuViewController.panBaseLocation ?? 0) + position
//                        let percentage = (xLocation * 150 / (self?.sideMenuWidth ?? 0)) / (self?.sideMenuWidth ?? 0)
//
//                        let alpha = percentage >= 0.6 ? 0.6 : percentage
//                        self?.sideMenuDimView.alpha = alpha
//
//                        if xLocation <= self?.sideMenuWidth ?? 0 {
//                            self?.sideMenuViewController.view.snp.makeConstraints {
//                                $0.width.equalTo(xLocation - (self?.sideMenuWidth ?? 0))
//                            }
//                        }
//                    }
//
//                case .ended:
//                    self?.sideMenuViewController.isDraggable.accept(false)
//                    let width = self?.sideMenuViewController.view.frame.width ?? 0 > -((self?.sideMenuWidth ?? 0) * 0.5)
//                    self?.sideMenuViewController.isExpanded.accept(width)
//
//                default:
//                    break
//                }
//            }
//            .disposed(by: disposeBag)

        viewModel.output.currentWorkspace
            .bind(with: self) { owner, value in
                if value == nil {
                    owner.titleLabel.text = String(localized: "No Workspace")
                    owner.thumbnailView.image = .workspace
                    owner.tabBarController?.tabBar.isHidden = true
                    owner.newMessageButton.isHidden = true
                    owner.mainImage.isHidden = false
                    owner.mainLabel.isHidden = false
                    owner.subLabel.isHidden = false
                    owner.createButton.isHidden = false
                } else {
                    owner.mainImage.isHidden = true
                    owner.mainLabel.isHidden = true
                    owner.subLabel.isHidden = true
                    owner.createButton.isHidden = true
                    owner.titleLabel.text = value?.name ?? String(localized: "No Workspace")
                    owner.thumbnailView.kf.setImage(with: value?.thumbnail, options: [.requestModifier(ImageService.shared.getImage())])
                    owner.sideMenuViewController.isExpanded.accept(false)
                    owner.tabBarController?.tabBar.isHidden = false
                    owner.newMessageButton.isHidden = false
                }
            }
            .disposed(by: disposeBag)
    }

    override func configHierarchy() {

        view.addSubview(collectionView)
        view.addSubview(mainImage)
        view.addSubview(navigationView)
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        view.addSubview(createButton)
        view.addSubview(newMessageButton)
        navigationView.addSubview(titleLabel)
        navigationView.addSubview(thumbnailView)
        navigationView.addSubview(profileView)
        navigationView.addSubview(divider)

        sideMenuDimView.backgroundColor = .black
        sideMenuDimView.alpha = 0
        view.addSubview(self.sideMenuDimView)

        sideMenuViewController = WorkspaceListViewController(viewModel: viewModel)
        sideMenuViewController.delegate = self
        addChild(sideMenuViewController)
        view.addSubview(sideMenuViewController.view)
        sideMenuViewController.didMove(toParent: self)
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

        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(navigationView.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(-34)
        }

        newMessageButton.snp.makeConstraints {
            $0.size.equalTo(54)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        sideMenuDimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        sideMenuViewController.view.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(-317)
            $0.width.equalTo(317)
            $0.verticalEdges.equalToSuperview()
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

        newMessageButton.image = .newMessage

        thumbnailView.layer.cornerRadius = 8
        thumbnailView.clipsToBounds = true

        profileView.layer.cornerRadius = 16
        profileView.layer.borderWidth = 2
        profileView.image = .noProfile
        profileView.layer.borderColor = UIColor.selected.cgColor
        profileView.clipsToBounds = true

        collectionView.collectionViewLayout = createLayout()
        collectionView.register(HomeCollectoinViewCell.self, forCellWithReuseIdentifier: HomeCollectoinViewCell.className)

    }

}

extension HomeViewController {

    private enum sectionHeaderFooter: String {
        case header
        case footer
    }

    func setDatasource() {

        let headerRegistration = UICollectionView.SupplementaryRegistration<HomeCollectoinViewCell>(elementKind: sectionHeaderFooter.header.rawValue) { supplementaryView, elementKind, indexPath in
            supplementaryView.setHeader(indexPath.section)
        }

        let footerRegistration = UICollectionView.SupplementaryRegistration<HomeCollectoinViewCell>(elementKind: sectionHeaderFooter.footer.rawValue) { supplementaryView, elementKind, indexPath in
            supplementaryView.setFooter(indexPath.section)
            supplementaryView.delegate = self
        }

        dataSource = RxCollectionViewSectionedReloadDataSource<HomeViewSection> { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectoinViewCell.className, for: indexPath) as? HomeCollectoinViewCell else {
                return UICollectionViewCell()
            }

            switch item {
            case .channelItem(let data, let count):
                cell.setData(channel: data, count: count)
            case .dmsItem(let data, let count):
                cell.setData(dms: data, count: count)
            }

            cell.backgroundConfiguration = UIBackgroundConfiguration.clear()

            return cell

        } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            let supplementaryView = collectionView.dequeueConfiguredReusableSupplementary(using: kind == sectionHeaderFooter.header.rawValue ? headerRegistration : footerRegistration, for: indexPath)
            let disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .header)

            if kind == sectionHeaderFooter.header.rawValue && indexPath.section < 2 {
                supplementaryView.accessories = [.outlineDisclosure(options: disclosureOptions)]
                supplementaryView.tintColor = .black
            }

            supplementaryView.backgroundConfiguration = UIBackgroundConfiguration.clear()

            return supplementaryView
        }

        viewModel.output.sections
            .bind(to: collectionView.rx.items(dataSource: dataSource!))
            .disposed(by: disposeBag)
    }

    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(56))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .estimated(56))

        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .estimated(41))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: sectionHeaderFooter.header.rawValue, alignment: .top)
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize, elementKind: sectionHeaderFooter.footer.rawValue, alignment: .bottom)
        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    func animateSideMenu(targetPosition: CGFloat) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews) { [weak self] in
            self?.sideMenuViewController.view.snp.updateConstraints {
                $0.leading.equalToSuperview().offset(targetPosition)
                $0.width.equalTo(self?.sideMenuWidth ?? 0)
                $0.verticalEdges.equalToSuperview()
            }
            self?.view.layoutIfNeeded()
        }
    }

}

extension HomeViewController: FooterClickDelegate {

    func addChannel() {
        print("addChannel")
    }

    func addMessage() {
        print("addMessage")
    }

    func addMember() {
        print("addMember")
    }

}

extension HomeViewController: WorkspaceListTableViewCellDelegate {

    func settingButtonDidTap() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: String(localized: "취소"), style: .cancel, handler: nil)

        let edit = UIAlertAction(title: String(localized: "워크스페이스 편집"), style: .default) { [weak self] _ in

            _ = self?.viewModel.output.currentWorkspace
                .take(1)
                .compactMap { $0 }
                .bind { [weak self] workspace in
                    let vc = WorkspaceEditViewController(viewModel: WorkspaceEditViewModel(workspace: workspace))
                    let nav = UINavigationController(rootViewController: vc)
                    self?.present(nav, animated: true)
                }

        }

        let changeAdmin = UIAlertAction(title: String(localized: "워크스페이스 관리자 변경"), style: .default) { [weak self] _ in
            let vc = WorkspaceChangeAdminViewController()
            let nav = UINavigationController(rootViewController: vc)
            self?.present(nav, animated: true)
        }

        let delete = UIAlertAction(title: String(localized: "워크스페이스 삭제"), style: .destructive) { [weak self] _ in
            self?.showAlert(
                mainTitle: String(localized: "워크스페이스 삭제"),
                subTitle: String(localized: "정말 이 워크스페이스를 삭제하시겠습니까? 삭제 시 채널/멤버/채팅 등 워크스페이스 내의 모든 정보가 삭제되며 복구할 수 없습니다."),
                buttonType: .delete,
                isTwoButtonType: true
            ) {
                self?.viewModel.input.deleteButtonDidTap.onNext(())
                self?.sideMenuViewController.isExpanded.accept(false)
            }
        }

        viewModel.output.isAdmin
            .bind(with: self) { owner, value in
                if value {
                    let leave = UIAlertAction(title: String(localized: "워크스페이스 나가기"), style: .default) { [weak self] _ in
                        self?.showAlert(
                            mainTitle: String(localized: "워크스페이스 나가기"),
                            subTitle: String(localized: "회원님은 워크스페이스 관리자입니다. 워크스페이스 관리자를 다른 멤버로 변경한 후 나갈 수 있습니다."),
                            buttonType: .confirm,
                            isTwoButtonType: false
                        ) {

                        }
                    }
                    actionSheet.addAction(edit)
                    actionSheet.addAction(leave)
                    actionSheet.addAction(changeAdmin)
                    actionSheet.addAction(delete)
                } else {
                    let leave = UIAlertAction(title: String(localized: "워크스페이스 나가기"), style: .default) { [weak self] _ in
                        self?.showAlert(
                            mainTitle: String(localized: "워크스페이스 나가기"),
                            subTitle: String(localized: "정말 이 워크스페이스를 떠나시겠습니까?"),
                            buttonType: .leave,
                            isTwoButtonType: true
                        ) { [weak self] in
                            self?.viewModel.input.leaveButtonDidTap.onNext(())
                            self?.sideMenuViewController.isExpanded.accept(false)
                        }
                    }
                    actionSheet.addAction(leave)
                }
            }
            .disposed(by: disposeBag)

        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }

}

protocol FooterClickDelegate {

    func addChannel()
    func addMessage()
    func addMember()

}
