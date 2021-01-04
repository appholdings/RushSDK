//
//  GetConfigurationResponseMapper.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 04.01.2021.
//

final class GetConfigurationResponseMapper {
    static func map(from response: Any) -> SDKConfiguration? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let revenueCoef = data["revenue_coef"] as? Double
        else {
            return nil
        }
        
        return SDKConfiguration(revenueCoef: revenueCoef)
    }
}
