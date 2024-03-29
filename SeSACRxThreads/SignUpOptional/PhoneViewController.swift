//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let descriptionLabel = UILabel()
    
    let identificationNumber = Observable.just("010")
    let isValid = BehaviorSubject(value: false)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
    }
    
    func bind() {
        
        nextButton.rx.tap.bind(with: self) { owner, _ in
            owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
        }.disposed(by: disposeBag)
        
        isValid.bind(with: self) { owner, isValid in
            
            owner.descriptionLabel.text = isValid ? "" : "숫자만 입력 가능합니다."
            owner.nextButton.backgroundColor = isValid ? .systemPink : .lightGray
            owner.nextButton.isEnabled = isValid
            
        }.disposed(by: disposeBag)
        
        // - 첫 화면 진입 시 010을 텍스트필드에 바로 띄워줍니다.
        identificationNumber.bind(to: phoneTextField.rx.text).disposed(by: disposeBag)
        
        // 조건 1. 숫자가 아닐 경우
        // 조건 2. 10자 이상
        phoneTextField.rx.text.orEmpty.map { Int($0) != nil && $0.count >= 10 }
            .bind(to: isValid).disposed(by: disposeBag)
    }
}

extension PhoneViewController {
    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
