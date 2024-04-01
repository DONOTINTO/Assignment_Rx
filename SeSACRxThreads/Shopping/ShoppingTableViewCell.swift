//
//  ShoppingTableViewCell.swift
//  SeSACRxThreads
//
//  Created by 이중엽 on 4/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ShoppingTableViewCell: UITableViewCell {
    
    static let identifier = "ShoppingTableViewCell"
    
    let checkButton = UIButton()
    let shoppingListLabel = UILabel()
    let importantButton = UIButton()
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        
        disposeBag = DisposeBag()
        
        checkButton.isSelected = false
        shoppingListLabel.text = ""
        importantButton.isSelected = false
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ todo: Todo) {
        
        checkButton.isSelected = todo.isChecked
        importantButton.isSelected = todo.isImportant
        shoppingListLabel.text = todo.description
    }
    
    private func configureView() {
        
        [checkButton, shoppingListLabel, importantButton].forEach { contentView.addSubview($0) }
        
        checkButton.snp.makeConstraints {
            $0.verticalEdges.equalTo(contentView).inset(10)
            $0.leading.equalTo(contentView).inset(20)
            $0.height.width.equalTo(shoppingListLabel.snp.height)
        }
        
        shoppingListLabel.snp.makeConstraints {
            $0.verticalEdges.equalTo(contentView).inset(10)
            $0.leading.equalTo(checkButton.snp.trailing).offset(20)
        }
        
        importantButton.snp.makeConstraints {
            $0.verticalEdges.equalTo(contentView).inset(10)
            $0.leading.equalTo(shoppingListLabel.snp.trailing).offset(20)
            $0.trailing.equalTo(contentView).inset(20)
            $0.height.width.equalTo(shoppingListLabel.snp.height)
        }
        
        contentView.backgroundColor = .lightGray.withAlphaComponent(0.3)
        
        shoppingListLabel.font = .systemFont(ofSize: 15)
        
        checkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        checkButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        
        importantButton.setImage(UIImage(systemName: "star"), for: .normal)
        importantButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
    }
}
