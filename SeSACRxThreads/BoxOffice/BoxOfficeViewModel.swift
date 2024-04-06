//
//  BoxOfficeViewModel.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/05.
//

import Foundation
import RxSwift
import RxCocoa

class BoxOfficeViewModel {
     
    let disposeBag = DisposeBag()
    
    var recent = ["테스트", "테스트1", "테스트2"]
    
    struct Input {
        let searchButtonTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
        let recentText: PublishSubject<String>
    }
    
    struct Output {
        let recent: BehaviorRelay<[String]>
        let boxOffice: PublishSubject<[DailyBoxOfficeList]>
    }
    
    
    func transform(input: Input) -> Output {
        
        let recentList = BehaviorRelay(value: recent)
        let boxOfficeList = PublishSubject<[DailyBoxOfficeList]>()
        
        input.searchButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .map {
                guard let text = Int($0) else { return 20240101 }
                return text
            }.debug()
            .map { String($0) }
            .debug()
            .flatMap {
                BoxOfficeNetwork.fetchBoxOfficeData(date: $0)
            }.debug()
            .subscribe(with: self) { owner, value in
                
                let data = value.boxOfficeResult.dailyBoxOfficeList
                boxOfficeList.onNext(data)
                
            }.disposed(by: disposeBag)
        
        input.recentText.subscribe(with: self) { owner, value in
            
            owner.recent.append(value)
            recentList.accept(owner.recent)
        }.disposed(by: disposeBag)
        
        return Output(recent: recentList, boxOffice: boxOfficeList)
    }
    
    
}




