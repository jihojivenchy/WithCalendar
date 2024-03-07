//
//  ParticipantFooterView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class ParticipantFooterView: UIView {
    //MARK: - Properties
    
    weak var participantDelegate : ParticipantFooterDelegate?
    
    final let addImageView = UIImageView()
    final let inviteLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubViews()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(footerTapped))
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        self.backgroundColor = .clear
        
        addSubview(addImageView)
        addImageView.image = UIImage(systemName: "plus.circle")
        addImageView.tintColor = .signatureColor
        addImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(15)
            make.left.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
        }
        
        addSubview(inviteLabel)
        inviteLabel.text = "눌러서 초대하기"
        inviteLabel.configure(textColor: UIColor.blackAndWhiteColor!, backgroundColor: .clear, fontSize: 16, alignment: .left)
        inviteLabel.snp.makeConstraints { make in
            make.centerY.equalTo(addImageView)
            make.left.equalTo(addImageView.snp_rightMargin).offset(15)
            make.height.equalTo(20)
        }
        
    }
    
    @objc private func footerTapped() {
        participantDelegate?.footerViewTapped()
    }
}

//class타입만 프로토콜을 준수할 수 있도록 만들며, delegate를 weak으로 선언하여 강력순환참조를 예방한다.
protocol ParticipantFooterDelegate : AnyObject {
    func footerViewTapped()
}
