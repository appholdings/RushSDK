//
//  Test.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 06.10.2020.
//

import RxSwift

public final class Test {
    private var count = 0
    
    private var disposeBag = DisposeBag()
    
    public init() {}
    
    public func get(handler: @escaping ((String) -> Void)) {
        Single<String>
            .create { event in
                event(.success("count: \(self.count)"))
                
                return Disposables.create()
            }
            .delaySubscription(RxTimeInterval.seconds(1), scheduler: MainScheduler.asyncInstance)
            .subscribe(onSuccess: { string in
                handler(string)
            })
            .disposed(by: disposeBag)
    }
}
