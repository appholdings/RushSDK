//
//  PurchaseActionResult.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 13.10.2020.
//

public enum PurchaseActionResult {
    case cancelled
    case completed(ReceiptValidateResponse?)
}
