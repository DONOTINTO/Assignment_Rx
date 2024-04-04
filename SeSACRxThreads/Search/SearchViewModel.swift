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
    
    private var data = ["A", "B", "C", "AB", "D", "ABC", "BBB", "EC", "SA", "AAAB", "ED", "F", "G", "H"]
    private lazy var items = BehaviorSubject(value: data)
    private let disposeBag = DisposeBag()
    
    struct Input {
        let searchButtonTapped: Observable<String>
        let dataDelete: ControlEvent<IndexPath>
        let dataAppend: ControlEvent<Void>
    }
    
    struct Output {
        let items: Driver<[String]>
    }
    
    func transform(input: Input) -> Output {
        
        input.dataAppend.bind(with: self) { owner, _ in
            
            let sample = ["A", "B", "C", "D", "E"]
            
            owner.data.append(sample.randomElement()!)

            owner.items.onNext(owner.data)
        }.disposed(by: disposeBag)
        
        input.dataDelete.bind(with: self) { owner, indexPath in
            
            owner.data.remove(at: indexPath.row)
            
            owner.items.onNext(owner.data)
            
        }.disposed(by: disposeBag)
        
        let items = items.asDriver(onErrorJustReturn: [])
        
        return Output(items: items)
    }
}
