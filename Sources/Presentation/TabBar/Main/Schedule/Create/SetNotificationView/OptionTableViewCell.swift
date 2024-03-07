//
//  OptionTableViewCell.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class OptionTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let identifier = "OptionTableViewCell"
    
    final let containerView = UIView()
    final let titleLabel = UILabel()
    
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
        
        addSubview(containerView)
        containerView.backgroundColor = .whiteAndCustomBlackColor
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(7)
            make.left.right.equalToSuperview()
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.configure(textColor: UIColor.blackAndWhiteColor!, backgroundColor: .clear, fontSize: 14, alignment: .left)
        titleLabel.sizeToFit()
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
        }
        
        
    }
    
    
}
