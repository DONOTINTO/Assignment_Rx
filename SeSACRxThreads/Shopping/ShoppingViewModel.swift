//
//  ShoppingViewModel.swift
//  SeSACRxThreads
//
//  Created by 이중엽 on 4/1/24.
//

import Foundation
import RxSwift
import RxCocoa

class ShoppingViewModel {
    
    var disposeBag = DisposeBag()
    
    private var todoList: [Todo] = []
    lazy var todoListObservable = BehaviorSubject(value: todoList)
    
    let appendButtonClickedObservable = PublishRelay<String>()
    let deleteButtonClickedObservable = PublishRelay<IndexPath>()
    let checkButtonClickedObservable = PublishSubject<Int>()
    let importantButtonClickedObservable = PublishSubject<Int>()
    let searchObservable = PublishSubject<String>()
    
    init() {
        
        // 추가 버튼 클릭 이벤트 처리
        appendButtonClickedObservable.asDriver(onErrorJustReturn: "").drive(with: self) { owner, value in
            
            let newTodo = Todo(isChecked: false, description: value, isImportant: false)
            owner.todoList.append(newTodo)
            
            owner.todoListObservable.onNext(owner.todoList)
        }.disposed(by: disposeBag)
        
        // 삭제 버튼 클릭 이벤트 처리
        deleteButtonClickedObservable.asDriver(onErrorJustReturn: IndexPath(row: 0, section: 0)).drive(with: self) { owner, indexPath in
            
            owner.todoList.remove(at: indexPath.row)
            
            owner.todoListObservable.onNext(owner.todoList)
        }.disposed(by: disposeBag)
        
        // 체크 버튼 클릭 이벤트 처리
        checkButtonClickedObservable.bind(with: self) { owner, row in
            
            owner.todoList[row].isChecked.toggle()
            
            owner.todoListObservable.onNext(owner.todoList)
        }.disposed(by: disposeBag)
        
        // 중요 버튼 클릭 이벤트 처리
        importantButtonClickedObservable.bind(with: self) { owner, row in
            
            owner.todoList[row].isImportant.toggle()
            
            owner.todoListObservable.onNext(owner.todoList)
        }.disposed(by: disposeBag)
        
        // 실시간 검색 이벤트 처리
        searchObservable.bind(with: self) { owner, value in
            
            let newTodoList = owner.todoList.filter { $0.description.lowercased().contains(value.lowercased()) }
            // 공백일 시 원래 데이터로 복구
            owner.todoListObservable.onNext(value.isEmpty ? owner.todoList : newTodoList)
        }.disposed(by: disposeBag)
    }
}
