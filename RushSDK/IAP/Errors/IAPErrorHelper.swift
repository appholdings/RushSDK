//
//  IAPErrorMapper.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 08.10.2020.
//

import StoreKit

enum IAPErrorHelper {
    static let SSErrorDomain = "SSErrorDomain"
    static let SSServerErrorDomain = "SSServerErrorDomain"
    
    static func treatErrorAsCancellation(_ error: Error) -> Bool {
        let error = error as NSError

        switch (error.domain, error.code) {
        case (SKError.errorDomain, SKError.unknown.rawValue):
            // неизвестную ошибку приравниваем к отмене
            return true
        case (SKError.errorDomain, SKError.paymentCancelled.rawValue):
            // документированная ошибка при отмене платежа
            return true
        case (SSErrorDomain, 16), (SSErrorDomain, 100):
            // приватные ошибки, пользователь отказался авторизовываться для обновления receipt, receipt не
            // найден на сервере
            return true
        default:
            return false
        }
    }

    static func treatErrorAsSuccess(_ error: Error) -> Bool {
        let error = error as NSError

        switch (error.domain, error.code) {
        case (SSServerErrorDomain, 3720):
            // прилетает когда мы пытаемся сделать апгрейд или даунгрейд действующей подписки. т.е. само
            // действие корректно выполняется 
            return true
        default:
            return false
        }
    }
}
