//
//  PaymentViewModel.swift
//  CollabOn
//
//  Created by 박다혜 on 3/1/24.
//

import Foundation
import RxSwift
import RxRelay
import iamport_ios

final class PaymentViewModel: ViewModelType {

    let disposeBag = DisposeBag()

    let input: Input
    let output: Output

    private let payment = ReplayRelay<IamportPayment>.create(bufferSize: 1)

    private let paymentResponse = PublishSubject<IamportResponse>()

    struct Input {
        let paymentResponse: AnyObserver<IamportResponse>
    }

    struct Output {
        let payment: Observable<IamportPayment>
    }

    init(_ data: IamportPayment) {

        payment.accept(data)

        input = .init(
            paymentResponse: paymentResponse.asObserver()
        )
        output = .init(
            payment: payment.observe(on: MainScheduler.instance)
        )

        paymentResponse
            .flatMapLatest{ response in
                StoreService.shared.getPayValidated(imp: response.imp_uid, merchant: response.merchant_uid)
                    .asObservable()
                    .materialize()
            }
            .bind(with: self) { owner, event in
                switch event {
                case .next(let value):
                    if value.success {
                        UserManager.shared.fetchUser()
                        //owner.toastMessage.accept(String(localized: "\(value.sesacCoin) Coin이 결제되었습니다"))
                    }
                case .error(let error):
                    print(error)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }

}
