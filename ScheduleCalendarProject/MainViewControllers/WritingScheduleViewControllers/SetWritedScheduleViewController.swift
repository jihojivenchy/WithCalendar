//
//  WritingScheduleViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/11/02.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore
import UIColor_Hex_Swift

final class SetWritedScheduleViewController: UIViewController {
//MARK: - Properties
    private let db = Firestore.firestore()
    
    private let dismissButton = UIButton()
    private let saveDataButton = UIButton()
       
    
    private let scrollView = UIScrollView()
    
    private let titleTextField = UITextField()
    
    private let memoButton = UIButton()
    private let memoTextView = UITextView()
    private let chooseColorButton = UIButton()
    
    private let setDateLabel = UILabel()
    private let setDateView = UIView()
    
    private let startButton = UIButton()
    private let endButton = UIButton()
    
    private let datePicker = UIDatePicker()
    
    private let dateFormatter = DateFormatter()
    
    private lazy var indicatorView : UIActivityIndicatorView = {
       let ia = UIActivityIndicatorView()
        ia.hidesWhenStopped = true
        ia.style = .large
        
        return ia
    }()
    
    private let calendar = Calendar.current
    
    var sendedText = String()

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
        saveDataButton.setBackgroundImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        saveDataButton.tintColor = .darkGray
        saveDataButton.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
        saveDataButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.right.equalTo(view).inset(10)
            make.width.height.equalTo(30)
        }
        
        view.addSubview(scrollView)
        scrollView.backgroundColor = .customGray
        scrollView.delegate = self
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
        chooseColorButton.backgroundColor = .customLightPuple
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
        startButton.setTitle(savedDate, for: .normal)
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
        endButton.setTitle(savedDate, for: .normal)
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
        
        scrollView.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view)
            make.width.height.equalTo(70)
        }
        
    }
    
    private func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: setDateView.frame.width, height: borderWidth)
        setDateView.addSubview(border)
    } //view의 border를 위쪽에만 그리기.
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }//뷰 터치 시 endEditing 발생
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.view.endEditing(true) // todo...
        }
        sender.cancelsTouchesInView = false
    }//스크롤뷰 터치 시에 endEditing 발생
    
    private func remakeLayout() {
        scrollView.addSubview(memoTextView)
        memoTextView.text = self.sendedText
        memoTextView.textColor = .black
        memoTextView.backgroundColor = .white
        memoTextView.returnKeyType = .next
        memoTextView.font = .systemFont(ofSize: 20)
        memoTextView.clipsToBounds = true
        memoTextView.layer.cornerRadius = 10
        memoTextView.layer.borderWidth = 1
        memoTextView.layer.borderColor = UIColor.darkGray.cgColor
        memoTextView.isEditable = false
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(memoButton.snp_bottomMargin).offset(30)
            make.left.equalTo(view).inset(20)
            make.right.equalTo(view).inset(20)
            make.height.equalTo(150)
        }
        
        setDateLabel.snp.remakeConstraints { make in
            make.top.equalTo(memoTextView.snp_bottomMargin).offset(40)
            make.left.equalToSuperview().inset(20)
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
    } //memo text가 있을 때 메모 텍스트뷰를 추가해주기
    
    
//MARK: - DatePickerMethod
    @objc private func dateButtonPreesed(_ sender : UIButton) {
        self.view.endEditing(true)
        
        if sender.tag == 0 {
            sender.backgroundColor = .systemBlue
            sender.setTitleColor(.white, for: .normal)
            endButton.backgroundColor = .white
            endButton.setTitleColor(.darkGray, for: .normal)
            
            setDatePicker(tag: 0)
        }else{
            sender.backgroundColor = .systemBlue
            sender.setTitleColor(.white, for: .normal)
            startButton.backgroundColor = .white
            startButton.setTitleColor(.darkGray, for: .normal)
            
            setDatePicker(tag: 1)
        }
    }

    private func setDatePicker(tag : Int) {
        guard let selectedDate = UserDefaults.standard.string(forKey: "selectedDate") else {return}
        
        self.dateFormatter.locale = Locale(identifier: "ko-KR")
        self.dateFormatter.dateFormat = "yyyy년 MM월 d일"
        guard let currentDate = self.dateFormatter.date(from: selectedDate) else{return}
        
        if tag == 0 {
            setDateView.addSubview(datePicker)
            datePicker.locale = Locale(identifier: "ko-KR")
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .inline
            datePicker.tag = tag
            datePicker.date = currentDate
            datePicker.minimumDate = .none
            datePicker.maximumDate = .none
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
            datePicker.date = currentDate
            datePicker.minimumDate = currentDate
            datePicker.maximumDate = Calendar.autoupdatingCurrent.date(byAdding: self.calculateMaximumDate(currentDate: currentDate), to: currentDate)
            datePicker.addTarget(self, action: #selector(dateChange(_:)), for: .valueChanged)
            datePicker.snp.makeConstraints { make in
                make.top.equalTo(endButton.snp_bottomMargin).offset(20)
                make.left.right.equalToSuperview().inset(20)
                make.height.equalTo(300)
            }
        }
    }
    
    @objc private func dateChange(_ sender : UIDatePicker) {
        self.dateFormatter.dateFormat = "yyyy년 MM월 d일"
        let buttonTitle = self.dateFormatter.string(from: sender.date)
        
        self.dateFormatter.dateFormat = "yyyy년 MM월"
        UserDefaults.standard.set(self.dateFormatter.string(from: sender.date), forKey: "queryDate")
        
        if sender.tag == 0 { //종료일이 시작일 이전 날짜로 지정할 수 없도록
            startButton.setTitle(buttonTitle, for: .normal)
            UserDefaults.standard.set(buttonTitle, forKey: "selectedDate")
            
        }else {
            endButton.setTitle(buttonTitle, for: .normal)
            
        }
        
    }
    
    private func calculateMaximumDate(currentDate : Date) -> DateComponents{
        var components = DateComponents()
        
        self.dateFormatter.dateFormat = "d"
        
        let lastDay = self.calendar.range(of: .day, in: .month, for: currentDate)?.count ?? Int()
        let selectedDay = self.dateFormatter.string(from: currentDate)
        
        components.day = lastDay - (Int(selectedDay) ?? Int())
        
        return components
    }
    
    
    
//MARK: - ButtonMethod
    
    @objc private func colorButtonPressed(_ sender : UIButton) {
        guard let color = self.chooseColorButton.backgroundColor?.hexString() else{return}
        
        let vc = ChooseColorViewController()
        vc.dataDelegate = self
        vc.sendedColor = color
        
        self.present(vc, animated: true)
    }
    
    @objc private func memoButtonPressed(_ sender : UIButton) {
        let vc = WritingMemoViewController()
        vc.delegate = self
        vc.sendedText = self.sendedText
        
        present(vc, animated: true)
    }
    
    @objc private func dismissButtonPressed(_ sender : UIButton) {
        self.dismiss(animated: true)
        
    }
    
    
    
    
//MARK: - DataMethod
    @objc private func saveButtonPressed(_ sender : UIButton) {
        
        guard let queryDate = UserDefaults.standard.string(forKey: "queryDate") else{return} //쿼리용 날짜
        guard let calendarTitle = UserDefaults.standard.string(forKey: "currentCalendar") else{return}
        guard let startDate = self.startButton.title(for: .normal) else{return}
        guard let endDate = self.endButton.title(for: .normal) else{return}
        guard let titleText = self.titleTextField.text else {return}
        guard let selectedColor = self.chooseColorButton.backgroundColor?.hexString() else{return}
    
        self.indicatorView.startAnimating()
        
        if titleText != "" { //빈 제목은 저장 불가
            
            self.setData(queryDate: queryDate, calendarTitle: calendarTitle, startDate: startDate, endDate: endDate, text: titleText, color: selectedColor, memo: self.sendedText)
        }else{
            
            self.nilTextAlert()
            self.indicatorView.stopAnimating()
        }
        
    }
    
    private func setData(queryDate : String, calendarTitle : String, startDate : String, endDate : String, text : String, color : String, memo : String) {
        guard let user = Auth.auth().currentUser else{return}
        
        if startDate == endDate { //일정 기간이 하루일 때
            db.collection(user.uid).document(calendarTitle).collection("달력내용").addDocument(data:
                                                                   ["originalDate" : startDate,
                                                                    "startDate" : startDate,
                                                                    "endDate"   : endDate,
                                                                    "queryDate" : queryDate,
                                                                    "titleText" : text,
                                                                    "selectedColor" : color,
                                                                    "labelColor" : color,
                                                                    "writedMemo" : memo,
                                                                    "backGrondColor" : "#00000000",
                                                                    "checkRange" : "short",
                                                                    "date" : Date().timeIntervalSince1970])
            
            self.indicatorView.stopAnimating()
            self.dismiss(animated: true)
            
        }else{//일정 기간을 모두 저장해주어야 한다. 라벨의 색은 clear
            
            self.dateFormatter.dateFormat = "yyyy년 MM월 d일"
            guard let d1 = dateFormatter.date(from: startDate) else{return}
            guard let d2 = dateFormatter.date(from: endDate) else{return}
            
            self.dateFormatter.dateFormat = "d"
            
            guard let start = Int(dateFormatter.string(from: d1)) else{return}
            guard let end = Int(dateFormatter.string(from: d2)) else{return}
            
            let count = end - start
            
            db.collection(user.uid).document(calendarTitle).collection("달력내용").addDocument(data:
                                                                                ["originalDate" : startDate,
                                                                                 "startDate" : startDate,
                                                                                 "endDate" : endDate,
                                                                                 "queryDate" : queryDate,
                                                                                 "titleText" : text,
                                                                                 "selectedColor" : color,
                                                                                 "backGrondColor" : color,
                                                                                 "labelColor" : "#00000000",
                                                                                 "writedMemo" : memo,
                                                                                 "checkRange" : "long",
                                                                                 "count" : count,
                                                                                "date" : Date().timeIntervalSince1970])

            
            self.indicatorView.stopAnimating()
            self.dismiss(animated: true)
        }
        
    }
    
    private func nilTextAlert() {
        let alert = UIAlertController(title: "제목 확인", message: "일정 제목을 적어주세요.", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "확인", style: .default)
        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - Extension
extension SetWritedScheduleViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
}

extension SetWritedScheduleViewController : sendSelectedDataDelegate {
    
    func sendData(data: String) {
        self.chooseColorButton.backgroundColor = UIColor(data)
    }
}

extension SetWritedScheduleViewController : WritingMemoDelegate {
    func sendText(text: String) {
        self.sendedText = text
        
        if sendedText == "" {//원상복귀
            memoTextView.snp.removeConstraints()
            
            setDateLabel.snp.remakeConstraints { make in
                make.top.equalTo(memoButton.snp_bottomMargin).offset(40)
                make.left.equalToSuperview().inset(20)
                make.width.equalTo(150)
                make.height.equalTo(30)
            }
        }else{
            remakeLayout()
        }
        
    }
}

extension SetWritedScheduleViewController : UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

