//
//  JokeNetwork.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/08.
//

import Foundation
import Alamofire
import RxSwift

final class JokeNetwork {
    
    static let baseUrl = "https://v2.jokeapi.dev/joke/Programming?type=single"
    
   static func fetchJoke() -> Observable<Joke> {
       
       return Observable.create { observer -> Disposable in
           
           AF.request(URL(string: baseUrl)!)
               .responseDecodable(of: Joke.self) { response in
                   
                   switch response.result {
                       
                   case .success(let success):
                       observer.onNext(success)
                       observer.onCompleted()
                   case .failure(let failure):
                       observer.onError(failure)
                   }
               }
           
           return Disposables.create()
       }
   }
    
   static func fetchJokeWithSingle() -> Single<Joke> {
       
       return Single.create { single -> Disposable in
           
           AF.request(URL(string: baseUrl)!)
               .responseDecodable(of: Joke.self) { response in
                   
                   switch response.result {
                       
                   case .success(let success):
                       single(.success(success))
                   case .failure(let failure):
                       single(.failure(failure))
                   }
               }
           
           return Disposables.create()
           
       }
   }
    
//    static func fetchJokeWithObservable() -> Observable<Joke> {
//    }
    
}
