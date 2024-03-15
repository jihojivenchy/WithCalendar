//
//  ScheduleManagerViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit
import UIColorHexSwift

final class ScheduleManagerViewController: UIViewController {
    //MARK: - Properties
    final var scheduleManagerDataModel = ScheduleManagerDataModel()
    final let scheduleManagerDataService = ScheduleManagerDataService()
    final let scheduleManagerView = ScheduleManagerView() //View
    private let loadingView = WCLoadingView()
    
    final var cellFrame: CGRect? //내가 누른 cell의 위치와 크기를 나타냄.
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
    }

    //MARK: - ViewMethod
    
    private func setupSubViews() {
//        self.isModalInPresentation = true //스크롤 다운으로 view의 dismiss를 하지 못하게.
        view.backgroundColor = .darkGray.withAlphaComponent(0.2)
        
        view.addSubview(scheduleManagerView)
        scheduleManagerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.81)
            make.height.equalToSuperview().multipliedBy(0.64)
        }
        
        scheduleManagerView.scheduleTableView.dataSource = self
        scheduleManagerView.scheduleTableView.delegate = self
        
        scheduleManagerView.addScheduleButton.addTarget(self, action: #selector(showAddScheduleView(_:)), for: .touchUpInside)
        scheduleManagerView.lunarDateButton.addTarget(self, action: #selector(lunarDateButtonPressed(_:)), for: .touchUpInside)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        
        if touch.view == self.view { //터치한 뷰가 현재 뷰컨트롤러의 뷰인지 체크.
            self.dismissAnimation()
        }
    }
    
    private func dismissAnimation() {
        UIView.animate(withDuration: 0.4, animations: {
            self.scheduleManagerView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            self.scheduleManagerView.center = CGPoint(x: self.cellFrame!.midX, y: self.cellFrame!.midY) //유저가 선택한 cell의 좌표로 scheduleManagerView의 중심점을 이동시킨다.
            self.scheduleManagerView.alpha = 0.0
            
        }, completion: { _ in
            self.dismiss(animated: false)
        })
    }
    
    //MARK: - ButtonMethod
    @objc private func showAddScheduleView(_ sender : UIButton) {
        guard let selectedDate = scheduleManagerView.dateLabel.text else{return}
        
        let vc = AddScheduleViewController()
        vc.modalPresentationStyle = .pageSheet
        vc.addScheduleDataModel.subTitleArray[0] = selectedDate //현재 선택된 날짜정보를 보내줌. 시작
        vc.addScheduleDataModel.subTitleArray[1] = selectedDate //현재 선택된 날짜정보를 보내줌. 종료
        self.present(vc, animated: true)
    }
    
    @objc private func lunarDateButtonPressed(_ sender: UIButton) {
        handleFetchLunarData()
    }
}

//MARK: - Extension
extension ScheduleManagerViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleManagerDataModel.customCalendarDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleManagerTableViewCell.identifier, for: indexPath) as! ScheduleManagerTableViewCell
        
        let data = scheduleManagerDataModel.customCalendarDataArray[indexPath.row]
        configureCell(cell, with: data)
        
        cell.indexRow = indexPath.row
        cell.scheduleMangerCellDelegate = self
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EditScheduleViewController()
        vc.modalPresentationStyle = .pageSheet
        vc.editScheduleDataModel.customCalendarData = scheduleManagerDataModel.customCalendarDataArray[indexPath.row]
        self.present(vc, animated: true)
    }
}

//MARK: - Cell에 데이터를 뿌리는 작업.
extension ScheduleManagerViewController {
    private func configureCell(_ cell: ScheduleManagerTableViewCell, with data: CustomCalendarData) {
        cell.titleLabel.text = data.titleText
        cell.titleColorView.backgroundColor = UIColor(data.selectedColor)
        cell.selectionStyle = .none
        
        //detailMemo가 있다면 데이터를 넣어주기.
        cell.subTitleLabel.text = data.detailMemo.isEmpty ? formatSubtitle(from: data) : " \(data.detailMemo)"
        
        //당일 스케줄, 하루종일 모드, detailMemo까지 없다면 Subtitle이 없는 레이아웃으로 보여줌.
        cell.mode = (data.count == 0 && data.controlIndex == 0 && data.detailMemo.isEmpty) ? 1 : 0
        
    }
    
    //SubTitle에 들어갈 data를 좀 더 간략하게 표현해주기 위해.
    private func formatSubtitle(from data: CustomCalendarData) -> String {
        let customStartDate = data.startDate.getSuffix(8) //ex) "05월 05일"
        let customEndDate = data.endDate.getSuffix(8)
        
        return "\(customStartDate) ~ \(customEndDate)"
    }
}

extension ScheduleManagerViewController : ScheduleManagerCellDelegate{
    func sendIndexRow(indexRow: Int) {
        //공휴일 데이터인지 체크하고, 공휴일데이터가 아니라면 삭제경고 진행.
        let color = scheduleManagerDataModel.customCalendarDataArray[indexRow].selectedColor
        guard checkHolidayData(color: color) else{return}
        
        deleteCalendarDataAlert(at: indexRow)
    }
    
    private func deleteCalendarDataAlert(at indexRow: Int) {
        let action = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.handleDeleteCalendarData(at: indexRow)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        showAlert(title: "삭제하기", message: "", actions: [action, cancelAction])
    }
    
    //캘린더 삭제작업에 대한 후처리.
    private func handleDeleteCalendarData(at indexRow: Int) {
        let documentID = scheduleManagerDataModel.customCalendarDataArray[indexRow].documentID
        
        loadingView.startLoading()
        
        scheduleManagerDataService.deleteCalendarData(dataDocumentID: documentID){ [weak self] result in
            switch result {
                
            case .success(_):
                self?.loadingView.stopLoading()
                self?.deleteNotification(at: indexRow)
                self?.reloadDataAndTableview(at: indexRow)
                
            case .failure(let err):
                self?.loadingView.stopLoading()
                self?.showAlert(title: "삭제 실패", message: err.localizedDescription)
            }
        }
    }
    
    private func reloadDataAndTableview(at indexRow: Int) {
        scheduleManagerDataModel.customCalendarDataArray.remove(at: indexRow)
        scheduleManagerView.scheduleTableView.reloadData()
    }
    
    private func deleteNotification(at indexRow: Int) {
        let identifier = scheduleManagerDataModel.customCalendarDataArray[indexRow].titleText
        
        let notificationService = NotificationService()
        notificationService.removeNotificationRequest(with: identifier)
    }
}

extension ScheduleManagerViewController {
    private func handleFetchLunarData() {
        guard let text = scheduleManagerView.dateLabel.text else{return}
        let (year, month, day) = text.splitDateComponents()
        
        loadingView.startLoading()
        
        let api = LunarAPI()

        api.fetchLunarData(year: year, month: month, day: day) { [weak self] result in
            guard let self = self else{return}
            loadingView.stopLoading()
            
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let lunarDate):
                    self.handleSuccess(lunarDate)
                    
                case .failure(let err):
                    self.handleFailure(err)
                }
            }
        }
    }

    private func handleSuccess(_ lunarDate: LunarDate) {
        let title = "음력 \(lunarDate.lunYear)년 \(lunarDate.lunMonth)월 \(lunarDate.lunDay)일"
        self.scheduleManagerView.lunarDateButton.setTitle(title, for: .normal)
    }
    
    private func handleFailure(_ err : FetchLunarDataError) {
        
        switch err {
        case .invalidateDataError:
            showAlert(title: "가져오기 실패", message: "데이터가 없습니다.")
            
        case .failedURLRequest(let actualError):
            showAlert(title: "네트워킹 실패", message: actualError)
        }
        
    }
}
