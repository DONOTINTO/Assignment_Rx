//
//  TestViewController.swift
//  SeSACRxThreads
//
//  Created by 이중엽 on 4/3/24.
//

import UIKit
import RxSwift

class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // testPublish()
        // testBehavior()
        // testReplay()
        testAsync()
    }
    
    func testPublish() {
        
        let publishSubject = PublishSubject<Int>()
        let disposeBag = DisposeBag()
        
        publishSubject.onNext(10)
        
        publishSubject.subscribe { event in
            print(event.element!)
        }.disposed(by: disposeBag)
        
        publishSubject.onNext(20)
    }
    
    func testBehavior() {
        
        let behaviorSubject = BehaviorSubject<Int>(value: 10)
        let disposeBag = DisposeBag()
        
        behaviorSubject.onNext(15)
        
        behaviorSubject.subscribe { event in
            print(event.element!)
        }.disposed(by: disposeBag)
        
        behaviorSubject.onNext(25)
    }

    func testReplay() {
        
        let replaySubject = ReplaySubject<Int>.create(bufferSize: 3)
        let disposeBag = DisposeBag()
        
        replaySubject.onNext(0)
        replaySubject.onNext(5)
        replaySubject.onNext(10)
        replaySubject.onNext(15)
        
        replaySubject.subscribe { event in
            print(event.element!)
        }.disposed(by: disposeBag)
        
        replaySubject.onNext(25)
        
        replaySubject.subscribe { event in
            print(event.element!)
        }.disposed(by: disposeBag)
    }
    
    func testAsync() {
        
        let asyncSubject = AsyncSubject<Int>()
        let disposeBag = DisposeBag()
        
        asyncSubject.onNext(5)
        
        asyncSubject.subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
        
        asyncSubject.onCompleted()
    }
}
