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
        let emailValue: ControlProperty<String?>
        let passwordValue: ControlProperty<String?>
    }

    struct Output {
        let validation: Observable<Bool>
    }

    func transform(input: Input) -> Output {

        return Output(validation: Observable
            .combineLatest(input.emailValue.orEmpty,
                           input.passwordValue.orEmpty) { first, second in
            return first.count > 8 && second.count >= 6
        })

    }

}
