//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BirthdayViewController: UIViewController {

    let disposeBag = DisposeBag()

    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10 
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")

    let pickedDate = BehaviorSubject(value: Date())
    
    let year = BehaviorSubject(value: 0)
    let month = BehaviorSubject(value: 0)
    let day = BehaviorSubject(value: 0)

    let buttonColor = BehaviorSubject(value: UIColor.lightGray)
    let age = BehaviorSubject(value: 0.0)
    let validation = BehaviorSubject(value: false)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()

        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    }
    
    @objc func nextButtonClicked() {
        print("가입완료")
    }

    func bind() {

        age
            .map { $0 >= 17 }
            .bind(with: self) { owner, value in
                owner.validation.onNext(value)
                
                let color = value ? UIColor.black : UIColor.lightGray
                owner.buttonColor.onNext(color)
            }
            .disposed(by: disposeBag)

        validation
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)

        buttonColor
            .bind(to: nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)

        birthDayPicker.rx.date
            .bind(to: pickedDate)
            .disposed(by: disposeBag)

        year
            .map {"\($0)년"}
            .bind(to: yearLabel.rx.text)
            .disposed(by: disposeBag)

        month
            .map {"\($0)월"}
            .bind(to: monthLabel.rx.text)
            .disposed(by: disposeBag)

        day
            .map {"\($0)일"}
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)

        pickedDate
            .bind(with: self) { owner, date in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)

                owner.year.onNext(component.year ?? 0)
                owner.month.onNext(component.month ?? 0)
                owner.day.onNext(component.day ?? 0)
            }
            .disposed(by: disposeBag)

        pickedDate
            .bind(with: self) { owner, date in

                let interval: Double = date.timeIntervalSinceNow
                let age = abs(interval / (60 * 60 * 24 * 365))
                owner.age.onNext(age)

            }
            .disposed(by: disposeBag)

    }

    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
