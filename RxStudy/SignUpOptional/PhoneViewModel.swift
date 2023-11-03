//
//  PhoneViewModel.swift
//  RxStudy
//
//  Created by 박다혜 on 11/3/23.
//

import Foundation
import RxSwift

class PhoneViewModel {

    let disposeBag = DisposeBag()

    let phoneTextValue = BehaviorSubject(value: "010")
    let validation = BehaviorSubject(value: false)

    init() {
        bind()
    }

    func bind() {

        phoneTextValue
            .map { $0.count > 12 }
            .subscribe(with: self) { owner, value in
                owner.validation.onNext(value)
            }
            .disposed(by: disposeBag)

    }

}
