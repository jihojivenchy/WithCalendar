//
//  SetNotificationView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class SetNotificationView: UIView {
    //MARK: - Properties
    
    final let titleLabel = UILabel()
    final let optionsTableview = UITableView(frame: .zero, style: .insetGrouped)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        self.backgroundColor = .customWhiteAndBlackColor
        self.layer.cornerRadius = 7
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.5
        
        addSubview(titleLabel)
        titleLabel.configure(textColor: UIColor.blackAndWhiteColor!, backgroundColor: .clear, fontSize: 17, alignment: .center)
        titleLabel.sizeToFit()
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        addSubview(optionsTableview)
        optionsTableview.register(OptionTableViewCell.self, forCellReuseIdentifier: OptionTableViewCell.identifier)
        optionsTableview.rowHeight = 65
        optionsTableview.backgroundColor = .clear
        optionsTableview.separatorStyle = .none
        optionsTableview.showsVerticalScrollIndicator = false
        optionsTableview.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(15)
            make.left.bottom.right.equalToSuperview()
        }

    }
}
