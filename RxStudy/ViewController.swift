//
//  ViewController.swift
//  RxStudy
//
//  Created by 박다혜 on 11/1/23.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {


    @IBOutlet var tabelView: UITableView!

    @IBOutlet var pickerView: UIPickerView!

    let disposeBag = DisposeBag()


    @IBOutlet var number1: UITextField!
    @IBOutlet var number2: UITextField!
    @IBOutlet var number3: UITextField!

    @IBOutlet var result: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        let items = Observable.just(
            (1..<100).map{"\($0)"}
        )

        items
            .bind(to: tabelView.rx.items(cellIdentifier: "Cell")) { (row, element, cell) in
                cell.textLabel?.text = "\(element) @row \(row)"
            }
            .disposed(by: disposeBag)

        tabelView.rx
            .modelSelected(String.self)
            .subscribe(onNext: { value in
                print("tap \(value)")
            })
            .disposed(by: disposeBag)

//        Observable.just([1, 2, 3])
//            .bind(to: pickerView.rx.itemTitles) { _, item in
//                return "\(item)"
//            }
//            .disposed(by: disposeBag)

//        Observable.just([1, 2, 3])
//            .bind(to: pickerView.rx.itemAttributedTitles) { _, item in
//                return NSAttributedString(string: "\(item)" ,
//                                          attributes: [NSAttributedString.Key.underlineColor:UIColor.red, NSAttributedString.Key.underlineStyle:NSUnderlineStyle.double.rawValue
//                                                      ])
//            }
//            .disposed(by: disposeBag)

        Observable.just([UIColor.red, UIColor.green, UIColor.blue])
            .bind(to: pickerView.rx.items) { _, item, _ in
                let view = UIView()
                view.backgroundColor = item
                return view
            }
            .disposed(by: disposeBag)

//        pickerView.rx.modelSelected(Int.self)
//            .subscribe { models in
//                print("selected \(models)")
//            }
//            .disposed(by: disposeBag)

        Observable.combineLatest(number1.rx.text.orEmpty, number2.rx.text.orEmpty, number3.rx.text.orEmpty) { text1, text2, text3 -> Int in
            return (Int(text1) ?? 0) + (Int(text2) ?? 0) + (Int(text3) ?? 0)
        }
        .map { $0.description }
        .bind(to: result.rx.text)
        .disposed(by: disposeBag)

    }


}

