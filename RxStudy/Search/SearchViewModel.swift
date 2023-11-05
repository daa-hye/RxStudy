//
//  SearchViewModel.swift
//  RxStudy
//
//  Created by 박다혜 on 11/5/23.
//

import Foundation
import RxSwift

class SearchViewModel {

    let disposeBag = DisposeBag()

    var data = ["a", "b", "c"]
    lazy var items = BehaviorSubject(value: data)

}
