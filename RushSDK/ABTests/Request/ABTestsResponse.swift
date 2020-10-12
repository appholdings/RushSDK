//
//  ABTestsResponse.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 12.10.2020.
//

final class ABTestsResponse {
    static func map(from response: Any) -> ABTestsOutput? {
        guard let json = response as? [String: Any] else {
            return nil
        }
        
        return ABTestsOutput(dictionary: json)
    }
}
