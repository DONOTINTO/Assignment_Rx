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
    let barButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: nil, action: nil)
    
    let searchVM = SearchViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configure()
        setSearchController()
        bind()
        
    }
    
    private func bind() {
        
        let searchButtonTapped = searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .distinctUntilChanged()
        
        let itemSelected = tableView.rx.itemSelected
        
        let itemAppend = barButtonItem.rx.tap
        
        let input = SearchViewModel.Input(
            searchButtonTapped: searchButtonTapped,
            dataDelete: itemSelected,
            dataAppend: itemAppend)
        
        let output = searchVM.transform(input: input)
        
        output.items.drive(
            tableView.rx.items(
                cellIdentifier: SearchTableViewCell.identifier,
                cellType: SearchTableViewCell.self)) { (row, element, cell) in
            
            cell.appNameLabel.text = element + "\(row)"
            cell.appIconImageView.backgroundColor = .systemBlue
        }.disposed(by: disposeBag)
        
    }
    
    private func setSearchController() {
        view.addSubview(searchBar)
        navigationItem.titleView = searchBar
        
        navigationItem.rightBarButtonItem = barButtonItem
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
