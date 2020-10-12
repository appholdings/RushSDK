//
//  ABTestsManagerDelegate.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 12.10.2020.
//

protocol ABTestsManagerDelegate: class {
    func abTestsManagerDidUpdated(tests: ABTestsOutput)
}

extension ABTestsManagerDelegate {
    func abTestsManagerDidUpdated(tests: ABTestsOutput) {}
}
