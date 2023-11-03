//
//  PasswordViewModel.swift
//  RxStudy
//
//  Created by 박다혜 on 11/3/23.
//

import Foundation
import RxSwift

class PasswordViewModel {

    let disposeBag = DisposeBag()

    let validation = BehaviorSubject(value: false)
    let passwordValue = BehaviorSubject(value: "")

    init() {
        bind()
    }

    func bind() {

        passwordValue
            .map {(6...13).contains($0.count)}
            .subscribe(with: self) { owner, value in
                owner.validation.onNext(value)
            }
            .disposed(by: disposeBag)
        
    }

}
