//
//  NotificationView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class NotificationView: UIView {
    //MARK: - Properties
    
    final let goToNotiCenterButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        self.backgroundColor = .clear
        
        addSubview(goToNotiCenterButton)
        goToNotiCenterButton.customize(title: "", titleColor: UIColor.blackAndWhiteColor!, backgroundColor: UIColor.whiteAndCustomBlackColor!, fontSize: 17, cornerRadius: 7)
        goToNotiCenterButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
    }
}
