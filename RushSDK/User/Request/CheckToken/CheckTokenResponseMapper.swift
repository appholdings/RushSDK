//
//  CheckTokenResponseMapper.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 21.02.2021.
//

final class CheckTokenResponseMapper {
    static func isValideToken(in response: Any) -> Bool {
        guard
            let json = response as? [String: Any],
            let code = json["_code"] as? Int
        else {
            return false
        }
        
        return code == 200
    }
}
