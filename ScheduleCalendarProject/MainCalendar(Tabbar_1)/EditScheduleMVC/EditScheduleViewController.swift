//
//  EditScheduleViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/05/18.
//


import UIKit
import SnapKit
import UIColor_Hex_Swift
import FirebaseAuth

final class EditScheduleViewController: UIViewController {
    //MARK: - Properties
    final var editScheduleDataModel = EditScheduleDataModel()
    final var addScheduleDataModel = AddScheduleDataModel()
    final let addScheduleView = AddScheduleView()
    final let addScheduleDataService = ScheduleDataService()
    final let notificationService = NotificationService()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateCalendarDataForDataModel()
        populateCalendarDataForSubViews()
        setupSubViews()
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        view.backgroundColor = .whiteAndCustomBlackColor
        
        view.addSubview(addScheduleView)
        addScheduleView.addScheduleTableView.dataSource = self
        addScheduleView.addScheduleTableView.delegate = self
        addScheduleView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addScheduleView.titleTextField.delegate = self
        addScheduleView.dismissButton.addTarget(self, action: #selector(dismissButtonPressed(_:)), for: .touchUpInside)
        addScheduleView.saveButton.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
        addScheduleView.deleteButton.addTarget(self, action: #selector(deleteButtonPressed(_:)), for: .touchUpInside)
    }
    
    //데이터를 뷰의 옵션에 알맞게 뿌려줌.
    private func populateCalendarDataForSubViews() {
        guard let data = editScheduleDataModel.customCalendarData else { return }
        configureButtonsOnHolidayData(data.selectedColor)
        
        let selectedColor = UIColor(data.selectedColor)
        
        addScheduleView.deleteButton.tintColor = selectedColor
        addScheduleView.dismissButton.tintColor = selectedColor
        addScheduleView.saveButton.tintColor = selectedColor
        addScheduleView.titleTextField.placeholderColor = selectedColor
        addScheduleView.titleTextField.borderActiveColor = selectedColor
        
        addScheduleView.titleTextField.text = data.titleText
    }
    
    //데이터를 데이터모델에 알맞게 뿌려줌.
    private func populateCalendarDataForDataModel() {
        guard let data = editScheduleDataModel.customCalendarData else { return }
        
        addScheduleDataModel.eventTitle = data.titleText
        addScheduleDataModel.selectedColor = data.selectedColor
        addScheduleDataModel.subTitleArray = [data.startDate, data.endDate, data.notification, "", data.detailMemo]
        addScheduleDataModel.controlMode = data.controlIndex == 0 ? .date : .time
    }
    
    //현재 이벤트가 공휴일 데이터인지 판단하고 편집할 수 있는 버튼을 보여줄지 결정.
    private func configureButtonsOnHolidayData(_ color: String) {
        guard checkHolidayData(color: color) else{
            addScheduleView.deleteButton.isHidden = true
            addScheduleView.saveButton.isHidden = true
            return
        }
        
        addScheduleView.deleteButton.isHidden = false
    }
    
    //MARK: - ButtonMethod
    @objc private func dismissButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc private func saveButtonPressed(_ sender: UIButton) {
        guard let title = addScheduleView.titleTextField.text else{return}
        addScheduleDataModel.eventTitle = title
        
        if title == "" {
            showAlert(title: "제목작성", message: "제목을 작성해주세요.")
        }else{
            CustomLoadingView.shared.startLoading(to: 0)
            
            setNotification() //notification 설정
            handleUpdateCalendarDataToFireStore() //데이터 저장.
        }
    }
    
    @objc private func deleteButtonPressed(_ sender: UIButton) {
        deleteCalendarDataAlert()
    }
    
    //MARK: - CellClickedMethod
    
    private func startDateCellClicked() {
        let vc = StartDatePickerViewController()
        
        vc.startAndEndDatePickerView.dateTitleLabel.text = addScheduleDataModel.subTitleArray[0]
        vc.eventDateTimeMode = addScheduleDataModel.controlMode
        vc.startDatePickerDelegate = self
        vc.addScheduleDataModel.selectedColor = addScheduleDataModel.selectedColor //컬러 전달.
        
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true)
    }
    
    private func endDateCellClicked() {
        let vc = EndDatePickerViewController()
        
        vc.startAndEndDatePickerView.dateTitleLabel.text = addScheduleDataModel.subTitleArray[1]
        vc.eventDateTimeMode = addScheduleDataModel.controlMode
        vc.endDatePickerDelegate = self
        vc.addScheduleDataModel.selectedColor = addScheduleDataModel.selectedColor //컬러 전달.
        
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true)
    }
    
    private func setNotificationCellClicked() {
        let vc = SetNotificationViewController()
        
        vc.setNotificationDataModel.startDate = addScheduleDataModel.subTitleArray[0]      //기본 설정 날짜
        vc.setNotificationDataModel.selectedColor = addScheduleDataModel.selectedColor     //컬러 전달.
        vc.setNotificationDelegate = self                                                  //delegate 설정.
        vc.setNotificationDataModel.controlMode = addScheduleDataModel.controlMode         //모드에 따라 옵션 내용이 변경됨.
        vc.setNotificationDataModel.selectedOption = addScheduleDataModel.subTitleArray[2] //유저가 선택한 옵션.
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true)
    }
    
    private func setColorCellClicked() {
        let vc = SetColorViewController()
        
        vc.setColorDelegate = self
        vc.setColorDataModel.selectedColor = addScheduleDataModel.selectedColor
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true)
    }
    
    private func setMemoCellClicked() {
        let vc = SetMemoViewController()
        
        vc.setMemoDelegate = self
        vc.setMemoView.memoTextView.text = addScheduleDataModel.subTitleArray[4]
        self.present(vc, animated: true)
    }
}

//MARK: - Extension
extension EditScheduleViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addScheduleDataModel.actionImageArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: DateTimeModeSelectionTableViewCell.identifier, for: indexPath) as! DateTimeModeSelectionTableViewCell
            
            cell.selectionDelegate = self
            cell.modeControl.selectedSegmentTintColor = UIColor(addScheduleDataModel.selectedColor)
            cell.contentView.isUserInteractionEnabled = false
            cell.accessoryType = .none
            cell.selectionStyle = .none
            
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: AddScheduleTableViewCell.identifier, for: indexPath) as! AddScheduleTableViewCell
            
            //0번 인덱스로 모드설정하는 cell을 넣었기 때문에 index -1 한 값부터 시작하도록.
            let actionImage = addScheduleDataModel.actionImageArray[indexPath.row - 1]
            let titleText = addScheduleDataModel.titleArray[indexPath.row - 1]
            let subTitleText = addScheduleDataModel.subTitleArray[indexPath.row - 1]
            
            cell.actionImageView.image = UIImage(systemName: actionImage)
            cell.actionImageView.tintColor = UIColor(addScheduleDataModel.selectedColor)
            cell.titleLabel.text = titleText
            cell.subTitleLabel.text = subTitleText
            
            cell.accessoryType = .disclosureIndicator
            cell.contentView.isUserInteractionEnabled = true
            cell.selectionStyle = .default
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //cell을 클릭했을 때 애니메이션 구현
        self.view.endEditing(true)
        
        if indexPath.row == 1 { //시작 날짜 cell 클릭
            startDateCellClicked()
            
        }else if indexPath.row == 2 { //종료 날짜 cell 클릭
            endDateCellClicked()
            
        }else if indexPath.row == 3 { //알림 설정 cell 클릭
            setNotificationCellClicked()
            
        }else if indexPath.row == 4 { //컬러 cell 클릭
            setColorCellClicked()
            
        }else if indexPath.row == 5 { //메모 cell 클릭
            setMemoCellClicked()
            
        }else{
            //none
        }
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

extension EditScheduleViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

//MARK: - 하루종일모드와 시간설정모드에 따른 조정작업.
extension EditScheduleViewController : DateTimeModeSelectionDelegate {
    func changeTimeMode() {
        performTransition(with: self.addScheduleView, duration: 0.5) //애니메이션.
        
        addScheduleDataModel.controlMode = .time
        addScheduleDataModel.changeSubTitleArray()
        addScheduleView.addScheduleTableView.reloadData()
    }
    
    func changeDateMode() {
        performTransition(with: self.addScheduleView, duration: 0.5) //애니메이션.
        
        addScheduleDataModel.controlMode = .date
        addScheduleDataModel.changeSubTitleArray()
        addScheduleView.addScheduleTableView.reloadData()
    }
}

//MARK: - 시작날짜 조정작업.
extension EditScheduleViewController : StartDatePickerDelegate {
    func sendStartDate(date: String) {
        performTransition(with: self.addScheduleView, duration: 0.5) //애니메이션.
        
        addScheduleDataModel.subTitleArray[0] = date
        addScheduleDataModel.subTitleArray[1] = date
        addScheduleView.addScheduleTableView.reloadData()
    }
}

//MARK: - 종료날짜 조정작업.
extension EditScheduleViewController : EndDatePickerDelegate {
    func sendEndDate(date: String) {
        performTransition(with: self.addScheduleView, duration: 0.5) //애니메이션.
        
        addScheduleDataModel.subTitleArray[1] = date
        addScheduleView.addScheduleTableView.reloadData()
    }
}

//MARK: - 알림을 받을지에 관한 작업설정.
extension EditScheduleViewController : SetNotificationDelegate {
    func selectedOption(option: String) {
        performTransition(with: self.addScheduleView, duration: 0.5) //애니메이션.
        
        addScheduleDataModel.subTitleArray[2] = option
        addScheduleView.addScheduleTableView.reloadData()
    }
}

//MARK: - 컬러선택 작업.
extension EditScheduleViewController : SetColorDelegate {
    func selectedColor(color: String) {
        addScheduleDataModel.selectedColor = color //현재 컬러 저장.
        
        
        addScheduleView.deleteButton.tintColor = UIColor(color)
        addScheduleView.dismissButton.tintColor = UIColor(color)
        addScheduleView.saveButton.tintColor = UIColor(color)
        
        addScheduleView.titleTextField.placeholderColor = UIColor(color)
        addScheduleView.titleTextField.borderActiveColor = UIColor(color)
        
        addScheduleView.addScheduleTableView.reloadData()
    }
}

//MARK: - 메모작성 작업.
extension EditScheduleViewController : SetMemoDelegate {
    func sendMemo(memo: String) {
        addScheduleDataModel.subTitleArray[4] = memo
        addScheduleView.addScheduleTableView.reloadData()
    }
}

//MARK: - 알림설정과 데이터 저장 작업처리.
extension EditScheduleViewController {
    private func setNotification() {
        let scheduleData = addScheduleDataModel.setAddScheduleData() //유저가 작성한 데이터들을 모두 취합한 유저의 스케줄 데이터.
        removeNotificationRequestIfNeeded() //유저가 기존에 설정해두었던 알림요청이 있다면 삭제해줌.
        
        //알림 없음, 유저가 설정한 알림 옵션이 그대로 일 때, 노티피케이션 설정을 없앤다.
        if scheduleData.option == "알림 없음" {
            print("노티피케이션 설정 없음.")
            
        }else{
            //유저가 작성한 데이터들을 가지고 알림요청 구현.
            notificationService.setNotificationRequest(data: scheduleData)
        }
    }
    
    //캘린더 수정.
    private func handleUpdateCalendarDataToFireStore() {
        guard let data = editScheduleDataModel.customCalendarData else{return}
        
        let scheduleData = addScheduleDataModel.setAddScheduleData() //유저가 작성한 데이터들을 모두 취합한 유저의 스케줄 데이터.
        
        //유저가 작성한 데이터들을 가지고 fireStore에 저장할 캘린더 데이터로 가공.
        let calendarData = addScheduleDataService.setCalendarData(data: scheduleData)
        
        //데이터 저장시작.
        addScheduleDataService.updateCalendarDataToFirestore(dataDocumentID: data.documentID, calendarData: calendarData) { [weak self] result in
            
            DispatchQueue.main.async {
                switch result {
                    
                case .success(_):
                    CustomLoadingView.shared.stopLoading()
                    self?.presentingViewController?.presentingViewController?.dismiss(animated: true)
                    
                    
                case .failure(let err):
                    CustomLoadingView.shared.stopLoading()
                    self?.showAlert(title: "수정실패", message: err.localizedDescription)
                }
            }
        }
    }
    
    //데이터 삭제 alert
    private func deleteCalendarDataAlert() {
        let action = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.removeNotificationRequestIfNeeded()
            self?.handelDeleteCalendarData()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        showAlert(title: "삭제", message: "삭제하시겠습니까?", actions: [action, cancelAction])
    }
    
    //데이터 삭제
    private func handelDeleteCalendarData() {
        guard let documentID = editScheduleDataModel.customCalendarData?.documentID else{return}
        
        CustomLoadingView.shared.startLoading(to: 0)
        
        addScheduleDataService.deleteCalendarData(dataDocumentID: documentID){ [weak self] result in
            switch result {
                
            case .success(_):
                CustomLoadingView.shared.stopLoading()
                self?.presentingViewController?.presentingViewController?.dismiss(animated: true)
                
            case .failure(let err):
                CustomLoadingView.shared.stopLoading()
                self?.showAlert(title: "삭제 실패", message: err.localizedDescription)
            }
        }
    }
    
    private func removeNotificationRequestIfNeeded() {
        guard let data = editScheduleDataModel.customCalendarData else{return}
        notificationService.removeNotificationRequestIfNeeded(at: data.notification, with: data.titleText)
    }
}
