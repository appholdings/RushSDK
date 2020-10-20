//
//  RestAPITransport.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 08.10.2020.
//

import RxSwift
import Alamofire

public final class RestAPITransport {
    public func callServerApi(requestBody: APIRequestBody) -> Single<Any> {
        Single.create { single in
            let manager = Alamofire.Session.default
            manager.session.configuration.timeoutIntervalForRequest = 30
            
            let encodedUrl = requestBody.url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            let request = manager.request(encodedUrl,
                                          method: requestBody.method,
                                          parameters: requestBody.parameters,
                                          encoding: requestBody.encoding,
                                          headers: requestBody.headers)
                .validate(statusCode: [200, 201])
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success(let json):
                        single(.success(json))
                    case .failure(let error):
                        single(.error(NetworkError(.serverNotAvailable, underlyingError: error)))
                    }
                })
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
