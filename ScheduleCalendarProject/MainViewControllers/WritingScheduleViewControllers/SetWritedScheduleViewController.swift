//
//  WritingSceduleViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/12/07.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore
import UIColor_Hex_Swift

class SetWritedScheduleViewController: UIViewController {
//MARK: - Properties
    private let db = Firestore.firestore()
    
    private let dismissButton = UIButton()
    private let saveDataButton = UIButton()
    
    private let titleTextField = UITextField()
    private let writeScehduleTableView = UITableView(frame: .zero, style: .grouped)
    
    private let cellTitleImageArray : [String] = ["clock", "clock","pencil.tip", "pencil"]
    private let cellTitleNameArray : [String] = ["시작", "종료", "컬러", "메모"]
    private var cellSubTitleArray : [String] = []
    
    var sendedText = String() //메모뷰에 전달할 텍스트정보
    var sendedDate = String() //데이트 피커 뷰에 전달할 날짜정보
    
    private let dateFormatter = DateFormatter()
    private var startDate = String() //subtitle을 정제해서 날짜만 저장
    private var endDate = String()  //subtitle을 정제해서 날짜만 저장
    
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
        writeScehduleTableView.rowHeight = 70
        
        UserDefaults.standard.set("", forKey: "writedMemo") //메모 초기화
    }
    
    
//MARK: - ViewMethod
    private func addSubViews() {
        
        view.backgroundColor = .displayModeColor5
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))//개체들이 모두 스크롤뷰 위에 존재하기 때문에 스크롤뷰 특성 상 touchBegan함수가 실행되지 않는다. 따라서 스크롤뷰에 대한 핸들러 캐치를 등록해주어야 한다
        
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
        writeScehduleTableView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp_bottomMargin).offset(10)
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.view.endEditing(true) // todo...
        }
        sender.cancelsTouchesInView = false
    }//스크롤뷰 터치 시에 endEditing 발생
    
    private func arrayAndDateInitialization() {
        guard let savedDate = UserDefaults.standard.string(forKey: "selectedDate") else{return}
        
        self.cellSubTitleArray = ["\(savedDate) 09시 00분", "\(savedDate) 09시 00분", "", ""]
        self.startDate = savedDate
        self.endDate = savedDate
    }//초기화
    
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
        vc.sendedText = self.sendedText
        
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
            setData(queryDate: queryDate, calendarTitle: calendarTitle, startDate: self.startDate, endDate: self.endDate, text: titleText, color: selectedColor, memo: self.sendedText)
        }
        
    
        
    }
    
//MARK: - DataMethod
    private func setData(queryDate : String, calendarTitle : String, startDate : String, endDate : String, text : String, color : String, memo : String) {
        guard let user = Auth.auth().currentUser else{return}
        
        if startDate == endDate { //일정 기간이 하루일 때
            db.collection(user.uid).document(calendarTitle).collection("달력내용").addDocument(data:
                                                                   ["startDate" : startDate,
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
            
            self.dateFormatter.dateFormat = "yyyy년 MM월 d일"
            guard let d1 = dateFormatter.date(from: startDate) else{return}
            guard let d2 = dateFormatter.date(from: endDate) else{return}
            
            self.dateFormatter.dateFormat = "d"
            
            guard let start = Int(dateFormatter.string(from: d1)) else{return}
            guard let end = Int(dateFormatter.string(from: d2)) else{return}
            
            let count = end - start
            print(count)
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
                                                                                "date" : Date().timeIntervalSince1970])

            
            self.dismiss(animated: true)
        }
    }
    
}

//MARK: - Extension
extension SetWritedScheduleViewController : UITableViewDataSource {
    
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

extension SetWritedScheduleViewController : UITableViewDelegate {
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

extension SetWritedScheduleViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
}

extension SetWritedScheduleViewController : UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

extension SetWritedScheduleViewController : ChooseColorDelegate {
    func sendColor(hexColor: String) {
        self.dismissButton.tintColor = UIColor(hexColor)
        self.saveDataButton.tintColor = UIColor(hexColor)
        self.titleTextField.layer.borderColor = UIColor(hexColor).cgColor
        
        self.writeScehduleTableView.reloadData()
    }
}

extension SetWritedScheduleViewController : WritingMemoDelegate {
    func sendText(text: String) {
        self.sendedText = text
        self.cellSubTitleArray[3] = text
        self.writeScehduleTableView.reloadData()
    }
}

extension SetWritedScheduleViewController : SetDatePickerDelegate {
    func sendData(date: String, index : Int) {
        if index == 0 {
            self.cellSubTitleArray[0] = date
            self.cellSubTitleArray[1] = date
            
            self.writeScehduleTableView.reloadData()
        }else{
            self.cellSubTitleArray[1] = date
            
            self.writeScehduleTableView.reloadData()
        }
        
        //데이터 저장 형식으로 정제 해주기
        formattedDate()
    }
    
    private func formattedDate() {
        dateFormatter.dateFormat = "yyyy년 MM월 d일 HH시 mm분"
        
        let startFormattedDate = dateFormatter.date(from: self.cellSubTitleArray[0]) ?? Date()
        let endFormattedDate = dateFormatter.date(from: self.cellSubTitleArray[1]) ?? Date()
        
        dateFormatter.dateFormat = "yyyy년 MM월 d일"
        
        self.startDate = dateFormatter.string(from: startFormattedDate)
        self.endDate = dateFormatter.string(from: endFormattedDate)
        
    }
}
