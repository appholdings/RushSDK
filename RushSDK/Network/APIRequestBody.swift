//
//  APIRequestBody.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 08.10.2020.
//

import Alamofire

public protocol APIRequestBody {
    var url: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders? { get }
    var encoding: ParameterEncoding { get }
    var cookies: [HTTPCookie] { get }
}

// MARK: Default

public extension APIRequestBody {
    var url: String {
        ""
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var parameters: Parameters? {
        nil
    }
    
    var headers: HTTPHeaders? {
        nil
    }
    
    var encoding: ParameterEncoding {
        JSONEncoding.default
    }
    
    var cookies: [HTTPCookie] {
        []
    }
}
