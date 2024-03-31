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
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        // picker.maximumDate = Date()
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
        label.text = "2023년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    let monthLabel: UILabel = {
       let label = UILabel()
        label.text = "33월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    let dayLabel: UILabel = {
       let label = UILabel()
        label.text = "99일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    let nextButton = PointButton(title: "가입하기")
    
    let dateSubject = BehaviorSubject.Observer(value: "2024.3.29")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
    }
    
    func bind() {
        
        nextButton.rx.tap.subscribe { _ in
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
            
            sceneDelegate.window?.rootViewController = SampleViewController()
            sceneDelegate.window?.makeKeyAndVisible()
            
        }.disposed(by: disposeBag)
        
        dateSubject.bind(with: self) { owner, text in
            let date = text.components(separatedBy: ".")
            owner.yearLabel.text = date[0]
            owner.monthLabel.text = date[1]
            owner.dayLabel.text = date[2]
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.M.dd"
            guard let pickerDate = formatter.date(from: text) else { return }
            owner.birthDayPicker.date = pickerDate
            
        }.disposed(by: disposeBag)
        
        birthDayPicker.rx.date.bind(with: self) { owner, date in
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.M.dd"
            let newDateStr = formatter.string(from: date)
            
            owner.dateSubject.onNext(newDateStr)
        }.disposed(by: disposeBag)
        
        let dateValid = birthDayPicker.rx.date.map { date in
            
            let chosen = Calendar.current.dateComponents([.year, .month, .day], from: date)
            let now = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            
            var differ = now.year! - chosen.year!
            
            if now.month! >= chosen.month!, now.day! > chosen.day! {
                differ -= 1
            }
            
            return differ >= 17
        }
        
        dateValid.bind(with: self) { owner, isValid in
            
            owner.infoLabel.text = isValid ? "가입 가능한 나이입니다." : "만 17세 이상만 가입 가능합니다."
            owner.infoLabel.textColor = isValid ? .systemBlue : .systemRed
            owner.nextButton.backgroundColor = isValid ? .systemBlue : .lightGray
            owner.nextButton.isEnabled = isValid
            
        }.disposed(by: disposeBag)
    }
}

extension BirthdayViewController {
    
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
