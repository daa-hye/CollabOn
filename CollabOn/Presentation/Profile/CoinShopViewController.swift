//
//  CoinShopViewController.swift
//  CollabOn
//
//  Created by 박다혜 on 3/1/24.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa
import iamport_ios

final class CoinShopViewController: BaseViewController {

    private let viewModel = CoinShopViewModel()

    let disposeBag = DisposeBag()

    private lazy var listCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
    private var dataSource: UICollectionViewDiffableDataSource<Int, Item>! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(localized: "코인샵")
    }

    override func bindRx() {

        viewModel.output.payment
            .bind(with: self) { owner, payment in
                let viewModel = PaymentViewModel(payment)
                let vc = PaymentViewController(viewModel: viewModel)
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)

        viewModel.output.toastMessage
            .bind(with: self) { owner, message in
                owner.showToast(message: message, offset: 4)
            }
            .disposed(by: disposeBag)

        Observable.combineLatest(viewModel.output.coin, viewModel.output.items)
            .filter { !$1.isEmpty }
            .bind { [weak self] coin, items in
                self?.setDatasource(coin, items)
            }
            .disposed(by: disposeBag)

    }

    override func configHierarchy() {
        view.addSubview(listCollectionView)
    }

    override func setLayout() {
        listCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func setUIProperties() {
        listCollectionView.backgroundColor = .clear
    }

}

extension CoinShopViewController {

    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { section, layoutEnvironment in
            let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            return NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
        }
    }

    private func setDatasource(_ coin: Int, _ items: [ItemResponse]) {

        let cellRegistration = UICollectionView.CellRegistration<CoinCollectionViewCell, Item> { (cell, indexPath, item) in
            if indexPath.section == 0 {
                cell.setData(title: item.title, value: item.value)
            } else {
                cell.setCoinList(title: item.title, value: item.value)
                _ = cell.button.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.viewModel.input.coinButtonDidTap.onNext(item)
                    }
            }
        }

        dataSource = UICollectionViewDiffableDataSource<Int, Item>(collectionView: listCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }

        var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()
        snapshot.appendSections([0, 1, 2])
        dataSource.apply(snapshot)
        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        let item = Item(title: String(localized: "현재 보유한 코인"), value: "\(coin)")
        sectionSnapshot.append([item])
        dataSource.apply(sectionSnapshot, to: 1)

        sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        var list: [Item] = []
        for item in items {
            list.append(Item(title: item.item, value: item.amount))
        }
        sectionSnapshot.append(list)
        dataSource.apply(sectionSnapshot, to: 2)

    }

}

