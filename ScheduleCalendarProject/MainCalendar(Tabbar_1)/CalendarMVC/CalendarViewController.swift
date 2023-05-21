//
//  CalendarViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class CalendarViewController: UIViewController {
    //MARK: - Properties
    final let calendarView = CalendarView() //View
    final var calendarDateModel = CalendarDataModel() //Model
    final let calendarDataService = CalendarDataService()
    
    private let margin : CGFloat = 87 //calendarView에서 컬렉션뷰의 높이를 구하기 위해 나머지 컨텐츠들의 높이를 더한 값.
    private var maxCountEvent = 0          //유저의 가장 많은 이벤트가 있는 날의 이벤트 갯수.
    
    private lazy var rightMenuButton : UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .done, target: self, action: #selector(goToShareCalendarView(_:)))
        
        return button
    }()
    
    private lazy var navigationBackButton : UIBarButtonItem = {
        let button = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return button
    }()

    private var cellHeights: [CGFloat] = [] // 컬렉션 뷰 셀의 높이를 저장할 배열
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateNavigationTitle()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.tabBarController?.tabBar.isHidden = false
        handleGetCalendarData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        setupNavigationBar()
        calendarDateModel.configureCalendar()                          //날짜 데이터를 만들기 시작.
        calendarView.titleLabel.text = calendarDateModel.currentTitle  //View의 Title에 날짜 데이터를 넣어줌.
        calendarDateModel.indexOfToday()                               //오늘 날짜와 일치하는 인덱스를 찾음.
    }

    //MARK: - ViewMethod
    private func setupSubViews() {
        view.backgroundColor = .customWhiteAndBlackColor
        
        view.addSubview(calendarView)
        calendarView.swipeDelegate = self //calendar를 다음달로 넘기거나, 이전달로 넘기는 제스처를 전달받기 위해.
        calendarView.calendarCollectionView.dataSource = self
        calendarView.calendarCollectionView.delegate = self
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.left.right.equalToSuperview().inset(10)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(titleLabelTapped))
        calendarView.titleLabel.addGestureRecognizer(tapGesture)
        calendarView.goTodayButton.addTarget(self, action: #selector(goTodayCliked(_:)), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationItem.title = "Calendar"
        navigationItem.rightBarButtonItem = rightMenuButton
        navigationItem.backBarButtonItem = navigationBackButton
        navigationController?.navigationBar.tintColor = .blackAndWhiteColor
    }
    
    private func updateNavigationTitle() {
        //현재 선택한 캘린더
        if let calendarName = UserDefaults.standard.string(forKey: "CurrentSelectedCalendarName") {
            navigationItem.title = calendarName
        }else{
            navigationItem.title = "With Calendar"
        }
    }
    
    //goToday 버튼을 활성화시킬지 결정하는 메서드.
    private func updateTodayButtonVisibility() {
        calendarView.goTodayButton.isHidden = calendarDateModel.checkDate()
    }
    
    //MARK: - ButtonMethod
    //goToday 버튼을 클릭하면 오늘 날짜로 달력을 되돌림.
    @objc private func goTodayCliked(_ sender : UIButton) {
        calendarDateModel.configureCalendar()
        updateCalendarUI()
        handleGetCalendarData()
    }
    
    @objc private func goToShareCalendarView(_ sender : UIBarButtonItem) {
        guard isUserLoggedIn() else{
            showAlert(title: "로그인", message: "로그인이 필요한 서비스입니다.")
            return
        }
        
        let vc = CalendarCategoryViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - 달력 컬렉션뷰 설정.
extension CalendarViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarDateModel.days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as! CalendarCollectionViewCell
        
        cell.dayLabel.text = calendarDateModel.days[indexPath.row]
        cell.dayLabel.textColor = determineCellColor(at: indexPath.row)
        
        styleCellBorder(cell: cell, at: indexPath.row)
        
        cell.collectionViewHeight = calendarView.frame.size.height - margin
        cell.customCalendarData = calendarDateModel.customCalendarDataArray[indexPath.row]
        cell.scheduleTableView.reloadData()
        
        return cell
    }
    
    //Cell 클릭 이벤트.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard isUserLoggedIn() else{
            showAlert(title: "로그인", message: "로그인이 필요한 서비스입니다.")
            return
        }
        
        //유저가 누른 cell을 가져오고, cell의 크기를 전체 화면에서 비교하여 cell의 위치좌표를 얻어내는 작업.
        let cell = collectionView.cellForItem(at: indexPath)
        let cellFrame = collectionView.convert(cell!.frame, to: self.view)
        
        goToScheduleManagerView(at: indexPath.row, selectedFrame: cellFrame)
    }
    
    //Cell Layout
    //1. cell 내부에 있는 tableview의 height를 계산한다.
    //2. device 크기에 따라 tableview의 RowHeight가 달라지기 때문에 계산하여 rowHeight를 구함.
    //3. 만약 rowHeight가 테이블뷰의 높이에서 3을 나눈 값이라면 우리에게 보이는 이벤트는 3개죠? 이 3개보다 더 많은 이벤트가 존재한다면 그 갯수만큼 컬렉션뷰의 cell 높이를 늘려주는 것.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let deviceHeight = UIScreen.main.bounds.size.height
        let collectionViewCellHeight = calendarView.frame.size.height - margin //내가 직접 계산한 컬렉션뷰의 높이로 설정.
        let tableViewHeight = calculateTableViewHeight() //tableview의 Height.
        
        let cellWidth = calendarView.frame.width / 7
        var cellHeight = collectionViewCellHeight / 5
        
        let maxVisibleRows = (deviceHeight > 750) ? 4 : 3
        let tableViewCellHeight = tableViewHeight / CGFloat(maxVisibleRows)    //tableview의 RowHeight.
        
        if maxCountEvent > maxVisibleRows {
            let extraRows = CGFloat(maxCountEvent - maxVisibleRows)
            cellHeight += extraRows * tableViewCellHeight
        }
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    //주말과 공휴일에 포함된 셀의 라벨컬러는 다르게 표현.
    private func determineCellColor(at index: Int) -> UIColor {
        
        if calendarDateModel.holidayIndexSet.contains(index){ //공휴일
            return .customRedColor ?? .red
            
        }else if calendarDateModel.sundayIndexSet.contains(index) { //일요일
            return .customRedColor ?? .red
            
        }else if calendarDateModel.saturdayIndexSet.contains(index) { //토요일
            return .customBlueColor ?? .blue
            
        }else{
            return .blackAndWhiteColor ?? .black
        }
    }
    
    //오늘날짜에 해당하는 인덱스에 보더넣어주기.
    private func styleCellBorder(cell: CalendarCollectionViewCell, at index: Int) {
        guard calendarDateModel.checkDate() else{ //보여지는 날짜와 현재 날짜가 동일한지 체크.
            cell.layer.borderColor = .none
            cell.layer.borderWidth = 0
            return
        }
        
        let checkIndex = calendarDateModel.todayIndex == index //오늘날짜 인덱스가 일치하는지 체크.
        
        cell.layer.borderColor = checkIndex ? UIColor.blackAndWhiteColor?.cgColor : .none
        cell.layer.borderWidth = checkIndex ? 0.5 : 0
    }
    
    //cell을 클릭했을 때 schedule뷰로 이동.
    private func goToScheduleManagerView(at indexRow: Int, selectedFrame: CGRect) {
        let day = calendarDateModel.specificDateArray[indexRow]
        guard day != "" else{return}
        
        triggerHapticFeedback() //유저에게 리액션을 주기 위한 미세한 진동음.
        
        let vc = ScheduleManagerViewController()
        
        vc.scheduleManagerView.dateLabel.text = day
        vc.scheduleManagerDataModel.customCalendarDataArray = calendarDateModel.customCalendarDataArray[indexRow].filter{ $0.titleText != "" }
        
        vc.scheduleManagerView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        vc.modalPresentationStyle = .custom
        vc.cellFrame = selectedFrame
        
        self.present(vc, animated: false) {
            UIView.animate(withDuration: 0.2) {
                vc.scheduleManagerView.transform = .identity
            }
        }
    }
    
    private func calculateTableViewHeight() -> CGFloat {
        let collectionViewHeight = calendarView.frame.size.height - margin
        let collectionCellHeight = collectionViewHeight / 5
        let dayLabelHeight : CGFloat = 12
        let marginBetweenDayLabelAndTableView: CGFloat = 13
        let bottomInsetOfTableView: CGFloat = 5
        
        return (collectionCellHeight - (dayLabelHeight + marginBetweenDayLabelAndTableView + bottomInsetOfTableView)) + 6
    }
    
}


//MARK: - 달력을 Swipe했을 때 작업.
extension CalendarViewController : CalendarSwipeDelegate {
    
    func plusMonthGesture() {
        calendarDateModel.plusMonth() //월 +1 해줌.
        updateCalendarUI()
        handleGetCalendarData()
    }
    
    func minusMonthGesture() {
        calendarDateModel.minusMonth() //월 -1 해줌.
        updateCalendarUI()
        handleGetCalendarData()
    }
    
    private func updateCalendarUI() {
        triggerHapticFeedback()                                       //변화에 대한 애니메이션
        performTransition(with: self.calendarView, duration: 0.5)     //변화에 대한 애니메이션.
        calendarView.titleLabel.text = calendarDateModel.currentTitle //날짜 타이틀 변경.
        updateTodayButtonVisibility()                                 //goToday 버튼의 활성화
        calendarView.calendarCollectionView.reloadData()
    }
}

//MARK: - TitleLabel의 제스처와 데이트 피커 설정을 통해 원하는 날짜로 이동하는 작업.
extension CalendarViewController : DateSelectionDelegate {
    func sendDate(date: Date) {
        triggerHapticFeedback()
        calendarDateModel.moveToSelectedDate(date: date)
        updateCalendarUI()
        handleGetCalendarData()
    }
    
    @objc private func titleLabelTapped() {
        triggerHapticFeedback()
        
        let date = calendarDateModel.calendarDate
        
        let vc = DateSelectionViewController()
        vc.startAndEndDatePickerView.datePicker.date = date
        vc.startAndEndDatePickerView.dateTitleLabel.text = date.convertDateToString(format: "yyyy년 MM월 dd일")
        vc.dateSelectionDelegate = self
        vc.modalPresentationStyle = .custom
        
        self.present(vc, animated: true)
    }
}


//MARK: - 캘린더 데이터를 가져와서 달력 구조에 맞게 가공하여 배열에 넣어주기.
extension CalendarViewController {
    private func handleGetCalendarData() {
        let query = calendarDateModel.currentTitle
        
        calendarDataService.getCalendarMemoData(queryData: query) { [weak self] result in
            switch result {
                
            case .success(let findDataArray):
                self?.deploymentCalendarData(findDataArray)
                
            case .failure(let err):
                self?.showAlert(title: "데이터 가져오기 실패", message: err.localizedDescription)
            }
        }
    }
    
    private func deploymentCalendarData(_ dataArray: [CustomCalendarData]) {
        calendarDateModel.initArrayForFetchData() //데이터의 초기화.
        
        for data in dataArray {
            
            //1. 이벤트의 시작날짜가 몇 번째 인덱스에 위치하는지 파악.
            let index = calendarDateModel.getIndexForFormattedDate(data.startDate, controlIndex: data.controlIndex)
            
            if data.count == 0 { //당일 스케줄일 때
                calendarDateModel.deploySingleEventToCalendarData(at: index, data: data)
                
            }else{  //장기 스케줄일 때
                calendarDateModel.deployMultipleEventToCalendarData(at: index, data: data)
            }
            
            if data.selectedColor == "#CC3636FF" { //공휴일은 따로 색 지정을 위해서 배열에 넣어둠.
                calendarDateModel.holidayIndexSet.insert(index)
            }
        }
        
        findMaxCountEventToCalendarData()
        calendarView.calendarCollectionView.reloadData()
    }
    
    //유저의 캘린더 데이터 중 가장 많은 이벤트가 있는 날의 이벤트 갯수를 저장.
    private func findMaxCountEventToCalendarData(){
        let counts = calendarDateModel.customCalendarDataArray.map{ $0.count }
        guard let maxCount = counts.max() else{return}
        
        self.maxCountEvent = maxCount
    }
}

