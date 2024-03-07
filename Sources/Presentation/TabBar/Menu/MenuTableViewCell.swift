//
//  MenuTableViewCell.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class MenuTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let identifier = "MenuTableViewCell"
    
    final let containerView = UIView()
    final let actionImageView = UIImageView()
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
            make.top.bottom.equalToSuperview().inset(5)
            make.left.right.equalToSuperview()
        }
        
        containerView.addSubview(actionImageView)
        actionImageView.tintColor = .blackAndWhiteColor
        actionImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
            make.width.height.equalTo(22)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.configure(textColor: UIColor.blackAndWhiteColor!, backgroundColor: .clear, fontSize: 16, alignment: .left)
        titleLabel.sizeToFit()
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(actionImageView)
            make.left.equalTo(actionImageView.snp_rightMargin).offset(20)
        }
    }
    
    
}
