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
        
        let abTests = json["_data"] as? [String: Any] ?? [:]
        
        return ABTestsOutput(dictionary: abTests)
    }
}
