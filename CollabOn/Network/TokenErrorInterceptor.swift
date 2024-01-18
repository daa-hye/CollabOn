//
//  TokenErrorInterceptor.swift
//  CollabOn
//
//  Created by 박다혜 on 1/14/24.
//

import Foundation
import Alamofire
import RxSwift

class TokenErrorInterceptor: RequestInterceptor {

    let disposeBag = DisposeBag()

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 400 else {
            return completion(.doNotRetryWithError(error))
        } 

        if let request = request as? DataRequest,
           let data = request.data {
            guard let errorcode = try? JSONDecoder().decode(ErrorResponse.self, from: data).errorCode else {
                return completion(.doNotRetryWithError(error))
            }

            if EndPointError(rawValue: errorcode) != .tokenExpired {
                return completion(.doNotRetryWithError(error))
            }
        }

        AuthService.shared.refreshToken()
            .subscribe(with: self, onSuccess: { owner, _ in
                completion(.retry)
            }, onFailure: { owner, _ in
                completion(.doNotRetryWithError(error))
            })
            .disposed(by: disposeBag)
    }

}
