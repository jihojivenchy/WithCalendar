//
//  ViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/11/02.
//

import UIKit
import SnapKit

final class CalendarViewController: UIViewController {
//MARK: - Properties
    
    //views
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let weekStackView = UIStackView()
    private let calendarView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    
    private let goTodayButton = UIButton()
    private lazy var calendarButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "calendar.badge.plus"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(calendarButtonPressed(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private let backTodayButton = UIButton()
    
    private let navigationBackButton = UIBarButtonItem(title: nil, style: .plain, target: self, action: nil)
    
    //view들을 위한
    private let calendar = Calendar.current
    private let dateFommater = DateFormatter()
    private var calendarDate = Date()
    private var daysArray : [String] = []  //달력에 날짜 표시하기 위해서 날짜들 저장 ex) 첫 째날이 월요일이라면 ["", "1", "2" ...]
    private let weekendArray : [Int] = [0, 6, 7, 13, 14, 20, 21, 27, 28, 34, 35, 41]
    
    private var seletedIndex : Int?  //누른 셀의 컬러를 바꾸기 위해 index.row 정보를 저장
    
    private var dayIndex = ""  //오늘
    
//MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        tabBarAppearance()
        self.navigationItem.title = "지호쓰캘린더"
        self.navigationItem.backBarButtonItem = navigationBackButton
        navigationController?.hidesBarsOnSwipe = true
        
        configureCalendar()
        configureToday()
        
        calendarView.register(CustomCalendarViewCell.self, forCellWithReuseIdentifier: CustomCalendarViewCell.identifier)
        calendarView.dataSource = self
        calendarView.delegate = self
        
    }
    
//MARK: - ViewMethod
    
    private func addSubViews() {
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(plusMonth(_:)))
        swipeRight.direction = .left
        swipeRight.delegate = self
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(minusMonth(_:)))
        swipeLeft.direction = .right
        swipeLeft.delegate = self
        
        view.backgroundColor = .customGray
        
        view.addSubview(contentView)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowRadius = 10
        contentView.layer.shadowOpacity = 0.5
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.left.right.equalTo(view).inset(10)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 23)
        titleLabel.sizeToFit()
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(23)
        }
        
        contentView.addSubview(goTodayButton)
        goTodayButton.tintColor = .black
        goTodayButton.addTarget(self, action: #selector(goTodayButtonPressed(_:)), for: .touchUpInside)
        goTodayButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.left.equalToSuperview().inset(10)
            make.width.height.equalTo(23)
        }
        
        contentView.addSubview(calendarButton)
        calendarButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().inset(10)
            make.width.height.equalTo(23)
        }

        contentView.addSubview(weekStackView)
        weekStackView.distribution = .fillEqually
        self.setWeekStackView()
        weekStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(25)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(30)
        }
        
        contentView.addSubview(calendarView)
        calendarView.indicatorStyle = .white
        calendarView.addGestureRecognizer(swipeLeft)
        calendarView.addGestureRecognizer(swipeRight)
        calendarView.backgroundColor = .white
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(weekStackView.snp_bottomMargin).offset(15)
            make.right.left.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }

    }
    
    private func tabBarAppearance() {
        let tapAppearnce = UITabBarAppearance()
        tapAppearnce.configureWithOpaqueBackground()
        tapAppearnce.backgroundColor = .customGray
        tapAppearnce.shadowColor = UIColor.clear     //remove tabbar border line
        
        // 스크롤을 내려 탭바에 닿았을 때 탭바의 scrollEdgeAppearance 를 standardAppearance 로 set하는 것
        tabBarController?.tabBar.standardAppearance = tapAppearnce
        tabBarController?.tabBar.scrollEdgeAppearance = tapAppearnce
        
        tabBarController?.tabBar.tintColor = .black  //선택되었을 때 컬러
        
        //tabbar shadow 커스텀
        tabBarController?.tabBar.layer.masksToBounds = false
        tabBarController?.tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBarController?.tabBar.layer.shadowOpacity = 0.3
        tabBarController?.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBarController?.tabBar.layer.shadowRadius = 6
    }
    
    private func setWeekStackView() {  //stackView에 라벨을 일정한 간격으로 두기
        let weekArray = ["일", "월", "화", "수", "목", "금", "토"]
        
        for i in 0..<7 {
            let label = UILabel()
            label.text = weekArray[i]
            label.textColor = .black
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 13)
            self.weekStackView.addArrangedSubview(label)
            
            if i == 0 {
                label.textColor = .red
            }else if i == 6 {
                label.textColor = .red
            }
        }
    }
    
    
    private func configureToday() {  //현재 날짜를 dd 형식으로 받고, 받은 날짜가 daysArray에 몇 번째 인덱스인지 확인하고 저장
        let dfMatter = DateFormatter()
        dfMatter.dateFormat = "dd"
        let today = dfMatter.string(from: Date())
//        guard let todayIndex = daysArray.firstIndex(of: today) else {return}
        
        self.dayIndex = today
    }
    
    private func configureCalendar() { //현재 해당하는 년과 월을 저장하고, yyyy-mm 형태 저장.
        let components = self.calendar.dateComponents([.year, .month], from: Date()) //현재 날짜에서 년, 월만 뽑기
        self.calendarDate = self.calendar.date(from: components) ?? Date() //뽑아낸 정보는 dateComponents 타입이기 때문에 date메서드를 통해 date 형태로 저장
        self.dateFommater.dateFormat = "yyyy년 MM월"
        self.updateCalendar()
    }
    
    private func startDayOfTheWeek() -> Int { //해당 날짜가 속한 달의 첫 번째 날이 무슨 요일인지 알아내기 위한 메서드.
        
        return calendar.component(.weekday, from: self.calendarDate) - 1 //-1은 배열이 0번부터 시작하는 것과 동일하게함
    }
    
    private func calculateEndDay() -> Int { //해당 날짜가 속한 month가 총 몇 day인지 알기 위한 메서드.
        return self.calendar.range(of: .day, in: .month, for: self.calendarDate)?.count ?? Int()
    }
    
    private func updateTitle() { //해당 날짜를 yyyy년 mm월 형식으로 라벨 텍스트 변경
        let date = self.dateFommater.string(from: self.calendarDate)
        self.titleLabel.text = date
    }
    
    private func updateDays() { //캘린더 셀에 들어갈 날짜 만들기 시작
        
        self.daysArray.removeAll()  //다음달이나 이전달로 스크롤 할 때 days를 다시 새로 계산하니까 모두 삭제
        let startDayOfTheWeek = self.startDayOfTheWeek() //첫 번째 날 시작 인덱스를 저장하기 위해
        let totalDays = startDayOfTheWeek + self.calculateEndDay() //시작 인덱스와 총 날짜 개수를 더해서 저장
        
        for day in 0..<totalDays {
            
            if day < startDayOfTheWeek { //시작 인덱스까지 가지 못하면 빈칸으로 채우기.
                self.daysArray.append("")
                continue  //continue를 통해 다음 구문을 실행하지 않고, 다시 if문 시작
            }
            
            self.daysArray.append("\(day - startDayOfTheWeek + 1)") //시작 인덱스부터 날짜들을 배열안에 채워넣기
        }
        
        self.calendarView.reloadData()
    }
    
    private func updateCalendar() { //주요 함수 모아놓은 거
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
            self.goTodayButton.setBackgroundImage(UIImage(systemName: ""), for: .normal)
        }else {
            self.goTodayButton.setBackgroundImage(UIImage(systemName: "gobackward"), for: .normal)
        }
    }
    
    private func saveSelectedDate() {
        guard let text = self.titleLabel.text else{return}
        guard let selectIndex = self.seletedIndex else{return}
        let date = " \(daysArray[selectIndex])일"
        
        UserDefaults.standard.set(text + date, forKey: "selectedDate")
    }
    
    

//MARK: - ButtonMethod
    
    @objc private func calendarButtonPressed(_ sender : UIButton) {
        self.navigationController?.pushViewController(ChangeCalendarViewController(), animated: true)
    }
    
    @objc func goTodayButtonPressed(_ sender : UIButton) {
        let components = self.calendar.dateComponents([.year, .month], from: Date()) //현재 날짜에서 년, 월만 뽑기
        self.calendarDate = self.calendar.date(from: components) ?? Date() //뽑아낸 정보는 dateComponents 타입이기 때문에 date메서드를 통해 date 형태로 저장
        goTodayButton.setBackgroundImage(UIImage(systemName: ""), for: .normal)
        self.updateCalendar()
    }
    
    @objc func minusMonth(_ sender : UISwipeGestureRecognizer) { //이전 달로 이동
        self.calendarDate = self.calendar.date(byAdding: DateComponents(month: -1), to: self.calendarDate) ?? Date()
        updateCalendar()
        appearTodayButton()
    }
    
    @objc func plusMonth(_ sender : UISwipeGestureRecognizer) { //다음 달로 이동
        self.calendarDate = self.calendar.date(byAdding: DateComponents(month: +1), to: self.calendarDate) ?? Date()
        updateCalendar()
        appearTodayButton()
    }
    
}



//MARK: - Extension

extension CalendarViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCalendarViewCell.identifier, for: indexPath) as! CustomCalendarViewCell
        
        
        if currentMonth() {  //오늘날짜를 표시해주기 위한 메서드. 화면에 보여지는 달이 현재 날짜와 동일하면 today 표시해주기.
            if self.dayIndex == self.daysArray[indexPath.row] {
                    cell.layer.borderWidth = 2
                    cell.layer.borderColor = UIColor.black.cgColor
                }else {
                    cell.layer.borderWidth = 0
                    cell.layer.borderColor = .none
                }
        }else{  //재사용 셀이기 때문에 false일 때 표시 사라지게 만들어주기.
            cell.layer.borderWidth = 0
            cell.layer.borderColor = .none
        }
        
        
        if weekendArray.contains(indexPath.row) { //주말은 색상바꿔주기.
            cell.dayLabel.textColor = .red
        }else{
            cell.dayLabel.textColor = .black
        }
        
        if seletedIndex == indexPath.row { //cell 클릭 했을 때 색상바꿔주기.
            cell.backgroundColor = .customGray
        }else {
            cell.backgroundColor = .white
        }
        
        if indexPath.row == 11{
            cell.firstText = "개발공부"
            cell.firstCellColor = .clear
            cell.firstLabelColor = .yellow
            cell.secondText = "zz"
            cell.secondLabelColor = .green
            cell.thirdText = "dddd"
            cell.thirdLabelColor = .darkGray
            
            cell.returnCellCount = 4
            cell.todoListTabelView.reloadData()
        }else {
            cell.firstText = ""
            cell.firstLabelColor = .clear
            cell.firstCellColor = .clear
            cell.returnCellCount = 0
            cell.todoListTabelView.reloadData()
        }
        
        cell.todoListTabelView.isUserInteractionEnabled = false
        cell.dayLabel.text = self.daysArray[indexPath.row]
        
        return cell
    }
   
}



extension CalendarViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        seletedIndex = indexPath.row
        collectionView.reloadData()
        
        self.saveSelectedDate()
        
        let vc = ScheduleViewController()
        vc.modalPresentationStyle = .fullScreen
        
        self.present(ScheduleViewController(), animated: true)
    }
}

extension CalendarViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.weekStackView.frame.width / 7
        
        return CGSize(width: width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}

extension CalendarViewController : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}





