//
//  SpecificSettingView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/25.
//

import UIKit
import SnapKit

final class SpecificSetDateView: UIView {
    //MARK: - Properties
    final let doneButton = UIButton()
    
    final let introductionLabel = UILabel()
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
        
        addSubview(introductionLabel)
        introductionLabel.configure(textColor: UIColor.blackAndWhiteColor!, backgroundColor: .clear, fontSize: 17, alignment: .center)
        introductionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(20)
        }
        
        addSubview(dateTitleLabel)
        dateTitleLabel.configure(textColor: UIColor.blackAndWhiteColor!, backgroundColor: .clear, fontSize: 17, alignment: .center)
        dateTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(introductionLabel.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(20)
        }
        
        addSubview(datePicker)
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(dateTitleLabel.snp_bottomMargin).offset(20)
            make.left.right.equalToSuperview().inset(15)
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
