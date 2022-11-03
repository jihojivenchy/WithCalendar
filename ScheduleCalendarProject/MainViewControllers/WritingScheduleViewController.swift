//
//  WritingScheduleViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/11/02.
//

import UIKit
import SnapKit

final class WritingScheduleViewController: UIViewController {
//MARK: - Properties
    
    private let dismissButton = UIButton()
    
    private let saveDataButton : UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        button.tintColor = .darkGray
        
        return button
    }()
    
    private let scrollView = UIScrollView()
    
    private let titleTextField = UITextField()
    
    private let memoButton = UIButton()
    private let chooseColorButton = UIButton()
    
    private let setDateLabel = UILabel()
    private let setDateView = UIView()
    
    private let startButton = UIButton()
    private let endButton = UIButton()
    
    private let dateCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let datePicker = UIDatePicker()
    
    private let dateFormatter = DateFormatter()
    

//MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        
        UserDefaults.standard.set("", forKey: "writedMemo") //메모 초기화
    }
    
    
//MARK: - ViewMethod
    
    private func addSubViews() {
        
        view.backgroundColor = .customGray
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))//개체들이 모두 스크롤뷰 위에 존재하기 때문에 스크롤뷰 특성 상 touchBegan함수가 실행되지 않는다. 따라서 스크롤뷰에 대한 핸들러 캐치를 등록해주어야 한다
        
        view.addSubview(dismissButton)
        dismissButton.setBackgroundImage(UIImage(systemName: "x.circle"), for: .normal)
        dismissButton.tintColor = .darkGray
        dismissButton.addTarget(self, action: #selector(dismissButtonPressed(_:)), for: .touchUpInside)
        dismissButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.left.equalTo(view).inset(10)
            make.width.height.equalTo(30)
        }
        
        view.addSubview(saveDataButton)
        saveDataButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.right.equalTo(view).inset(10)
            make.width.height.equalTo(30)
        }
        
        view.addSubview(scrollView)
        scrollView.backgroundColor = .customGray
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(dismissButton.snp_bottomMargin).offset(20)
            make.bottom.right.left.equalToSuperview()
        }
        
        scrollView.addSubview(titleTextField)
        titleTextField.placeholder = "제목을 입력하세요."
        titleTextField.delegate = self
        titleTextField.textColor = .black
        titleTextField.font = .systemFont(ofSize: 30)
        titleTextField.backgroundColor = .white
        titleTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0))
        titleTextField.leftViewMode = .always
        titleTextField.clearButtonMode = .always
        titleTextField.layer.cornerRadius = 10
        titleTextField.clipsToBounds = true
        titleTextField.layer.borderColor = UIColor.darkGray.cgColor
        titleTextField.layer.borderWidth = 1
        titleTextField.becomeFirstResponder()
        titleTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.right.left.equalTo(view).inset(20)
            make.height.equalTo(70)
        }
        
        scrollView.addSubview(chooseColorButton)
        chooseColorButton.addTarget(self, action: #selector(colorButtonPressed(_:)), for: .touchUpInside)
        chooseColorButton.setTitle("컬러", for: .normal)
        chooseColorButton.setTitleColor(.darkGray, for: .normal)
        chooseColorButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        chooseColorButton.clipsToBounds = true
        chooseColorButton.backgroundColor = .white
        chooseColorButton.layer.borderColor = UIColor.darkGray.cgColor
        chooseColorButton.layer.borderWidth = 1
        chooseColorButton.layer.cornerRadius = 10
        chooseColorButton.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp_bottomMargin).offset(40)
            make.left.equalTo(view).inset(20)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        scrollView.addSubview(memoButton)
        memoButton.addTarget(self, action: #selector(memoButtonPressed(_:)), for: .touchUpInside)
        memoButton.setTitle("메모", for: .normal)
        memoButton.setTitleColor(.darkGray, for: .normal)
        memoButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        memoButton.clipsToBounds = true
        memoButton.layer.cornerRadius = 10
        memoButton.layer.borderColor = UIColor.darkGray.cgColor
        memoButton.layer.borderWidth = 1
        memoButton.backgroundColor = .white
        memoButton.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp_bottomMargin).offset(40)
            make.left.equalTo(chooseColorButton.snp_rightMargin).offset(30)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        scrollView.addSubview(setDateLabel)
        setDateLabel.text = "날짜 설정"
        setDateLabel.textColor = .darkGray
        setDateLabel.font = .systemFont(ofSize: 20)
        setDateLabel.snp.makeConstraints { make in
            make.top.equalTo(memoButton.snp_bottomMargin).offset(40)
            make.left.equalToSuperview().inset(20)
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        
        scrollView.addSubview(setDateView)
        setDateView.backgroundColor = .customGray
        setDateView.clipsToBounds = true
        setDateView.layer.cornerRadius = 10
        addTopBorder(with: .darkGray, andWidth: 1)
        setDateView.snp.makeConstraints { make in
            make.top.equalTo(setDateLabel.snp_bottomMargin).offset(20)
            make.left.right.equalTo(view)
            make.height.equalTo(450)
            make.bottom.equalToSuperview().inset(10)
        }
        
        guard let savedDate = UserDefaults.standard.string(forKey: "selectedDate") else{return}
        
        setDateView.addSubview(startButton)
        startButton.setTitle("시작: \(savedDate)", for: .normal)
        startButton.setTitleColor(.darkGray, for: .normal)
        startButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        startButton.clipsToBounds = true
        startButton.layer.cornerRadius = 10
        startButton.layer.borderColor = UIColor.darkGray.cgColor
        startButton.layer.borderWidth = 1
        startButton.backgroundColor = .white
        startButton.tag = 0
        startButton.addTarget(self, action: #selector(dateButtonPreesed(_:)), for: .touchUpInside)
        startButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        setDateView.addSubview(endButton)
        endButton.setTitle("종료: \(savedDate)", for: .normal)
        endButton.setTitleColor(.darkGray, for: .normal)
        endButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        endButton.clipsToBounds = true
        endButton.layer.cornerRadius = 10
        endButton.layer.borderColor = UIColor.darkGray.cgColor
        endButton.layer.borderWidth = 1
        endButton.backgroundColor = .white
        endButton.tag = 1
        endButton.addTarget(self, action: #selector(dateButtonPreesed(_:)), for: .touchUpInside)
        endButton.snp.makeConstraints { make in
            make.top.equalTo(startButton.snp_bottomMargin).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        
//        setDateView.addSubview(dateCollectionView)
//        dateCollectionView.backgroundColor = .clear
//        dateCollectionView.snp.makeConstraints { make in
//            make.top.equalTo(endButton.snp_bottomMargin).offset(20)
//            make.left.right.equalToSuperview().inset(20)
//            make.height.equalTo(300)
//        }
        
    }
    
    private func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: setDateView.frame.width, height: borderWidth)
        setDateView.addSubview(border)
    } //view의 border를 위쪽에만 그리기.
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
    }//뷰 터치 시 endEditing 발생
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            view.endEditing(true) // todo...
        }
        sender.cancelsTouchesInView = false
    }//스크롤뷰 터치 시에 endEditing 발생
  
    
    
//MARK: - ButtonMethod
    @objc private func dateButtonPreesed(_ sender : UIButton) {
        
        if sender.tag == 0 {
            sender.backgroundColor = .systemBlue
            endButton.backgroundColor = .white
            setDatePicker(tag: 0)
        }else{
            sender.backgroundColor = .systemBlue
            startButton.backgroundColor = .white
            setDatePicker(tag: 1)
        }
    }

    
    private func setDatePicker(tag : Int) {
        guard let selectedDate = UserDefaults.standard.string(forKey: "selectedDate") else {return}
    
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        let currentDate = dateFormatter.date(from: selectedDate)
        
        if tag == 0 {
            setDateView.addSubview(datePicker)
            datePicker.locale = Locale(identifier: "ko-KR")
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .inline
            datePicker.tag = tag
            datePicker.date = currentDate ?? Date()
            datePicker.addTarget(self, action: #selector(dateChange(_:)), for: .valueChanged)
            datePicker.snp.makeConstraints { make in
                make.top.equalTo(endButton.snp_bottomMargin).offset(20)
                make.left.right.equalToSuperview().inset(20)
                make.height.equalTo(300)
            }
            
        }else {
            setDateView.addSubview(datePicker)
            datePicker.locale = Locale(identifier: "ko-KR")
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .inline
            datePicker.tag = tag
            datePicker.date = currentDate ?? Date()
            datePicker.minimumDate = currentDate
            datePicker.addTarget(self, action: #selector(dateChange(_:)), for: .valueChanged)
            datePicker.snp.makeConstraints { make in
                make.top.equalTo(endButton.snp_bottomMargin).offset(20)
                make.left.right.equalToSuperview().inset(20)
                make.height.equalTo(300)
            }
        }
        
    }
    
    @objc private func dateChange(_ sender : UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        let buttonTitle = dateFormatter.string(from: sender.date)
        
        if sender.tag == 0 { //종료일이 시작일 이전 날짜로 지정할 수 없도록
            startButton.setTitle("시작: \(buttonTitle)", for: .normal)
            endButton.setTitle("종료: \(buttonTitle)", for: .normal)
            UserDefaults.standard.set(buttonTitle, forKey: "selectedDate")
            
        }else {
            endButton.setTitle("종료: \(buttonTitle)", for: .normal)
        }
        
    }
    
    @objc private func colorButtonPressed(_ sender : UIButton) {
        
        present(ChooseColorViewController(), animated: true)
    }
    
    @objc private func memoButtonPressed(_ sender : UIButton) {
        
        present(WritingMemoViewController(), animated: true)
    }
    
    
    
    
//MARK: - ButtonMethod
    
    @objc private func dismissButtonPressed(_ sender : UIButton) {
        self.dismiss(animated: true)
        
    }

}

//MARK: - Extension
extension WritingScheduleViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
}
