//
//  Routines.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 09.10.2020.
//

func deferred<T>(file: StaticString = #file, line: UInt = #line) -> T {
    fatalError("Value isn't set before first use", file: file, line: line)
}
