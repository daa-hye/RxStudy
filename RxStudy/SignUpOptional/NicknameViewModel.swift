//
//  NicknameViewModel.swift
//  RxStudy
//
//  Created by 박다혜 on 11/3/23.
//

import Foundation
import RxSwift

class NicknameViewModel {

    let disposeBag = DisposeBag()

    let validation = BehaviorSubject(value: false)
    let nicknameValue = BehaviorSubject(value: "")

    init() {
        bind()
    }

    func bind() {

        nicknameValue
            .map {(2...6).contains($0.count)}
            .bind(with: self) { owner, value in
                owner.validation.onNext(value)
            }
            .disposed(by: disposeBag)
        
    }

}
