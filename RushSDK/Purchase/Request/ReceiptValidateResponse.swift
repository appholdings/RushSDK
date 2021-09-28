//
//  ReceiptValidateResponse.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 13.10.2020.
//

final class ReceiptValidateResponseMapper {
    static func map(from response: Any) -> ReceiptValidateResponse? {
        guard
            let json = response as? [String: Any],
            let data = try? JSONSerialization.data(withJSONObject: json, options: []),
            let response = try? JSONDecoder().decode(ReceiptValidateResponse.self, from: data)
        else {
            return nil
        }
        
        return response
    }
}

public struct ReceiptValidateResponse: Decodable {
    public let userId: Int
    public let userToken: String
    public let activeSubscription: Bool
    public let accessValidTill: String
    
    private enum Keys: String, CodingKey {
        case data = "_data"
        case userId = "user_id"
        case userToken = "user_token"
        case activeSubscription = "active_subscription"
        case accessValidTill = "access_valid_till"
    }
    
    init(userId: Int, userToken: String, activeSubscription: Bool, onTrial: Bool, accessValidTill: String) {
        self.userId = userId
        self.userToken = userToken
        self.activeSubscription = activeSubscription
        self.accessValidTill = accessValidTill
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let data = try container.nestedContainer(keyedBy: Keys.self, forKey: .data)
        
        userId = try data.decode(Int.self, forKey: .userId)
        userToken = try data.decode(String.self, forKey: .userToken)
        activeSubscription = try data.decode(Bool.self, forKey: .activeSubscription)
        accessValidTill = try data.decode(String.self, forKey: .accessValidTill)
    }
}
