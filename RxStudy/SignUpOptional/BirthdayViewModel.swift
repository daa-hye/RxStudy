//
//  BirthdayViewModel.swift
//  RxStudy
//
//  Created by 박다혜 on 11/3/23.
//

import Foundation
import RxSwift

class BirthdayViewModel {

    let disposeBag = DisposeBag()

    let dateValue = BehaviorSubject(value: Date())

    let year = BehaviorSubject(value: 0)
    let month = BehaviorSubject(value: 0)
    let day = BehaviorSubject(value: 0)

    let ageValue = BehaviorSubject(value: 0.0)
    let validation = BehaviorSubject(value: false)

    init() {
        bind()
    }

    func bind() {

        ageValue
            .map { $0 >= 17 }
            .bind(with: self) { owner, value in
                owner.validation.onNext(value)
            }
            .disposed(by: disposeBag)

        dateValue
            .bind(with: self) { owner, date in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)

                owner.year.onNext(component.year ?? 0)
                owner.month.onNext(component.month ?? 0)
                owner.day.onNext(component.day ?? 0)
            }
            .disposed(by: disposeBag)

        dateValue
            .bind(with: self) { owner, date in

                let interval: Double = date.timeIntervalSinceNow
                let age = abs(interval / (60 * 60 * 24 * 365))
                owner.ageValue.onNext(age)

            }
            .disposed(by: disposeBag)
    }

}
