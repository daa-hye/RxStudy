//
//  SignInViewModel.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import Foundation
import RxSwift

class SignInViewModel {

    let emailValue = PublishSubject<String>()
    let passwordValue = PublishSubject<String>()

    lazy var validation = Observable.combineLatest(emailValue, passwordValue) { first, second in
        return first.count > 8 && second.count >= 6
    }

}
