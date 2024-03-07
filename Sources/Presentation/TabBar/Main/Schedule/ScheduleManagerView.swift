//
//  ScheduleManagerView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class ScheduleManagerView: UIView {
    //MARK: - Properties
    
    final let dateLabel = UILabel()
    final let lunarDateButton = UIButton() //음력보여주기
    final let scheduleTableView = UITableView(frame: .zero, style: .plain)
    final let addScheduleButton = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        self.backgroundColor = .whiteAndCustomBlackColor
        self.layer.cornerRadius = 7
        self.clipsToBounds = true
        
        addSubview(dateLabel)
        dateLabel.configure(textColor: UIColor.blackAndWhiteColor!, backgroundColor: .clear, fontSize: 17, alignment: .center)
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        addSubview(lunarDateButton)
        lunarDateButton.setTitle("(음력 보기)", for: .normal)
        lunarDateButton.setTitleColor(.darkGray, for: .normal)
        lunarDateButton.titleLabel?.font = .boldSystemFont(ofSize: 13)
        lunarDateButton.sizeToFit()
        lunarDateButton.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp_bottomMargin).offset(13)
            make.centerX.equalToSuperview()
        }
        
        addSubview(scheduleTableView)
        scheduleTableView.register(ScheduleManagerTableViewCell.self, forCellReuseIdentifier: ScheduleManagerTableViewCell.identifier)
        scheduleTableView.rowHeight = 65
        scheduleTableView.backgroundColor = .clear
        scheduleTableView.snp.makeConstraints { make in
            make.top.equalTo(lunarDateButton.snp_bottomMargin).offset(20)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(70)
        }
        
        addSubview(addScheduleButton)
        addScheduleButton.customize(title: "할 일을 추가해주세요.", titleColor: UIColor.blackAndWhiteColor!, backgroundColor: UIColor.customWhiteAndLightGrayColor!, fontSize: 15, cornerRadius: 7)
        addScheduleButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(15)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
    }
}
