//
//  StartAndEndDatePickerView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class StartAndEndDatePickerView: UIView {
    //MARK: - Properties
    
    final let doneButton = UIButton()
    
    final let dateTitleLabel = UILabel()
    final let datePicker = UIDatePicker()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        self.backgroundColor = .customWhiteAndCustomBlackColor
        self.layer.cornerRadius = 7
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.5
        
        addSubview(dateTitleLabel)
        dateTitleLabel.customize(textColor: UIColor.blackAndWhiteColor!, backgroundColor: .clear, fontSize: 17, alignment: .center)
        dateTitleLabel.sizeToFit()
        dateTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        addSubview(datePicker)
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(dateTitleLabel.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(320)
        }
        
        addSubview(doneButton)
        doneButton.customize(title: "완료", titleColor: .white, backgroundColor: UIColor.signatureColor!, fontSize: 17, cornerRadius: 7)
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp_bottomMargin).offset(20)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(50)
        }
    }
}
