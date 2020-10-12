//
//  Weak.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 12.10.2020.
//

final class Weak<T> {
    weak private var value: AnyObject?
    
    var weak: T? {
        return value as? T
    }
    
    init<T: AnyObject>(_ value: T) {
        self.value = value
    }
}
