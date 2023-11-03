//
//  SignUpViewModel.swift
//  RxStudy
//
//  Created by 박다혜 on 11/3/23.
//

import Foundation
import RxSwift

class SignUpViewModel {

    let disposeBag = DisposeBag()

    let mailValue = BehaviorSubject(value: "")
    let validation = BehaviorSubject(value: false)

    init() {
        bind()
    }

    func bind() {

        mailValue
            .bind(with: self) { owner, value in
                let validate = owner.checkEmail(value)
                owner.validation.onNext(validate)
            }
            .disposed(by: disposeBag)

    }

    func checkEmail(_ mail: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]{2,30}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: mail)
    }

}
