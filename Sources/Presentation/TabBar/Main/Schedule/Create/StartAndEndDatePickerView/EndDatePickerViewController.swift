//
//  EndDatePickerViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/05/11.
//

import UIKit
import SnapKit

final class EndDatePickerViewController: UIViewController {
    //MARK: - Properties
    final var addScheduleDataModel = AddScheduleDataModel()
    final let startAndEndDatePickerView = StartAndEndDatePickerView() //View
    
    final weak var endDatePickerDelegate : EndDatePickerDelegate?
    
    final var eventDateTimeMode : EventDateAndTimeOption = .date //하루종일 모드인지, 시간설정 모드인지.
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDatePicker()
        setupSubViews()
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        view.backgroundColor = .clear
        
        view.addSubview(startAndEndDatePickerView)
        startAndEndDatePickerView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(470)
        }
        
        let color = UIColor(addScheduleDataModel.selectedColor)
        
        startAndEndDatePickerView.datePicker.tintColor = color
        startAndEndDatePickerView.doneButton.backgroundColor = color
        
        startAndEndDatePickerView.doneButton.addTarget(self, action: #selector(doneButtonPressed(_:)), for: .touchUpInside)
        startAndEndDatePickerView.datePicker.addTarget(self, action: #selector(pickerValueChanged(_:)), for: .valueChanged)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        
        if touch.view == self.view { //터치한 뷰가 현재 뷰컨트롤러의 뷰인지 체크.
            self.dismiss(animated: true)
        }
    }
    
    
    //MARK: - PickerMethod
    //설정한 날짜를 String형태로 변경해서 라벨에 넣어줌.
    @objc private func pickerValueChanged(_ sender : UIDatePicker) {
        var strDate = String()
        
        switch eventDateTimeMode {
            
        case .date:
            strDate = sender.date.convertDateToString(format: "yyyy년 MM월 dd일")
            
        case .time:
            strDate = sender.date.convertDateToString(format: "yyyy년 MM월 dd일 HH시 mm분") 
        }
        
        startAndEndDatePickerView.dateTitleLabel.text = strDate
    }
    
    //MARK: - ButtonMethod
    @objc private func doneButtonPressed(_ sender : UIButton) {
        guard let titleText = startAndEndDatePickerView.dateTitleLabel.text else{return}
        
        endDatePickerDelegate?.sendEndDate(date: titleText)
        self.dismiss(animated: true)
    }
    
}

//MARK: - 날짜 설정을 완료했을 때, 설정된 날짜를 전달.
protocol EndDatePickerDelegate : AnyObject {
    func sendEndDate(date: String)
}


//MARK: - 데이트피커 설정 작업.
extension EndDatePickerViewController {
    //하루종일 모드인지, 시간설정 모드인지 파악
    //해당 모드에 맞게 DatePicker의 옵션을 설정.
    private func configureDatePicker() {
        switch eventDateTimeMode {
            
        case .date:
            configureDatePickerOptions()
            
        case .time:
            configureTimeDatePickerOptions()
        }
    }
    
    //하루종일 모드일 때 데이트피커의 옵션을 설정.
    private func configureDatePickerOptions() {
        guard let titleText = startAndEndDatePickerView.dateTitleLabel.text else{return}
        
        let date = titleText.convertStringToDate(format: "yyyy년 MM월 dd일")
        
        startAndEndDatePickerView.datePicker.preferredDatePickerStyle = .inline
        startAndEndDatePickerView.datePicker.datePickerMode = .date
        startAndEndDatePickerView.datePicker.date = date
        startAndEndDatePickerView.datePicker.minimumDate = date
        startAndEndDatePickerView.datePicker.maximumDate = date.calculateMaximumDate() //우리 달력은 month를 기준으로 만들어지기 때문에 해당 달의 마지막 날까지만 이벤트 기간으로 설정할 수 있도록 지정해줌.
    }
    
    //시간설정 모드일 때 데이트피커의 옵션을 설정.
    private func configureTimeDatePickerOptions() {
        guard let titleText = startAndEndDatePickerView.dateTitleLabel.text else{return}
        
        let date = titleText.convertStringToDate(format: "yyyy년 MM월 dd일 HH시 mm분")
        
        startAndEndDatePickerView.datePicker.preferredDatePickerStyle = .wheels
        startAndEndDatePickerView.datePicker.datePickerMode = .dateAndTime
        startAndEndDatePickerView.datePicker.date = date
        startAndEndDatePickerView.datePicker.minimumDate = date
        startAndEndDatePickerView.datePicker.maximumDate = date.calculateMaximumTimeDate() //우리 달력은 month를 기준으로 만들어지기 때문에 해당 달의 마지막 날까지만 이벤트 기간으로 설정할 수 있음.
    }
}
