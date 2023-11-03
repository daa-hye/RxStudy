//
//  NicknameViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NicknameViewController: UIViewController {

    let viewModel = NicknameViewModel()

    let disposeBag = DisposeBag()

    let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
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
        navigationController?.pushViewController(BirthdayViewController(), animated: true)
    }

    func bind() {

        buttonColor
            .bind(to: nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)

        viewModel.validation
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.validation
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, value in
                let color = value ? UIColor.black : UIColor.lightGray
                owner.buttonColor.onNext(color)
            })
            .disposed(by: disposeBag)

        nicknameTextField.rx.text.orEmpty
            .bind(with: viewModel) { owner, value in
                owner.nicknameValue.onNext(value)
            }
            .disposed(by: disposeBag)

    }

    func configureLayout() {
        view.addSubview(nicknameTextField)
        view.addSubview(nextButton)
         
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
