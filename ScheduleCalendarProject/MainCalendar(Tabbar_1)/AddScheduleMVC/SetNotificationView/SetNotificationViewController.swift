//
//  SetNotificationViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class SetNotificationViewController: UIViewController {
    //MARK: - Properties
    final var setNotificationDataModel = SetNotificationDataModel()
    final let setNotificationView = SetNotificationView() //View
    
    final weak var setNotificationDelegate : SetNotificationDelegate?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNotificationDataModel.notificationOptionArray = setNotificationDataModel.changeOptionTitleArray()
        setNotificationDataModel.optionIndex = setNotificationDataModel.setSelectedOptionIndex()
        setupSubViews()
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        view.backgroundColor = .clear
        
        view.addSubview(setNotificationView)
        setNotificationView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(500)
        }
        
        setNotificationView.titleLabel.text = setNotificationDataModel.selectedOption //타이틀 지정해줌.
        setNotificationView.optionsTableview.delegate = self
        setNotificationView.optionsTableview.dataSource = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        
        if touch.view == self.view { //터치한 뷰가 현재 뷰컨트롤러의 뷰인지 체크.
            self.dismiss(animated: true)
        }
    }
   
    
    //유저가 받을 알림의 시간을 직접 설정할 경우
    private func specificSetCellCliked() {
        let vc = SpecificSetDateViewController()
        
        vc.specificSettingDelegate = self //delegate 설정.
        vc.specificSetDateDataModel.controlMode = setNotificationDataModel.controlMode
        vc.specificSetDateDataModel.setDate = setNotificationDataModel.startDate //이벤트 시작날짜를 기본 값으로 전달.
        vc.specificSetDateDataModel.selectedColor = setNotificationDataModel.selectedColor
        
        self.present(vc, animated: true)
    }
    
}

//MARK: - Extension
extension SetNotificationViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setNotificationDataModel.notificationOptionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OptionTableViewCell.identifier, for: indexPath) as! OptionTableViewCell
        
        let option = setNotificationDataModel.notificationOptionArray[indexPath.row]
        cell.titleLabel.text = option
        
        if indexPath.row == setNotificationDataModel.optionIndex {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        cell.tintColor = UIColor(setNotificationDataModel.selectedColor)
        cell.selectionStyle = .none
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.whiteAndCustomBlackColor
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //cell을 클릭했을 때 애니메이션 구현
        triggerHapticFeedback() //유저에게 리액션을 주기 위한 미세한 진동음.
        
        
        let option = setNotificationDataModel.notificationOptionArray[indexPath.row]
        
        if indexPath.row == 4 { //유저가 설정 cell을 눌렀을 때
            let setDate = setNotificationDataModel.startDate //유저의 이벤트 시작날짜.
            
            setNotificationView.titleLabel.text = setDate //설정의 기본값을 유저의 이벤트 시작날짜로 둠.
            setNotificationDelegate?.selectedOption(option: setDate)
                     
            specificSetCellCliked()
            
        }else{
            setNotificationView.titleLabel.text = option
            setNotificationDelegate?.selectedOption(option: option)
        }
        
        setNotificationDataModel.optionIndex = indexPath.row
        tableView.reloadData()
    }
}

//MARK: - 유저가 선택한 알림설정 옵션을 전달해줌.
protocol SetNotificationDelegate : AnyObject {
    func selectedOption(option: String)
}

//MARK: - 유저가 알림이 울릴 날짜를 직접 설정했을 때, 설정한 날짜를 전달받음.
extension SetNotificationViewController : SpecificSettingDelegate {
    func sendSetDate(date: String) {
        self.setNotificationView.titleLabel.text = date
        self.setNotificationDelegate?.selectedOption(option: date)
    }
}
