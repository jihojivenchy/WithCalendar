//
//  TestViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/12/13.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore
import UIColor_Hex_Swift
import UserNotifications

class SetCalendarMemoViewController: UIViewController {
    //MARK: - Properties
    private let db = Firestore.firestore()
    
    private let dismissButton = UIButton()
    private let saveDataButton = UIButton()
    
    private let titleTextField = UITextField()
    private let writeScehduleTableView = UITableView(frame: .zero, style: .grouped)
    
    private let cellTitleImageArray : [String] = ["clock", "clock","pencil.tip", "pencil"]
    private let cellTitleNameArray : [String] = ["시작", "종료", "컬러", "메모"]
    private var cellSubTitleArray : [String] = []
    
    var sendedDate = String() //데이트 피커 뷰에 전달할 날짜정보
    var controlIndex = 0
    
    private let dateFormatter = DateFormatter()
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrayAndDateInitialization()
        addSubViews()
        
        writeScehduleTableView.delegate = self
        writeScehduleTableView.dataSource = self
        writeScehduleTableView.register(SetWritedScheduleTableViewCell.self, forCellReuseIdentifier: SetWritedScheduleTableViewCell.cellIdentifier)
        writeScehduleTableView.register(DateModeControlTableViewCell.self, forCellReuseIdentifier: DateModeControlTableViewCell.cellIdentifier)
        writeScehduleTableView.rowHeight = 70
    }
    
    
    //MARK: - ViewMethod
    private func addSubViews() {
        
        view.backgroundColor = .displayModeColor5
        
        view.addSubview(dismissButton)
        dismissButton.setBackgroundImage(UIImage(systemName: "x.circle"), for: .normal)
        dismissButton.tintColor = .customLightPuple
        dismissButton.addTarget(self, action: #selector(dismissButtonPressed(_:)), for: .touchUpInside)
        dismissButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.left.equalTo(view).inset(10)
            make.width.height.equalTo(30)
        }
        
        view.addSubview(saveDataButton)
        saveDataButton.setBackgroundImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        saveDataButton.tintColor = .customLightPuple
        saveDataButton.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
        saveDataButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.right.equalTo(view).inset(10)
            make.width.height.equalTo(30)
        }
        
        view.addSubview(titleTextField)
        titleTextField.placeholder = "제목을 입력하세요."
        titleTextField.delegate = self
        titleTextField.textColor = .displayModeColor2
        titleTextField.tintColor = .displayModeColor2
        titleTextField.backgroundColor = .clear
        titleTextField.font = .systemFont(ofSize: 25)
        titleTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0))
        titleTextField.leftViewMode = .always
        titleTextField.clearButtonMode = .always
        titleTextField.layer.cornerRadius = 10
        titleTextField.clipsToBounds = true
        titleTextField.layer.borderColor = UIColor.customLightPuple?.cgColor
        titleTextField.layer.borderWidth = 1
        titleTextField.becomeFirstResponder()
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(saveDataButton.snp_bottomMargin).offset(40)
            make.right.left.equalTo(view).inset(20)
            make.height.equalTo(50)
        }
        
        view.addSubview(writeScehduleTableView)
        writeScehduleTableView.backgroundColor = .clear
        writeScehduleTableView.showsVerticalScrollIndicator = false
        writeScehduleTableView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp_bottomMargin).offset(10)
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func arrayAndDateInitialization() {
        guard let savedDate = UserDefaults.standard.string(forKey: "selectedDate") else{return}
        
        self.cellSubTitleArray = ["\(savedDate)", "\(savedDate)", "", ""]
    }//초기화
    
    private func twiceDismiss(){
        guard let pvc = self.presentingViewController else{return}
        pvc.presentingViewController?.dismiss(animated: true)
    }
    
    
    private func colorCellPressed(){
        guard let color = self.dismissButton.tintColor?.hexString() else{return}
        
        let vc = ChooseColorViewController()
        vc.colorDelegate = self
        vc.sendedColor = color
        
        self.present(vc, animated: true)
    }
    
    private func memoCellPressed() {
        
        let vc = WritingMemoViewController()
        vc.delegate = self
        vc.sendedText = self.cellSubTitleArray[3]
        
        present(vc, animated: true)
    }
    
    private func dateCellPressed(indexNumber : Int) {
        
        if indexNumber == 0{ //startDate 변경하기
            self.sendedDate = self.cellSubTitleArray[0]
            
        }else{ //endDate 변경하기
            self.sendedDate = self.cellSubTitleArray[1]
            
        }
        
        let vc = SetDatePickerViewController()
        
        vc.delegate = self
        vc.sendedDate = self.sendedDate
        vc.minimumDate = self.cellSubTitleArray[0]
        vc.indexNumber = indexNumber
        vc.controlIndex = self.controlIndex
        
        present(vc, animated: true)
    }
    
    private func nilTextAlert() {
        let alert = UIAlertController(title: "오류", message: "양식에 맞게 작성해주세요.", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "확인", style: .default)
        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - ButtonMethod
    @objc private func dismissButtonPressed(_ sender : UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc private func saveButtonPressed(_ sender : UIButton) {
        guard let queryDate = UserDefaults.standard.string(forKey: "queryDate") else{return} //쿼리용 날짜
        guard let calendarTitle = UserDefaults.standard.string(forKey: "currentCalendar") else{return}
        guard let titleText = self.titleTextField.text else {return}
        guard let selectedColor = self.dismissButton.tintColor?.hexString() else{return}
        let startDate = self.cellSubTitleArray[0]
        let endDate = self.cellSubTitleArray[1]
        
        
        if titleText == "", startDate == "", endDate == ""{
            nilTextAlert()
        }else{
            setData(queryDate: queryDate, calendarTitle: calendarTitle, startDate: self.cellSubTitleArray[0], endDate: self.cellSubTitleArray[1], text: titleText, color: selectedColor, memo: self.cellSubTitleArray[3], controlIndex: self.controlIndex)
        }
        
        
        
    }
    
    //MARK: - DataMethod
    private func setData(queryDate : String, calendarTitle : String, startDate : String, endDate : String, text : String, color : String, memo : String, controlIndex : Int) {
        guard let user = Auth.auth().currentUser else{return}
        
        let count = calculateDayDifference(startDay: startDate, endDay: endDate, controlIndex: controlIndex) //당일 일정인지, 기간일정인지 계산
        
        if count == 0 { //당일 일정일 때 배경 색은 clear
            db.collection(user.uid).document(calendarTitle).collection("달력내용").addDocument(data:
                                                                                            ["startDate" : startDate,
                                                                                             "endDate"   : endDate,
                                                                                             "queryDate" : queryDate,
                                                                                             "titleText" : text,
                                                                                             "selectedColor" : color,
                                                                                             "labelColor" : color,
                                                                                             "detailMemo" : memo,
                                                                                             "backGrondColor" : "#00000000",
                                                                                             "count" : count,
                                                                                             "controlIndex" : controlIndex])
            
            self.twiceDismiss()
            self.setNotification(calendatName: calendarTitle, startDate: startDate, endDate: endDate, titleMemo: text, controlIndex: controlIndex)
            
        }else{//기간일정일 때 라벨의 색은 clear
            db.collection(user.uid).document(calendarTitle).collection("달력내용").addDocument(data:
                                                                                            ["startDate" : startDate,
                                                                                             "endDate" : endDate,
                                                                                             "queryDate" : queryDate,
                                                                                             "titleText" : text,
                                                                                             "selectedColor" : color,
                                                                                             "backGrondColor" : color,
                                                                                             "labelColor" : "#00000000",
                                                                                             "detailMemo" : memo,
                                                                                             "count" : count,
                                                                                             "controlIndex" : controlIndex])
            
            
            self.twiceDismiss()
            self.setNotification(calendatName: calendarTitle, startDate: startDate, endDate: endDate, titleMemo: text, controlIndex: controlIndex)
        }
    }
    
    private func calculateDayDifference(startDay : String, endDay : String, controlIndex : Int) -> Int {
        
        if controlIndex == 0 { //하루종일 모드인지 시간설정 모드인지 확인
            self.dateFormatter.dateFormat = "yyyy년 MM월 d일"
        }else{
            self.dateFormatter.dateFormat = "yyyy년 MM월 d일 HH시 mm분"
        }
        
        
        let d1 = dateFormatter.date(from: startDay) ?? Date()
        let d2 = dateFormatter.date(from: endDay) ?? Date()
        
        self.dateFormatter.dateFormat = "d"
        
        let start = Int(dateFormatter.string(from: d1)) ?? Int()
        let end = Int(dateFormatter.string(from: d2)) ?? Int()
        
        let count = end - start
        
        return count
    }
    
}

//MARK: - Extension
extension SetCalendarMemoViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: DateModeControlTableViewCell.cellIdentifier, for: indexPath) as! DateModeControlTableViewCell
            
            cell.delegate = self
            cell.control.selectedSegmentTintColor = self.dismissButton.tintColor
            cell.control.selectedSegmentIndex = self.controlIndex
            cell.backgroundColor = .clear
            cell.contentView.isUserInteractionEnabled = false
            cell.selectionStyle = .none
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: SetWritedScheduleTableViewCell.cellIdentifier, for: indexPath) as! SetWritedScheduleTableViewCell
            
            cell.titleImageView.image = UIImage(systemName: self.cellTitleImageArray[indexPath.row - 1])
            cell.titleLabel.text = self.cellTitleNameArray[indexPath.row - 1]
            cell.subTitleLabel.text = self.cellSubTitleArray[indexPath.row - 1]
            
            cell.titleImageView.tintColor = self.dismissButton.tintColor
            cell.titleLabel.textColor = self.dismissButton.tintColor
            cell.subTitleLabel.textColor = self.dismissButton.tintColor
            
            cell.accessoryType = .disclosureIndicator
            cell.tintColor = .white
            cell.backgroundColor = .clear
            cell.contentView.isUserInteractionEnabled = true
            cell.selectionStyle = .default
            
            return cell
        }
    }
    
}

extension SetCalendarMemoViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.view.endEditing(true)
        
        if indexPath.row == 1{        //시작
            self.dateCellPressed(indexNumber: 0)
            
        }else if indexPath.row == 2{  //종료
            self.dateCellPressed(indexNumber: 1)
            
        }else if indexPath.row == 3{  //컬러
            self.colorCellPressed()
            
        }else if indexPath.row == 4{  //메모
            self.memoCellPressed()
        }
    }
}

extension SetCalendarMemoViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
}

extension SetCalendarMemoViewController : UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

extension SetCalendarMemoViewController : ChooseColorDelegate {
    func sendColor(hexColor: String) {
        self.dismissButton.tintColor = UIColor(hexColor)
        self.saveDataButton.tintColor = UIColor(hexColor)
        self.titleTextField.layer.borderColor = UIColor(hexColor).cgColor
        
        self.writeScehduleTableView.reloadData()
    }
}

extension SetCalendarMemoViewController : WritingMemoDelegate {
    func sendText(text: String) {
        self.cellSubTitleArray[3] = text
        
        self.writeScehduleTableView.reloadData()
    }
}

extension SetCalendarMemoViewController : SetDatePickerDelegate {
    func sendData(date: String, index : Int) {
        if index == 0 {
            self.cellSubTitleArray[0] = date
            self.cellSubTitleArray[1] = date
            
            self.writeScehduleTableView.reloadData()
        }else{
            self.cellSubTitleArray[1] = date
            
            self.writeScehduleTableView.reloadData()
        }
    }
}

extension SetCalendarMemoViewController : DateModeControlDelegate {
    func sendDateMode(index: Int) {
        self.controlIndex = index
        let start = self.cellSubTitleArray[0]
        let end = self.cellSubTitleArray[1]
        
        if index == 0 {
            self.dateFormatter.dateFormat = "yyyy년 MM월 d일 HH시 mm분"
            
            guard let formattedStartDate = dateFormatter.date(from: start) else{return}
            guard let formattedEndDate = dateFormatter.date(from: end) else{return}
            
            self.dateFormatter.dateFormat = "yyyy년 MM월 d일"
            
            cellSubTitleArray[0] = dateFormatter.string(from: formattedStartDate)
            cellSubTitleArray[1] = dateFormatter.string(from: formattedEndDate)
            
            self.writeScehduleTableView.reloadData()
        }else{
            self.dateFormatter.dateFormat = "yyyy년 MM월 d일"
            
            guard let formattedStartDate = dateFormatter.date(from: start) else{return}
            guard let formattedEndDate = dateFormatter.date(from: end) else{return}
            
            self.dateFormatter.dateFormat = "yyyy년 MM월 d일 HH시 mm분"
            
            cellSubTitleArray[0] = dateFormatter.string(from: formattedStartDate)
            cellSubTitleArray[1] = dateFormatter.string(from: formattedEndDate)
            
            self.writeScehduleTableView.reloadData()
        }
    }
}

extension SetCalendarMemoViewController {
    
    private func setNotification(calendatName : String, startDate: String, endDate : String, titleMemo : String, controlIndex : Int) {
        var component = DateComponents()
        var date = Date()
        
        if controlIndex == 0 {
            dateFormatter.dateFormat = "yyyy년 MM월 d일"
            date = dateFormatter.date(from: startDate) ?? Date()
            component = Calendar.current.dateComponents([.year, .month, .day], from: date)
            
        }else{
            dateFormatter.dateFormat = "yyyy년 MM월 d일 HH시 mm분"
            date = dateFormatter.date(from: startDate) ?? Date()
            component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        }
        
        let notificationCenter = UNUserNotificationCenter.current()
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.title = calendatName
        notificationContent.subtitle = "\(startDate) ~ \(endDate)"
        notificationContent.body = titleMemo
        notificationContent.badge = 1
        
        
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
        
        let request = UNNotificationRequest(identifier: titleMemo, content: notificationContent, trigger: notificationTrigger)
        
        notificationCenter.add(request) { error in
            if let e = error {
                print("Error send message \(e)")
            }else{
                print("sccess")
            }
        }
    }
}
