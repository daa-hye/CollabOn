//
//  Interceptor.swift
//  CollabOn
//
//  Created by 박다혜 on 1/14/24.
//

import Foundation
import Alamofire
import RxSwift

class Interceptor: RequestInterceptor {

    let disposeBag = DisposeBag()

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let _ = request.request?.value(forHTTPHeaderField: HTTPHeaderField.auth.rawValue),
              request.request?.value(forHTTPHeaderField: HTTPHeaderField.refreshToken.rawValue) == nil,
              let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 400 else {
            completion(.doNotRetryWithError(error))
            return
        }

        AuthService.shared.refreshToken()
            .asObservable()
            .materialize()
            .subscribe(with: self) { owner, event in
                switch event {
                case .next:
                    completion(.retry)
                case .error:
                    completion(.doNotRetryWithError(error))
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }

}
