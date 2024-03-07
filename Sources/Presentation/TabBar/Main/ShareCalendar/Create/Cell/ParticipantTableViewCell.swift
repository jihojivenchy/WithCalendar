//
//  ParticipantTableViewCell.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class ParticipantTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let identifier = "ParticipantTableViewCell"
    
    final let containerView = UIView()
    final let personImageView = UIImageView()
    final let nameLabel = UILabel()
    final let crownImageView = UIImageView()
    
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
            make.left.right.equalToSuperview().inset(15)
        }
        
        containerView.addSubview(personImageView)
        personImageView.image = UIImage(systemName: "person.circle")
        personImageView.tintColor = .blackAndWhiteColor
        personImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
            make.width.height.equalTo(22)
        }
        
        containerView.addSubview(nameLabel)
        nameLabel.configure(textColor: UIColor.blackAndWhiteColor!, backgroundColor: .clear, fontSize: 15, alignment: .left)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(personImageView)
            make.left.equalTo(personImageView.snp_rightMargin).offset(15)
            make.height.equalTo(20)
        }
        
        containerView.addSubview(crownImageView)
        crownImageView.isHidden = true
        crownImageView.image = UIImage(systemName: "crown")
        crownImageView.tintColor = .signatureColor
        crownImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
            make.width.height.equalTo(15)
        }
    }
    
    
}
