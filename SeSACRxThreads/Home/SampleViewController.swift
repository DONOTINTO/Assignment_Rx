//
//  SampleViewController.swift
//  SeSACRxThreads
//
//  Created by 이중엽 on 3/31/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SampleViewController: UIViewController {
    
    let textField = UITextField()
    let addButton = UIButton()
    let tableView = UITableView()
    
    let items: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        bind()
    }
    
    func bind() {
        
        items.bind(to: tableView.rx.items) { (tableView, row, element) in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = element
            
            return cell
        }.disposed(by: disposeBag)
        
        addButton.rx.tap.bind(with: self) { owner, _ in
            
            var items = owner.items.value
            items.append(owner.textField.text!)
            
            owner.items.accept(items)
            
        }.disposed(by: disposeBag)
    }
}

extension SampleViewController {
    
    func configure() {
        
        [textField, addButton, tableView].forEach { view.addSubview($0) }
        
        textField.snp.makeConstraints {
            $0.top.leading.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        addButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
            $0.width.equalTo(100)
            $0.leading.equalTo(textField.snp.trailing)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.backgroundColor = .white
        textField.placeholder = "입력해주세요"
        addButton.setTitle("추가", for: .normal)
        addButton.backgroundColor = .systemBlue
        
        tableView.backgroundColor = .lightGray
        
    }
}
