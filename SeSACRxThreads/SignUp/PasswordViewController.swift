//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PasswordViewController: UIViewController {
   
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let descriptionLabel = UILabel()
    
    let validText = Observable.just("8자 이상 입력해주세요.")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
    }
    
    func bind() {
        
        validText.bind(to: descriptionLabel.rx.text).disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty.map { $0.count > 8 }
            .bind(to: nextButton.rx.isEnabled, descriptionLabel.rx.isHidden ).disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty.map { $0.count > 8}
            .bind(with: self) { owner, isValid in
                
                owner.nextButton.backgroundColor = isValid ? .systemPink : .lightGray
            }.disposed(by: disposeBag)
        
        nextButton.rx.tap.subscribe(with: self) { owner, _ in
            owner.navigationController?.pushViewController(PhoneViewController(), animated: true)
        }.disposed(by: disposeBag)
    }
}

extension PasswordViewController {
    
    func configureLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(nextButton)
         
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
