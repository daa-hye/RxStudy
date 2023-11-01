//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {

    let disposeBag = DisposeBag()

    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")

    let phoneTextValue = BehaviorSubject(value: "010")
    let buttonColor = BehaviorSubject(value: UIColor.lightGray)
    let validation = BehaviorSubject(value: false)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()

        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(NicknameViewController(), animated: true)
    }

    func bind() {

        validation
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)

        buttonColor
            .bind(to: nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)

        phoneTextValue
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)

        phoneTextValue
            .map { $0.count > 12 }
            .bind(with: self) { owner, value in
                let color = value ? UIColor.black : UIColor.lightGray
                owner.buttonColor.onNext(color)
                owner.validation.onNext(value)
            }
            .disposed(by: disposeBag)

        phoneTextField.rx.text.orEmpty
            .bind(with: self) { owner, value in
                let result = value.formated(by: "###-####-####")
                owner.phoneTextValue.onNext(result)
            }
            .disposed(by: disposeBag)

    }

    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
