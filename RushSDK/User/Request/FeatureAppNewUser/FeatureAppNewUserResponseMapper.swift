//
//  FeatureAppNewUserResponseMapper.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 13.01.2021.
//

final class FeatureAppNewUserResponseMapper {
    static func map(from response: Any) -> String? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any]
        else {
            return nil
        }
        
        return data["user_token"] as? String
    }
}
