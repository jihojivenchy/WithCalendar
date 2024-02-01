//
//  DateModeAndTimeModeTableViewCell.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class DateTimeModeSelectionTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let identifier = "DateTimeModeSelectionTableViewCell"
    
    final weak var selectionDelegate : DateTimeModeSelectionDelegate?
    
    final let modeControl = UISegmentedControl(items: ["하루종일", "시간설정"])
    
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
        
        addSubview(modeControl)
        modeControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        modeControl.selectedSegmentIndex = 0
        modeControl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(35)
        }
    }
    
    @objc private func segmentedControlValueChanged(_ sender : UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            self.selectionDelegate?.changeDateMode()
            
        }else{
            self.selectionDelegate?.changeTimeMode()
        }
        
    }
}

protocol DateTimeModeSelectionDelegate : AnyObject {
    func changeTimeMode()
    func changeDateMode()
}
