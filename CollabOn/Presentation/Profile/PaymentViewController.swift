//
//  PaymentViewController.swift
//  CollabOn
//
//  Created by 박다혜 on 3/1/24.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa
import iamport_ios

final class PaymentViewController: BaseViewController {

    let viewModel: PaymentViewModel

    let disposeBag = DisposeBag()

    init(viewModel: PaymentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setNavItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var payWebView: WKWebView = {
        var view = WKWebView()
        view.backgroundColor = UIColor.clear
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        attachWebView()
    }

    override func bindRx() {
        viewModel.output.payment
            .bind(with: self) { owner, payment in
                Iamport.shared.paymentWebView(webViewMode: owner.payWebView, userCode: SLP.userCode, payment: payment) { [weak self] response in
                    if let response = response {
                        owner.viewModel.input.paymentResponse.onNext(response)
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
            .disposed(by: disposeBag)
    }

}

extension PaymentViewController {

    private func attachWebView() {
        view.addSubview(payWebView)
        payWebView.frame = view.frame

        payWebView.translatesAutoresizingMaskIntoConstraints = false

        payWebView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func setNavItem() {

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .backgroundSecondary
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .black
        self.title = String(localized: "코인 결제")

    }

}
