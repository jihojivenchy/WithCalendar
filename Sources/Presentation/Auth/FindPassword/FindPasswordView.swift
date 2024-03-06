//
//  FindPasswordView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class FindPasswordView: UIView {
    //MARK: - Properties
    
    final let titleLabel = UILabel()
    
    final let emailTextField = WCTextField()
    
    final let sendButton = UIButton()

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
        
        addSubview(titleLabel)
        titleLabel.text = "비밀번호 재 설정 메일을 받을 \n아이디(이메일)를 작성해주세요."
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .blackAndWhiteColor
        titleLabel.font = .boldSystemFont(ofSize: 25)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(90)
        }
        
        addSubview(emailTextField)
        emailTextField.tintColor = .blackAndWhiteColor
        emailTextField.textColor = .blackAndWhiteColor
        emailTextField.returnKeyType = .done
        emailTextField.font = .systemFont(ofSize: 18)
        emailTextField.placeholderFontScale = 0.8
        emailTextField.placeholder = "아이디(이메일 형식) 작성"
        emailTextField.placeholderColor = .signatureColor ?? UIColor()
        emailTextField.borderInactiveColor = .clear
        emailTextField.borderActiveColor = .signatureColor
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(40)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(70)
        }
        
        addSubview(sendButton)
        sendButton.customize(title: "보내기", titleColor: .white, backgroundColor: UIColor.signatureColor!, fontSize: 16, cornerRadius: 7)
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp_bottomMargin).offset(70)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(50)
        }
    }
}

