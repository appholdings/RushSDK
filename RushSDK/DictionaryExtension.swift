//
//  DictionaryExtension.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 15.10.2020.
//

extension Dictionary {
    mutating func merge(dict: [Key: Value]) {
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
