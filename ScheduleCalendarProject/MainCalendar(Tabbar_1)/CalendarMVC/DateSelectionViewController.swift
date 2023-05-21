//
//  DateSelectionViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/05/20.
//

import UIKit
import SnapKit

final class DateSelectionViewController: UIViewController {
    //MARK: - Properties
    final let startAndEndDatePickerView = StartAndEndDatePickerView() //View
    final weak var dateSelectionDelegate : DateSelectionDelegate?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubViews()
        configureDatePickerOptions()
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
        
        startAndEndDatePickerView.doneButton.addTarget(self, action: #selector(doneButtonPressed(_:)), for: .touchUpInside)
        startAndEndDatePickerView.datePicker.addTarget(self, action: #selector(pickerValueChanged(_:)), for: .valueChanged)
        
    }
    
    private func configureDatePickerOptions() {
        startAndEndDatePickerView.datePicker.tintColor = .signatureColor
        startAndEndDatePickerView.datePicker.preferredDatePickerStyle = .inline
        startAndEndDatePickerView.datePicker.datePickerMode = .date
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        
        if touch.view == self.view { //터치한 뷰가 현재 뷰컨트롤러의 뷰인지 체크.
            self.dismiss(animated: true)
        }
    }
    
    //MARK: - PickerMethod
    @objc private func pickerValueChanged(_ sender : UIDatePicker) {
        let dateString = sender.date.convertDateToString(format: "yyyy년 MM월 dd일")
        startAndEndDatePickerView.dateTitleLabel.text = dateString
    }
    
    //MARK: - ButtonMethod
    @objc private func doneButtonPressed(_ sender : UIButton) {
        guard let titleText = startAndEndDatePickerView.dateTitleLabel.text else{return}
        
        dateSelectionDelegate?.sendDate(date: titleText.convertStringToDate(format: "yyyy년 MM월 dd일"))
        self.dismiss(animated: true)
    }
    
}

//MARK: - 날짜 설정을 완료했을 때, 설정된 날짜를 전달.
protocol DateSelectionDelegate : AnyObject {
    func sendDate(date: Date)
}
