//
//  MenuCell.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 3/21/24.
//

import UIKit
import SnapKit

final class MenuCell: BaseTableViewCell {
    // MARK: - UI
    private let backgroundContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteAndCustomBlackColor
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private let menuImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .blackAndWhiteColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blackAndWhiteColor
        label.font = .boldSystemFont(ofSize: 16)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Layouts
    override func configureLayouts() {
        addSubview(backgroundContainer)
        backgroundContainer.addSubview(menuImageView)
        backgroundContainer.addSubview(titleLabel)
        backgroundContainer.addSubview(arrowImageView)
        
        // 컨테이너
        backgroundContainer.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(7)
            make.left.right.equalToSuperview().inset(10)
        }
        
        menuImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
            make.width.height.equalTo(22)
        }
    
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(menuImageView.snp.right).offset(11)
            make.right.equalToSuperview().inset(100)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(10)
            make.width.equalTo(20)
            make.height.equalTo(17)
        }
    }
}

// MARK: - Configuration
extension MenuCell {
    func configure(menuItem: MenuItem) {
        titleLabel.text = menuItem.title
        menuImageView.image = UIImage(systemName: menuItem.imageName)
    }
}
