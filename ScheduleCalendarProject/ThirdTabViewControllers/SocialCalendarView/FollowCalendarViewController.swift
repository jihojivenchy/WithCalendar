//
//  FollowUserCalendarViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/12/19.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore
import UIColor_Hex_Swift

class FollowCalendarViewController: UIViewController {
    //MARK: - Properties
    private let db = Firestore.firestore()
    private var calendarMemoDataArray : [[CalendarMemoData]] = []
    
    var uid = String()
    var calendarName : String = "" {
        didSet{
            getScheduleMemoData(uid: self.uid, calendarName: calendarName)
            navigationItem.title = calendarName
        }
    }
    
    //views
    private let contentView = UIView()
    private let titleButton = UIButton()
    private let weekStackView = UIStackView()
    private let calendarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let goTodayButton = UIButton()
    
    private let calendar = Calendar.current
    private let dateFormmater = DateFormatter() //캘린더를 위한 포맷터
    private var calendarDate = Date()
    private var daysArray : [String] = []  //달력에 날짜 표시하기 위해서 날짜들 저장 ex) 첫 째날이 월요일이라면 ["", "1", "2" ...]
    private var indexDateArray : [String] = []
    
    private let sundaySet : Set<Int> = [0, 7, 14, 21, 28, 35]
    private let saturdaySet : Set<Int> = [6, 13, 20, 27, 28, 34, 41]
    private let filterSet : Set<Int> = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    private var holidaySet : Set<Int> = []
    
    private var todayIndex = ""  //오늘
    
//MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        
        
        configureCalendar()
        configureToday()
        
        calendarCollectionView.register(CustomCalendarViewCell.self, forCellWithReuseIdentifier: CustomCalendarViewCell.identifier)
        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self
    }
    
//MARK: - ViewMethod
    
    private func addSubViews() {
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(plusMonth(_:)))
        swipeRight.direction = .left
        swipeRight.delegate = self
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(minusMonth(_:)))
        swipeLeft.direction = .right
        swipeLeft.delegate = self
        
        view.backgroundColor = .displayModeColor1
        
        view.addSubview(contentView)
        contentView.backgroundColor = .displayModeColor3
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowRadius = 10
        contentView.layer.shadowOpacity = 0.5
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.left.right.equalTo(view).inset(10)
        }
        
        contentView.addSubview(titleButton)
        titleButton.setTitleColor(.displayModeColor2, for: .normal)
        titleButton.titleLabel?.font = .boldSystemFont(ofSize: 23)
        titleButton.sizeToFit()
        titleButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(goTodayButton)
        goTodayButton.isHidden = true
        goTodayButton.setTitle("Today", for: .normal)
        goTodayButton.setTitleColor(.displayModeColor2, for: .normal)
        goTodayButton.titleLabel?.font = .boldSystemFont(ofSize: 10)
        goTodayButton.addTarget(self, action: #selector(goTodayButtonPressed(_:)), for: .touchUpInside)
        goTodayButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleButton)
            make.left.equalToSuperview().inset(10)
            make.width.equalTo(40)
            make.height.equalTo(23)
        }
        
        contentView.addSubview(weekStackView)
        weekStackView.distribution = .fillEqually
        self.setWeekStackView()
        weekStackView.snp.makeConstraints { make in
            make.top.equalTo(titleButton.snp_bottomMargin).offset(25)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(30)
        }
        
        contentView.addSubview(calendarCollectionView)
        calendarCollectionView.showsVerticalScrollIndicator = false
        calendarCollectionView.addGestureRecognizer(swipeLeft)
        calendarCollectionView.addGestureRecognizer(swipeRight)
        calendarCollectionView.backgroundColor = .displayModeColor3
        calendarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(weekStackView.snp_bottomMargin).offset(15)
            make.right.left.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
        
    }
    
    private func setWeekStackView() {  //stackView에 라벨을 일정한 간격으로 두기
        let weekArray = ["일", "월", "화", "수", "목", "금", "토"]
        
        for i in 0..<7 {
            let label = UILabel()
            label.text = weekArray[i]
            label.textColor = .displayModeColor2
            label.textAlignment = .center
            label.font = .boldSystemFont(ofSize: 13)
            self.weekStackView.addArrangedSubview(label)
            
            if i == 0 {
                label.textColor = .customRed
            }else if i == 6 {
                label.textColor = .customLightPuple
            }
        }
    }
    
    private func configureToday() {
        self.dateFormmater.dateFormat = "yyyy년 MM월 dd일"
        self.todayIndex = dateFormmater.string(from: Date())
    }
    
    private func configureCalendar() { //현재 해당하는 년과 월을 저장하고, yyyy-mm 형태 저장.
        let components = self.calendar.dateComponents([.year, .month], from: Date()) //현재 날짜에서 년, 월만 뽑기
        self.calendarDate = self.calendar.date(from: components) ?? Date() //뽑아낸 정보는 dateComponents 타입이기 때문에 date메서드를 통해 date 형태로 저장
        self.dateFormmater.dateFormat = "yyyy년 MM월"
        self.updateCalendar()
    }
    
    private func startDayOfTheWeek() -> Int { //해당 날짜가 속한 달의 첫 번째 날이 무슨 요일인지 알아내기 위한 메서드.
        
        return calendar.component(.weekday, from: self.calendarDate) - 1 //-1은 배열이 0번부터 시작하는 것과 동일하게함
    }
    
    private func calculateEndDay() -> Int { //해당 날짜가 속한 month가 총 몇 day인지 알기 위한 메서드.
        return self.calendar.range(of: .day, in: .month, for: self.calendarDate)?.count ?? Int()
    }
    
    private func updateTitle() { //해당 날짜를 yyyy년 mm월 형식으로 라벨 텍스트 변경
        self.dateFormmater.dateFormat = "yyyy년 MM월"
        let date = self.dateFormmater.string(from: self.calendarDate)
        self.titleButton.setTitle(date, for: .normal)
    }
    
    private func updateDays() { //캘린더 셀에 들어갈 날짜 만들기 시작
        guard let text = self.titleButton.title(for: .normal) else{return}
        
        self.daysArray.removeAll() //다음달이나 이전달로 스크롤 할 때 days를 다시 새로 계산하니까 모두 삭제
        self.indexDateArray.removeAll()
        
        let startDayOfTheWeek = self.startDayOfTheWeek() //첫 번째 날 시작 인덱스를 저장하기 위해
        let totalDays = startDayOfTheWeek + self.calculateEndDay() //시작 인덱스와 총 날짜 개수를 더해서 저장
        
        for day in 0..<totalDays {
            
            if day < startDayOfTheWeek { //시작 인덱스까지 가지 못하면 빈칸으로 채우기.
                self.daysArray.append("")
                self.indexDateArray.append("")
                
                continue  //continue를 통해 다음 구문을 실행하지 않고, 다시 if문 시작
            }
            
            let date = day - startDayOfTheWeek + 1
            self.daysArray.append("\(date)") //시작 인덱스부터 날짜들을 배열안에 채워넣기
            
            if self.filterSet.contains(date) { //yyyy년 MM월 dd일 형식으로 저장하기 위해
                self.indexDateArray.append("\(text) 0\(day - startDayOfTheWeek + 1)일")
            }else{
                self.indexDateArray.append("\(text) \(day - startDayOfTheWeek + 1)일")
            }
            
        }
        
        self.configureEqualArray()
        self.calendarCollectionView.reloadData()
    }
    
    private func updateCalendar() {
        updateTitle()  //타이틀 변경
        updateDays()  //날짜들 변경
    }
    
    private func currentMonth() -> Bool { //보여지고 있는 달과 현재 달이 맞는지 아닌지 확인해주는 메서드.
        let components = self.calendar.dateComponents([.year, .month], from: Date())
        let date = calendar.date(from: components)
        
        if date == calendarDate{
            return true
        }else {
            return false
        }
    }
    
    private func appearTodayButton() { //현재 달로 돌아가기 위한 버튼이 생겨나게 하는 메서드
        if currentMonth() {
            self.goTodayButton.isHidden = true
        }else {
            self.goTodayButton.isHidden = false
        }
    }
    
    
//MARK: - ButtonMethod
    
    @objc func goTodayButtonPressed(_ sender : UIButton) {
        let components = self.calendar.dateComponents([.year, .month], from: Date()) //현재 날짜에서 년, 월만 뽑기
        self.calendarDate = self.calendar.date(from: components) ?? Date() //뽑아낸 정보는 dateComponents 타입이기 때문에 date메서드를 통해 date 형태로 저장
        
        self.updateCalendar()
        self.swipeAnimation()
        getScheduleMemoData(uid: self.uid, calendarName: self.calendarName)
        
        goTodayButton.isHidden = true
    }
    
    @objc func minusMonth(_ sender : UISwipeGestureRecognizer) { //이전 달로 이동
        self.calendarDate = self.calendar.date(byAdding: DateComponents(month: -1), to: self.calendarDate) ?? Date()
        updateCalendar()
        swipeAnimation()
        appearTodayButton()
        
        getScheduleMemoData(uid: self.uid, calendarName: self.calendarName)
    }
    
    @objc func plusMonth(_ sender : UISwipeGestureRecognizer) { //다음 달로 이동
        self.calendarDate = self.calendar.date(byAdding: DateComponents(month: +1), to: self.calendarDate) ?? Date()
        updateCalendar()
        swipeAnimation()
        appearTodayButton()
        
        getScheduleMemoData(uid: self.uid, calendarName: self.calendarName)
    }
    
    private func swipeAnimation() {
        UIView.transition(with: self.contentView, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
    }//달력 데이터를 변경해줄 때
    
    //MARK: - DataMethod
    
    private func configureEqualArray() {
        self.calendarMemoDataArray = [[CalendarMemoData]](repeating: [CalendarMemoData](repeating: CalendarMemoData(titleMemo: "", labelColor: "#00000000", startDate: "", endDate: "", backGroundColor: "#00000000", count: 0, selectedColor: "#00000000", documentID: "", detailMemo: "", controlIndex: 0, sequence: ""), count: 1), count: self.indexDateArray.count)
    }
    
    private func getScheduleMemoData(uid : String, calendarName : String) {
        guard let queryDate = self.titleButton.title(for: .normal) else{return}
        
        db.collection(uid).document(calendarName).collection("달력내용").whereField("queryDate", isEqualTo: queryDate).order(by: "startDate", descending: false).order(by: "count", descending: true).addSnapshotListener { querySnapShot, error in
            if let e = error {
                print("Error get memo Data : \(e)")
            }else{
                self.configureEqualArray()
                self.holidaySet = []
                
                if let snapShotDocument = querySnapShot?.documents {
                    
                    for doc in snapShotDocument{
                        let data = doc.data()
                        
                        guard let titleText = data["titleText"] as? String else{return}
                        guard let memoData = data["detailMemo"] as? String else{return}
                        
                        guard let selectedColor = data["selectedColor"] as? String else{return}
                        guard let labelColor = data["labelColor"] as? String else{return}
                        guard let backgroundColor = data["backGrondColor"] as? String else{return}
                        
                        guard let startDate = data["startDate"] as? String else{return}
                        guard let endDate = data["endDate"] as? String else{return}
                        
                        guard let count = data["count"] as? Int else{return}
                        guard let controlIndex = data["controlIndex"] as? Int else{return}
                        
                        guard let index = self.setFormattedDateIndex(targetDate: startDate, controlIndex: controlIndex) else{return}
                        
                        let findData = CalendarMemoData(titleMemo: titleText, labelColor: labelColor, startDate: startDate, endDate: endDate, backGroundColor: backgroundColor, count: count, selectedColor: selectedColor, documentID: doc.documentID, detailMemo: memoData, controlIndex: controlIndex, sequence: "")
                        
                        if count == 0 { //일정이 하루단위일 때 아래로 넣어주기
                            self.singleArrayDeployment(dateIndex: index, data: findData)
                            
                        }else{
                            self.multipleArrayDeployment(dateIndex: index, data: findData, count: count)
                        }
                        
                        if selectedColor == "#CC3636FF"{ //공휴일이면 공휴일배열에 추가
                            self.setHolidayArray(index: index)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.calendarCollectionView.reloadData()
                }
            }
        }
        
    }
    
    private func singleArrayDeployment(dateIndex : Array<String>.Index, data : CalendarMemoData) {
        let memoArray = self.calendarMemoDataArray[dateIndex]
        
        for (forIndex, i) in memoArray.enumerated() { //중간에 빈 배열이 있으면 찾아서 들어가도록
            
            if i.titleMemo == "" {
                self.calendarMemoDataArray[dateIndex][forIndex] = data
                
                break
            }else{
                if forIndex == memoArray.count - 1 { //마지막 데이터 일 때
                    
                    self.calendarMemoDataArray[dateIndex].append(data)
                }
            }
        }
    }
    
    private func multipleArrayDeployment(dateIndex : Array<String>.Index, data : CalendarMemoData, count : Int) {
        let array = [Int](repeating: 0, count: count + 1)
        let nilValue = CalendarMemoData(titleMemo: "", labelColor: "#00000000", startDate: "", endDate: "", backGroundColor: "#00000000", count: 0, selectedColor: "#00000000", documentID: "", detailMemo: "", controlIndex: 0, sequence: "")
        
        var arrayIndex = 0
        var resultData = data
        var changedIndex = dateIndex
        
        for (index, _) in array.enumerated() {
            if index == 0 { //제일 첫번 째로 들어가는 기간일정을 어느 위치에 넣어줘야 하는 지 파악
                resultData.sequence = "first" //보더 넣어주기위해
                
                let memoArray = self.calendarMemoDataArray[changedIndex]
                
                for (forIndex, i) in memoArray.enumerated() { //중간에 빈 배열이 있으면 찾아서 들어가도록
                    
                    if i.titleMemo == "" {
                        self.calendarMemoDataArray[changedIndex][forIndex] = resultData
                        arrayIndex = forIndex
                        
                        break
                    }else{
                        if forIndex == memoArray.count - 1 { //마지막 데이터 일 때
                            
                            self.calendarMemoDataArray[changedIndex].append(resultData)
                            
                            let number = (self.calendarMemoDataArray[changedIndex].count) - 1
                            arrayIndex = number
                        }
                    }
                }
            }else{
                if index == array.count - 1{ //마지막 인덱스면 보더 넣어주기 위해 데이터 변경
                    resultData.sequence = "last"
                }else{
                    resultData.sequence = ""
                }
                
                if arrayIndex == 0 {
                    self.calendarMemoDataArray[changedIndex][0] = resultData
                    
                }else if arrayIndex == 1{ //index가 1일 때 어차피 앞에 배열이 있으니 채워주면 됨
                    if self.calendarMemoDataArray[changedIndex].indices.contains(2){
                        self.calendarMemoDataArray[changedIndex][1] = resultData
                    }else{
                        self.calendarMemoDataArray[changedIndex].append(resultData)
                    }
                    
                }else if arrayIndex == 2{ //index가 2일 때
                    
                    if self.calendarMemoDataArray[changedIndex].indices.contains(1) { //1번 인덱스에 배열이 있는 지 확인
                        self.calendarMemoDataArray[changedIndex].append(resultData)
                        
                    }else{
                        self.calendarMemoDataArray[changedIndex].append(nilValue)
                        self.calendarMemoDataArray[changedIndex].append(resultData)
                    }
                    
                }else if arrayIndex == 3{
                    
                    if self.calendarMemoDataArray[changedIndex].indices.contains(2) {
                        self.calendarMemoDataArray[changedIndex].append(resultData)
                    }else{
                        if self.calendarMemoDataArray[changedIndex].indices.contains(1) {
                            self.calendarMemoDataArray[changedIndex].append(nilValue)
                            self.calendarMemoDataArray[changedIndex].append(resultData)
                        }else{
                            self.calendarMemoDataArray[changedIndex].append(nilValue)
                            self.calendarMemoDataArray[changedIndex].append(nilValue)
                            self.calendarMemoDataArray[changedIndex].append(resultData)
                        }
                    }
                }else{
                    if self.calendarMemoDataArray[changedIndex][0].titleMemo == "" {
                        self.calendarMemoDataArray[changedIndex][0] = resultData
                    }else{
                        self.calendarMemoDataArray[changedIndex].append(resultData)
                    }
                }
            }
            changedIndex += 1
        }
    }
    
    private func setFormattedDateIndex(targetDate : String, controlIndex : Int) -> Array<String>.Index? {
        var resultDate = String()
        
        if controlIndex == 0 {
            resultDate = targetDate
            
        }else{
            self.dateFormmater.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
            
            let startFormattedDate = dateFormmater.date(from: targetDate) ?? Date()
            
            self.dateFormmater.dateFormat = "yyyy년 MM월 dd일"
            resultDate = dateFormmater.string(from: startFormattedDate)
        }
        
        return indexDateArray.firstIndex(of: resultDate)
    }//"yyyy년 MM월 dd일 HH시 mm분" 형식으로 들어온 날짜를 indexDateArray 요소와 맞게 변경해주기
    
    private func setHolidayArray(index : Array<String>.Index) { //공휴일 데이터
        self.holidaySet.insert(index)
    }
}

//MARK: - Extension

extension FollowCalendarViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCalendarViewCell.identifier, for: indexPath) as! CustomCalendarViewCell
        
        
        if self.todayIndex == self.indexDateArray[indexPath.row] {
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.displayModeColor2?.cgColor
        }else {
            cell.layer.borderWidth = 0
            cell.layer.borderColor = .none
        }
        
        if holidaySet.contains(indexPath.row){ //공휴일은 레드
            cell.dayLabel.textColor = .customRed
        }else if sundaySet.contains(indexPath.row){ //일요일은 레드
            cell.dayLabel.textColor = .customRed
        }else if saturdaySet.contains(indexPath.row){ //토요일은 퍼플
            cell.dayLabel.textColor = .customLightPuple
        }else{
            cell.dayLabel.textColor = .displayModeColor2
        }
        
        
        cell.todoListTabelView.isUserInteractionEnabled = false
        cell.dayLabel.text = self.daysArray[indexPath.row]
        cell.indexDate = self.indexDateArray[indexPath.row]
        
        cell.calendarMemoData = self.calendarMemoDataArray[indexPath.row]
        cell.todoListTabelView.reloadData()
        
        return cell
    }
    
}



extension FollowCalendarViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedDate = self.indexDateArray[indexPath.row]

        if selectedDate != "" {

            let vc = FollowScheduleViewController()
            vc.calendarMemoArray = self.calendarMemoDataArray[indexPath.row]
            vc.dateLabel.text = selectedDate
            vc.modalPresentationStyle = .pageSheet

            self.present(vc, animated: true)
        }
    }
}

extension FollowCalendarViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.weekStackView.frame.width / 7
        
        return CGSize(width: width, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension FollowCalendarViewController : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
