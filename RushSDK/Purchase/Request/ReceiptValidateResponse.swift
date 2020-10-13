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
}
