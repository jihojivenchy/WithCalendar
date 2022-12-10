//
//  ModifyScheduleViewController2.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/12/08.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore
import UIColor_Hex_Swift

class ModifyScheduleViewController: UIViewController {
    //MARK: - Properties
    private let db = Firestore.firestore()
    
    private let dismissButton = UIButton()
    private let saveDataButton = UIButton()
    private let deleteButton = UIButton()
    
    private let titleTextField = UITextField()
    private let modifyScehduleTableView = UITableView(frame: .zero, style: .grouped)
    
    private let cellTitleImageArray : [String] = ["clock", "clock","pencil.tip", "pencil"]
    private let cellTitleNameArray : [String] = ["시작", "종료", "컬러", "메모"]
    private var cellSubTitleArray : [String] = []
    
    var sendedDate = String() //데이트 피커 뷰에 전달할 날짜정보
    
    var calendarMemoData : CalendarMemoData?   //수정할 데이터 표시
    private var documentID = String()          //수정할 데이터의 도큐먼트 아이디 저장
    
    private let dateFormatter = DateFormatter()
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        setSendedData()
        
        modifyScehduleTableView.delegate = self
        modifyScehduleTableView.dataSource = self
        modifyScehduleTableView.register(SetWritedScheduleTableViewCell.self, forCellReuseIdentifier: SetWritedScheduleTableViewCell.cellIdentifier)
        modifyScehduleTableView.rowHeight = 70
    }
    
    
    //MARK: - ViewMethod
    private func addSubViews() {
        
        view.backgroundColor = .displayModeColor5
    
        view.addSubview(dismissButton)
        dismissButton.setBackgroundImage(UIImage(systemName: "x.circle"), for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissButtonPressed(_:)), for: .touchUpInside)
        dismissButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.left.equalTo(view).inset(10)
            make.width.height.equalTo(30)
        }
        
        view.addSubview(saveDataButton)
        saveDataButton.setBackgroundImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        saveDataButton.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
        saveDataButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.right.equalTo(view).inset(10)
            make.width.height.equalTo(30)
        }
        
        view.addSubview(deleteButton)
        deleteButton.setBackgroundImage(UIImage(systemName: "trash.circle"), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed(_:)), for: .touchUpInside)
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.right.equalTo(saveDataButton.snp_leftMargin).offset(-20)
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
        titleTextField.layer.borderWidth = 1
        titleTextField.becomeFirstResponder()
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(saveDataButton.snp_bottomMargin).offset(40)
            make.right.left.equalTo(view).inset(20)
            make.height.equalTo(50)
        }
        
        view.addSubview(modifyScehduleTableView)
        modifyScehduleTableView.backgroundColor = .clear
        modifyScehduleTableView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp_bottomMargin).offset(10)
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setSendedData(){
        guard let safeCalendarMemoData = self.calendarMemoData else{return}
        
        self.documentID = safeCalendarMemoData.documentID
        self.titleTextField.text = safeCalendarMemoData.titleMemo
        self.dismissButton.tintColor = UIColor(safeCalendarMemoData.selectedColor)
        self.deleteButton.tintColor = UIColor(safeCalendarMemoData.selectedColor)
        self.saveDataButton.tintColor = UIColor(safeCalendarMemoData.selectedColor)
        self.titleTextField.layer.borderColor = UIColor(safeCalendarMemoData.selectedColor).cgColor
        
        self.cellSubTitleArray = [safeCalendarMemoData.startDate, safeCalendarMemoData.endDate, "", safeCalendarMemoData.detailMemo]
    }//가져온 데이터들 자리에 배치
    
    private func colorCellPressed() {
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
        if indexNumber == 0{
            self.sendedDate = self.cellSubTitleArray[0]
        }else{
            self.sendedDate = self.cellSubTitleArray[1]
        }
        
        let vc = SetDatePickerViewController()
        vc.delegate = self
        vc.sendedDate = self.sendedDate
        vc.indexNumber = indexNumber
        
        present(vc, animated: true)
    }
    
    private func nilTextAlert() {
        let alert = UIAlertController(title: "오류", message: "일정 제목을 적어주세요.", preferredStyle: .alert)
        
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
        
        if titleText == "" {
            nilTextAlert()
        }else{
            setData(queryDate: queryDate, calendarTitle: calendarTitle, startDate: self.cellSubTitleArray[0], endDate: self.cellSubTitleArray[1], text: titleText, color: selectedColor, memo: self.cellSubTitleArray[3])
        }
    }
    
    @objc private func deleteButtonPressed(_ sender : UIButton) {
        let alert = UIAlertController(title: "삭제", message: "정말 삭제하시겠습니까?", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "확인", style: .default) { action in
            self.deleteMemoData()
            self.dismiss(animated: true)
        }
        alertAction.setValue(UIColor.displayModeColor2, forKey: "titleTextColor")
        
        let cancleAction = UIAlertAction(title: "취소", style: .cancel)
        cancleAction.setValue(UIColor.displayModeColor2, forKey: "titleTextColor")
        
        alert.addAction(alertAction)
        alert.addAction(cancleAction)
        
        present(alert, animated: true, completion: nil)
    }
    
//MARK: - DataMethod
    private func deleteMemoData() {
        guard let user = Auth.auth().currentUser else{return}
        guard let calendarTitle = UserDefaults.standard.string(forKey: "currentCalendar") else{return}

        self.db.collection(user.uid).document(calendarTitle).collection("달력내용").document(self.documentID).delete()
    }
    
    private func setData(queryDate : String, calendarTitle : String, startDate : String, endDate : String, text : String, color : String, memo : String) {
        guard let user = Auth.auth().currentUser else{return}
        
        if startDate == endDate { //일정 기간이 하루일 때
            db.collection(user.uid).document(calendarTitle).collection("달력내용").document(documentID).setData([                                                                                   "startDate" : startDate,
                                                                                    "endDate"   : endDate,
                                                                                    "queryDate" : queryDate,
                                                                                    "titleText" : text,
                                                                                    "selectedColor" : color,
                                                                                    "labelColor" : color,
                                                                                    "detailMemo" : memo,
                                                                                    "backGrondColor" : "#00000000",
                                                                                    "count" : 0,
                                                                                    "date" : Date().timeIntervalSince1970])
            
            self.dismiss(animated: true)
            
        }else{//일정 기간을 모두 저장해주어야 한다. 라벨의 색은 clear
            
            self.dateFormatter.dateFormat = "yyyy년 MM월 d일 HH시 mm분"
            guard let d1 = dateFormatter.date(from: startDate) else{return}
            guard let d2 = dateFormatter.date(from: endDate) else{return}
            
            self.dateFormatter.dateFormat = "d"
            
            guard let start = Int(dateFormatter.string(from: d1)) else{return}
            guard let end = Int(dateFormatter.string(from: d2)) else{return}
            
            let count = end - start
            print(count)
            db.collection(user.uid).document(calendarTitle).collection("달력내용").document(documentID).setData([
                                                                               "startDate" : startDate,
                                                                               "endDate" : endDate,
                                                                               "queryDate" : queryDate,
                                                                               "titleText" : text,
                                                                               "selectedColor" : color,
                                                                               "backGrondColor" : color,
                                                                               "labelColor" : "#00000000",
                                                                               "detailMemo" : memo,
                                                                               "count" : count,
                                                                               "date" : Date().timeIntervalSince1970])
            
            self.dismiss(animated: true)
        }
    }
    
    
    
}

//MARK: - Extension
extension ModifyScheduleViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellTitleNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SetWritedScheduleTableViewCell.cellIdentifier, for: indexPath) as! SetWritedScheduleTableViewCell
        
        cell.titleImageView.image = UIImage(systemName: self.cellTitleImageArray[indexPath.row])
        cell.titleLabel.text = self.cellTitleNameArray[indexPath.row]
        cell.subTitleLabel.text = self.cellSubTitleArray[indexPath.row]
        
        cell.titleImageView.tintColor = self.dismissButton.tintColor
        cell.titleLabel.textColor = self.dismissButton.tintColor
        cell.subTitleLabel.textColor = self.dismissButton.tintColor
        cell.tintColor = self.dismissButton.tintColor
        
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .clear
        
        return cell
    }
    
}

extension ModifyScheduleViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0{
            self.dateCellPressed(indexNumber: 0)
        }else if indexPath.row == 1{
            self.dateCellPressed(indexNumber: 1)
        }else if indexPath.row == 2{
            self.colorCellPressed()
        }else{
            self.memoCellPressed()
        }
    }
}

extension ModifyScheduleViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
}

extension ModifyScheduleViewController : UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

extension ModifyScheduleViewController : ChooseColorDelegate {
    func sendColor(hexColor: String) {
        self.dismissButton.tintColor = UIColor(hexColor)
        self.saveDataButton.tintColor = UIColor(hexColor)
        self.deleteButton.tintColor = UIColor(hexColor)
        self.titleTextField.layer.borderColor = UIColor(hexColor).cgColor
        
        self.modifyScehduleTableView.reloadData()
    }
}

extension ModifyScheduleViewController : WritingMemoDelegate {
    func sendText(text: String) {
        self.cellSubTitleArray[3] = text
        self.modifyScehduleTableView.reloadData()
    }
}

extension ModifyScheduleViewController : SetDatePickerDelegate {
    func sendData(date: String, index : Int) {
        if index == 0 {
            self.cellSubTitleArray[0] = date
            self.cellSubTitleArray[1] = date
            
            self.modifyScehduleTableView.reloadData()
        }else{
            self.cellSubTitleArray[1] = date
            
            self.modifyScehduleTableView.reloadData()
        }
    }
}
