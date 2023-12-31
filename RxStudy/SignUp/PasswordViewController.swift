//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PasswordViewController: UIViewController {

    let viewModel = PasswordViewModel()

    let disposeBag = DisposeBag()

    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nextButton = PointButton(title: "다음")

    let buttonColor = BehaviorSubject(value: UIColor.lightGray)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()

        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(PhoneViewController(), animated: true)
    }

    func bind() {

        viewModel.validation
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.validation
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, value in
                let color = value ? UIColor.black : UIColor.lightGray
                owner.buttonColor.onNext(color)
            }
            .disposed(by: disposeBag)

        buttonColor
            .bind(to: nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)

        passwordTextField.rx.text.orEmpty
            .subscribe(with: viewModel, onNext: { owner, value in
                owner.passwordValue.onNext(value)
            })
            .disposed(by: disposeBag)

    }

    func configureLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
         
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
