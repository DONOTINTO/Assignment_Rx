//
//  JokeViewModel.swift
//  SeSACRxThreads
//
//  Created by 이중엽 on 4/8/24.
//

import Foundation
import RxSwift
import RxCocoa

class JokeViewModel {
    
    var jokes: [Joke] = []
    let disposeBag = DisposeBag()
    // lazy var jokesSubject = BehaviorSubject<[Joke]>(value: jokes)
    
    struct Input {
        let appendButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let jokeSubject: PublishSubject<[Joke]>
    }
    
    func transform(input: Input) -> Output {
        
        let jokeSubject = PublishSubject<[Joke]>()
        
        input.appendButtonClicked
            .flatMap { JokeNetwork.fetchJoke() }
            .subscribe(with: self) { owner, joke in
                
                owner.jokes.append(joke)
                jokeSubject.onNext(owner.jokes)
            } onError: { owner, error in
                print(error)
            }.disposed(by: disposeBag)
        
        return Output(jokeSubject: jokeSubject)
    }
}
