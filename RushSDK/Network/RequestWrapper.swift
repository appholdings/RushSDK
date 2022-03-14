//
//  RequestWrapper.swift
//  RushSDK
//
//  Created by Андрей Чернышев on 14.03.2022.
//

import RxSwift
import Alamofire

final class RequestWrapper {
    func callServerApi(requestBody: APIRequestBody) -> Single<Any> {
        execute(request: requestBody)
    }
}

// MARK: Private
private extension RequestWrapper {
    func execute(request: APIRequestBody, attempt: Int = 1, maxCount: Int = 3) -> Single<Any> {
        guard attempt <= maxCount else {
            return .deferred { .error(NSError(domain: "Request wrapper attempt limited", code: 404)) }
        }
        
        print("sdk request wrapper execute request with url: \(request.url), attempt: \(attempt)")
        
        return SDKStorage.shared.restApiTransport
            .callServerApi(requestBody: request)
            .catchAndReturn(["_code": 500])
            .flatMap { [weak self] response -> Single<Any> in
                guard let self = self else {
                    return .never()
                }
                
                let success = self.success(response: response)
                
                return success ? .just(response) : self.execute(request: request, attempt: attempt + 1)
            }
    }
    
    func success(response: Any) -> Bool {
        guard
            let json = response as? [String: Any],
            let code = json["_code"] as? Int
        else {
            return false
        }
        
        return code == 200
    }
}

