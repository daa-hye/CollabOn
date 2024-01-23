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

    private var sideMenuViewController: WorkspaceListViewController!
    private var sideMenuDimView = UIView()
    private var sideMenuWidth: CGFloat {
        (view.window?.windowScene?.screen.bounds.width ?? 0) * 0.8
    }
    private var dataSource: UICollectionViewDiffableDataSource<Int, Channel>! = nil
    private var collectionView: UICollectionView! = nil

    private var snapshot = NSDiffableDataSourceSnapshot<Int, Channel>()

    let disposeBag = DisposeBag()

    private let viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.viewDidLoad.onNext(())
    }

    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)

        sideMenuViewController.view.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(-sideMenuWidth)
            $0.width.equalTo(sideMenuWidth)
            $0.verticalEdges.equalToSuperview()
        }
    }

    override func bindRx() {

        createButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let vc = WorkspaceAddViewController()
                let nav = UINavigationController(rootViewController: vc)
                owner.present(nav, animated: true)
            }
            .disposed(by: disposeBag)

        view.rx.swipeGesture(.right)
            .when(.recognized)
            .subscribe(with: self) { owner, _ in
                owner.sideMenuViewController.isExpanded.accept(true)
            }
            .disposed(by: disposeBag)

        view.rx.swipeGesture(.left)
            .when(.recognized)
            .subscribe(with: self) { owner, _ in
                owner.sideMenuViewController.isExpanded.accept(false)
            }
            .disposed(by: disposeBag)

        sideMenuDimView.rx.tapGesture()
            .when(.recognized)
            .subscribe(with: self) { owner, _ in
                owner.sideMenuViewController.isExpanded.accept(false)
            }
            .disposed(by: disposeBag)

        sideMenuViewController.isExpanded
            .skip(1)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                UIView.animate(withDuration: 0.5) {
                    self.sideMenuDimView.alpha = value ? 0.5 : 0.01
                }
                owner.animateSideMenu(targetPosition: value ? 0 : -owner.sideMenuWidth)
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

    }

    override func configHierarchy() {

        view.addSubview(mainImage)
        view.addSubview(navigationView)
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        view.addSubview(createButton)
        navigationView.addSubview(titleLabel)
        navigationView.addSubview(thumbnailView)
        navigationView.addSubview(profileView)
        navigationView.addSubview(divider)

        sideMenuDimView.backgroundColor = .black
        sideMenuDimView.alpha = 0
        view.addSubview(self.sideMenuDimView)

        sideMenuViewController = WorkspaceListViewController()
        addChild(sideMenuViewController)
        view.addSubview(sideMenuViewController.view)
        sideMenuViewController.didMove(toParent: self)
    }

    override func setLayout() {
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        

        mainImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(12)
        }

        navigationView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(58)
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
        }

        sideMenuDimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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

    func animateSideMenu(targetPosition: CGFloat) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews) { [weak self] in
            self?.sideMenuViewController.view.snp.updateConstraints {
                $0.leading.equalToSuperview().offset(targetPosition)
            }
            self?.view.layoutIfNeeded()
        }
    }

}
