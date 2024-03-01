//
//  StoreService.swift
//  CollabOn
//
//  Created by 박다혜 on 3/1/24.
//

import Foundation
import Alamofire
import RxSwift

final class StoreService: Service {
    static let shared = StoreService()
    private override init() {}
}

extension StoreService {

    func getItemList() -> Single<[ItemResponse]> {
        Single.create { observer in
            let request = self.AFManager.request(StoreRouter.itemList)
                .validate(statusCode: 200...300)
                .responseDecodable(of: [ItemResponse].self) { response in
                    switch response.result {
                    case .success(let value):
                        observer(.success(value))
                    case .failure:
                        guard let statusCode = response.response?.statusCode, let data = response.data else {
                            return observer(.failure(EndPointError.networkError))
                        }
                        let error = self.handleError(statusCode: statusCode, data)
                        observer(.failure(error))
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }

    func getPayValidated(imp: String?, merchant: String?) -> Single<PaymentResponse> {
        Single.create { observer in
            let request = self.AFManager.request(StoreRouter.payValidation(imp: imp, merchant: merchant))
                .validate(statusCode: 200...300)
                .responseDecodable(of: PaymentResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        observer(.success(value))
                    case .failure:
                        guard let statusCode = response.response?.statusCode, let data = response.data else {
                            return observer(.failure(EndPointError.networkError))
                        }
                        let error = self.handleError(statusCode: statusCode, data)
                        observer(.failure(error))
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }

}
