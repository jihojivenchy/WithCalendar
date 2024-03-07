//
//  AddScheduleTableViewCell.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class AddScheduleTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let identifier = "AddScheduleTableViewCell"
    
    final let actionImageView = UIImageView()
    final let titleLabel = UILabel()
    final let subTitleLabel = UILabel()
    
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
        
        
        addSubview(actionImageView)
        actionImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
            make.width.height.equalTo(20)
        }
        
        addSubview(titleLabel)
        titleLabel.configure(textColor: UIColor.blackAndWhiteColor!, backgroundColor: .clear, fontSize: 14, alignment: .left)
        titleLabel.sizeToFit()
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(actionImageView)
            make.left.equalTo(actionImageView.snp_rightMargin).offset(20)
        }
        
        addSubview(subTitleLabel)
        subTitleLabel.configure(textColor: UIColor.blackAndWhiteColor!, backgroundColor: .clear, fontSize: 12, alignment: .left)
        subTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(actionImageView)
            make.left.equalTo(titleLabel.snp_rightMargin).offset(70)
            make.right.equalToSuperview().inset(50)
        }
    }
    
    
}
