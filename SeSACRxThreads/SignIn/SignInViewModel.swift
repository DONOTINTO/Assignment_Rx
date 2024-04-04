//
//  SignInViewModel.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import Foundation
import RxSwift
import RxCocoa

class SignInViewModel {
    
    struct Input {
        let emailText: ControlProperty<String?>
        let passwordText: ControlProperty<String?>
        let signUpButtonTapped: ControlEvent<Void>
        let signInBUttonTapped: ControlEvent<Void>
        
    }
    
    struct Output {
        let signInValid: Driver<Bool>
        let signUpButtonTapped: ControlEvent<Void>
        let signInBUttonTapped: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let emailValid = input.emailText.orEmpty.map { $0.count >= 8 && $0.contains("@") }
        let passwordValid = input.passwordText.orEmpty.map { $0.count >= 8 }
        let everythingValid = Observable.combineLatest(emailValid, passwordValid).map { $0 && $1 }.asDriver(onErrorJustReturn: false)
        
        return Output(signInValid: everythingValid, signUpButtonTapped: input.signUpButtonTapped, signInBUttonTapped: input.signInBUttonTapped)
    }
}
