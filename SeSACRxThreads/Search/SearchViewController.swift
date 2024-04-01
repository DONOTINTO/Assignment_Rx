//
//  SearchViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/01.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        view.backgroundColor = .white
        view.rowHeight = 180
        view.separatorStyle = .none
        return view
    }()
    
    let searchBar = UISearchBar()
    
    let searchVM = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configure()
        setSearchController()
        bind()
        
    }
    
    private func bind() {
        
        searchVM.items.bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) {
            (row, element, cell) in
            
            cell.appNameLabel.text = element + "\(row)"
            cell.appIconImageView.backgroundColor = .systemBlue
            
        }.disposed(by: searchVM.disposeBag)
        
        searchBar.rx.searchButtonClicked.withLatestFrom(searchBar.rx.text.orEmpty).distinctUntilChanged().subscribe(with: self) { owner, value in
            
            owner.searchVM.searchButtonClickedObservable.onNext(value)
            
        }.disposed(by: searchVM.disposeBag)
        
        tableView.rx.itemSelected.bind(with: self) { owner, indexPath in
            
            owner.searchVM.dataDeleteObservable.onNext(indexPath)
            
        }.disposed(by: searchVM.disposeBag)
    }
    
    private func setSearchController() {
        view.addSubview(searchBar)
        navigationItem.titleView = searchBar
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(plusButtonClicked))
    }
    
    @objc func plusButtonClicked() {
        
        searchVM.dataAppendObservable.onNext(())
    }
}

extension SearchViewController {
    
    private func configure() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
