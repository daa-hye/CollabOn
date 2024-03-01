//
//  CoinShopViewModel.swift
//  CollabOn
//
//  Created by 박다혜 on 3/1/24.
//

import Foundation
import RxSwift
import RxRelay
import iamport_ios

final class CoinShopViewModel: ViewModelType {

    let disposeBag = DisposeBag()

    let input: Input
    let output: Output

    private let coinButtonDidTap = PublishSubject<Item>()

    private let items = BehaviorRelay<[ItemResponse]>(value: [])
    private let payment = PublishRelay<IamportPayment>()
    private let toastMessage = PublishRelay<String>()

    struct Input {
        let coinButtonDidTap: AnyObserver<Item>
    }

    struct Output {
        let coin: Observable<Int>
        let items: Observable<[ItemResponse]>
        let payment: Observable<IamportPayment>
        let toastMessage: Observable<String>
    }

    init() {
        input = .init(
            coinButtonDidTap: coinButtonDidTap.asObserver()
        )

        output = .init(
            coin: UserManager.shared.userInfo.compactMap { $0?.sesacCoin },
            items: items.observe(on: MainScheduler.instance),
            payment: payment.observe(on: MainScheduler.instance),
            toastMessage: toastMessage.observe(on: MainScheduler.instance)
        )

        StoreService.shared.getItemList()
            .catchAndReturn([])
            .asObservable()
            .bind(to: items)
            .disposed(by: disposeBag)

        coinButtonDidTap
            .bind(with: self) { owner, item in
                let payment = IamportPayment(
                    pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
                    merchant_uid: "ios_\(SLP.key)_\(Int(Date().timeIntervalSince1970))",
                    amount: item.value
                )

                payment.pay_method = "card"
                payment.name = item.title
                payment.buyer_name = "박다혜"
                payment.app_scheme = "sesac"

                owner.payment.accept(payment)
            }
            .disposed(by: disposeBag)

    }

}

struct Item: Hashable {
    let title: String
    let value: String
    private let identifier = UUID()
}
