//
//  ShoppingViewController.swift
//  SeSACRxThreads
//
//  Created by 이중엽 on 4/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ShoppingViewController: UIViewController {
    
    let makeListLayoutView = UIView()
    let makeListTextField = UITextField()
    let makeListButton = UIButton()
    let shoppingListTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    let shoppingVM = ShoppingViewModel()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        bind()
    }
    
    private func bind() {
        
        
        // 테이블 뷰 셀 등록
        shoppingVM.todoListObservable
            .bind(to: shoppingListTableView.rx.items(cellIdentifier: ShoppingTableViewCell.identifier, cellType: ShoppingTableViewCell.self)) {
            (row, element, cell) in
            
            cell.configure(element)
            
            // 체크 버튼 클릭 이벤트
            cell.checkButton.rx.tap.bind(with: self) { owner, _ in
                
                owner.shoppingVM.checkButtonClickedObservable.onNext(row)
                
            }.disposed(by: cell.disposeBag)
                
            // 중요 버튼 클릭 이벤트
            cell.importantButton.rx.tap.bind(with: self) { owner, _ in
                
                owner.shoppingVM.importantButtonClickedObservable.onNext(row)
                
            }.disposed(by: cell.disposeBag)
            
        }.disposed(by: shoppingVM.disposeBag)
        
        // 셀 버튼 클릭 이벤트
        shoppingListTableView.rx.modelSelected(Todo.self).bind(with: self) { owner, data in
            
            owner.navigationController?.pushViewController(SearchViewController(), animated: true)
        }.disposed(by: disposeBag)
        
        // 추가 버튼 클릭 이벤트
        makeListButton.rx.tap.withLatestFrom(makeListTextField.rx.text.orEmpty)
            .bind(with: self, onNext: { owner, value in
            
            owner.shoppingVM.appendButtonClickedObservable.accept(value)
        }).disposed(by: disposeBag)
        
        // 삭제 버튼 클릭 이벤트
        shoppingListTableView.rx.itemDeleted
            .bind(with: self) { owner, indexPath in
                
                owner.shoppingVM.deleteButtonClickedObservable.accept(indexPath)
            }.disposed(by: disposeBag)
        
        // 실시간 검색 이벤트
        makeListTextField.rx.text.orEmpty.map { $0.trimmingCharacters(in: .whitespaces) }.distinctUntilChanged().bind(with: self) { owner, value in
            
            owner.shoppingVM.searchObservable.onNext(value)
        }.disposed(by: disposeBag)
    }
}

extension ShoppingViewController {
    
    private func configureView() {
        
        [makeListLayoutView, makeListTextField, makeListButton, shoppingListTableView].forEach { view.addSubview($0) }
        
        makeListLayoutView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(50)
        }
        
        makeListTextField.snp.makeConstraints {
            $0.centerY.equalTo(makeListLayoutView)
            $0.height.equalTo(34)
            $0.leading.equalTo(makeListLayoutView).inset(10)
        }
        
        makeListButton.snp.makeConstraints {
            $0.centerY.equalTo(makeListLayoutView)
            $0.height.equalTo(34)
            $0.width.equalTo(50)
            $0.leading.equalTo(makeListTextField.snp.trailing).offset(5)
            $0.trailing.equalTo(makeListLayoutView).inset(10)
        }
        
        shoppingListTableView.snp.makeConstraints {
            $0.top.equalTo(makeListLayoutView.snp.bottom)
            $0.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.backgroundColor = .white
        shoppingListTableView.backgroundColor = .clear
        shoppingListTableView.register(ShoppingTableViewCell.self, forCellReuseIdentifier: ShoppingTableViewCell.identifier)
        shoppingListTableView.rowHeight = UITableView.automaticDimension
        makeListLayoutView.backgroundColor = .lightGray.withAlphaComponent(0.3)
        makeListLayoutView.layer.cornerRadius = 10
        
        makeListTextField.backgroundColor = .clear
        makeListButton.backgroundColor = .lightGray
        
        makeListTextField.placeholder = "무엇을 구매하실 건가요?"
        makeListButton.setTitle("추가", for: .normal)
        makeListButton.setTitleColor(.black, for: .normal)
        makeListButton.layer.cornerRadius = 10
    }
}
