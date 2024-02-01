//
//  SpecificSettingViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/25.
//

import UIKit
import SnapKit

final class SpecificSetDateViewController: UIViewController {
    //MARK: - Properties
    final var specificSetDateDataModel = SpecificSetDateDataModel()
    final let specificSetDateView = SpecificSetDateView() //View
    
    final weak var specificSettingDelegate : SpecificSettingDelegate?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDatePicker()
        setupSubViews()
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        view.backgroundColor = .clear
        
        view.addSubview(specificSetDateView)
        specificSetDateView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(530)
        }
        
        specificSetDateView.introductionLabel.text = "시작: \(specificSetDateDataModel.setDate)"
        specificSetDateView.dateTitleLabel.text = "알림: \(specificSetDateDataModel.setDate)"
        
        specificSetDateView.datePicker.tintColor = UIColor(specificSetDateDataModel.selectedColor)
        specificSetDateView.doneButton.backgroundColor = UIColor(specificSetDateDataModel.selectedColor)
        
        specificSetDateView.doneButton.addTarget(self, action: #selector(doneButtonPressed(_:)), for: .touchUpInside)
        specificSetDateView.datePicker.addTarget(self, action: #selector(pickerValueChanged(_:)), for: .valueChanged)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        
        if touch.view == self.view { //터치한 뷰가 현재 뷰컨트롤러의 뷰인지 체크.
            self.dismiss(animated: true)
        }
    }
    
   
    
    //MARK: - PickerMethod
    @objc private func pickerValueChanged(_ sender : UIDatePicker) {

        switch specificSetDateDataModel.controlMode {

        case .date:
            specificSetDateDataModel.setDate = sender.date.convertDateToString(format: "yyyy년 MM월 dd일") 

        case .time:
            specificSetDateDataModel.setDate = sender.date.convertDateToString(format: "yyyy년 MM월 dd일 HH시 mm분")
        }
        
        specificSetDateView.dateTitleLabel.text = "알림: \(specificSetDateDataModel.setDate)"
        
    }
    
    //MARK: - ButtonMethod
    @objc private func doneButtonPressed(_ sender : UIButton) {
        specificSettingDelegate?.sendSetDate(date: specificSetDateDataModel.setDate)
        
        self.dismiss(animated: true)
    }
    
    
}

//MARK: - 유저가 설정한 날짜를 전달해줌.
protocol SpecificSettingDelegate : AnyObject {
    func sendSetDate(date: String)
}

//MARK: - 모드에 따른 데이트피커 옵션 설정 작업.
extension SpecificSetDateViewController {
    final func configureDatePicker() {
        switch specificSetDateDataModel.controlMode {
            
        case .date:
            configureDatePickerOptions()
            
        case .time:
            configureTimeDatePickerOptions()
        }
    }
    
    final func configureDatePickerOptions() {
        let selectedDate = specificSetDateDataModel.setDate.convertStringToDate(format: "yyyy년 MM월 dd일")
        
        specificSetDateView.datePicker.preferredDatePickerStyle = .inline
        specificSetDateView.datePicker.datePickerMode = .date
        specificSetDateView.datePicker.date = selectedDate
    }
    
    final func configureTimeDatePickerOptions() {
        let selectedDate = specificSetDateDataModel.setDate.convertStringToDate(format: "yyyy년 MM월 dd일 HH시 mm분")
        
        specificSetDateView.datePicker.preferredDatePickerStyle = .wheels
        specificSetDateView.datePicker.datePickerMode = .dateAndTime
        specificSetDateView.datePicker.date = selectedDate
    }
}
