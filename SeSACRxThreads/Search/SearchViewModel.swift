//
//  SearchViewModel.swift
//  SeSACRxThreads
//
//  Created by 이중엽 on 4/1/24.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    
    var data = ["A", "B", "C", "AB", "D", "ABC", "BBB", "EC", "SA", "AAAB", "ED", "F", "G", "H"]
    
    let dataAppendObservable = PublishSubject<Void>()
    let dataDeleteObservable = PublishSubject<IndexPath>()
    let searchButtonClickedObservable = PublishSubject<String>()
    
    lazy var items = BehaviorSubject(value: data)
    
    let disposeBag = DisposeBag()
    
    init() {
        
        // 아이템 추가
        dataAppendObservable.bind(with: self) { owner, _ in
            
            let sample = ["A", "B", "C", "D", "E"]
            
            owner.data.append(sample.randomElement()!)

            owner.items.onNext(owner.data)
            
        }.disposed(by: disposeBag)
        
        // 아이템 삭제
        dataDeleteObservable.bind(with: self) { owner, indexPath in
            
            owner.data.remove(at: indexPath.row)
            
            owner.items.onNext(owner.data)
            
        }.disposed(by: disposeBag)
        
        // 검색 버튼 클릭(엔터)
        searchButtonClickedObservable.bind(with: self) { owner, value in
            
            if value == "" { return }
            print("검색 버튼 클릭 완료 \(value)")
            
            let filteredData = owner.data.filter { $0.contains(value) }
            owner.items.onNext(filteredData)
            
        }.disposed(by: disposeBag)
    }
}
