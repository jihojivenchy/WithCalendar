//
//  ScheduleTableViewCell.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit
import UIColorHexSwift

final class ScheduleTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let identifier = "ScheduleTableViewCell"
    
    final let scheduleColorView = UIView()
    final let scheduleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        self.backgroundColor = .clear
        
        addSubview(scheduleColorView)
        scheduleColorView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(1.5)
        }
        
        scheduleColorView.addSubview(scheduleLabel)
        scheduleLabel.textColor = .blackAndWhiteColor
        scheduleLabel.textAlignment = .center
        scheduleLabel.clipsToBounds = true
        scheduleLabel.layer.cornerRadius = 2
        scheduleLabel.lineBreakMode = .byCharWrapping
        scheduleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(2)
            make.top.bottom.equalToSuperview().inset(1)
        }
    }
    
    final func configureCalendarDataToUI(with data: CustomCalendarData) {
        scheduleLabel.textColor = UIColor(data.selectedColor).customContrastingColor()
        scheduleLabel.backgroundColor = UIColor(data.labelColor)
        
        scheduleColorView.backgroundColor = UIColor(data.backGrondColor)
        
        if data.count == 0 {
            self.scheduleLabel.text = data.titleText
            
        }else{
            handleDataSequence(with: data)
        }
        
    }
    
    private func handleDataSequence(with data: CustomCalendarData) {
        
        switch data.sequence {
            
        case "first":
            scheduleLabel.text = data.titleText
            scheduleColorView.clipsToBounds = true
            scheduleColorView.layer.cornerRadius = 2
            scheduleColorView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            
        case "last":
            scheduleLabel.text = ""
            scheduleColorView.clipsToBounds = true
            scheduleColorView.layer.cornerRadius = 2
            scheduleColorView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            
        default:
            scheduleLabel.text = ""
            scheduleColorView.clipsToBounds = false
            scheduleColorView.layer.cornerRadius = 0
        }
    }
    
}
