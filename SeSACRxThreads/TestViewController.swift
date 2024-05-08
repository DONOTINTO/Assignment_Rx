//
//  TestViewController.swift
//  SeSACRxThreads
//
//  Created by 이중엽 on 4/3/24.
//

import UIKit
import RxSwift
import RxCocoa

class TestViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // testPublish()
        // testBehavior()
        // testReplay()
        // testFlatMap()
        testError()
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
    
    func testFlatMap() {
        
        let timer1 = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance).map({"o1: \($0)"})
        let timer2 = Observable<Int>.interval(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance).map({"o2: \($0)"})
        
        Observable.of(timer1,timer2)
            .map({$0})
            .subscribe(onNext: { value in
                
            }).disposed(by: disposeBag)
    }
    
    func testError() {
        
        
    }
}
