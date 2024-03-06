//
//  WritePasswordView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class WritePasswordView: UIView {
    //MARK: - Properties
    
    final let progressBar = UIProgressView()
    final let titleLabel = UILabel()
    
    final let pwTextField = WCTextField()
    final let pwCheckTextField = WCTextField()
    final let checkLabel = UILabel()
    
    final let registerButton = UIButton()

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
        
        addSubview(progressBar)
        progressBar.backgroundColor = .lightGray
        progressBar.progress = 0.75
        progressBar.progressTintColor = .signatureColor
        progressBar.layer.cornerRadius = 2
        progressBar.clipsToBounds = true
        progressBar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(7)
        }
        
        addSubview(titleLabel)
        titleLabel.text = "로그인에 사용할 비밀번호를 \n작성해주세요"
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .blackAndWhiteColor
        titleLabel.font = .boldSystemFont(ofSize: 25)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp_bottomMargin).offset(15)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(90)
        }
        
        addSubview(pwTextField)
        pwTextField.tintColor = .blackAndWhiteColor
        pwTextField.textColor = .blackAndWhiteColor
        pwTextField.returnKeyType = .done
        pwTextField.isSecureTextEntry = true
        pwTextField.font = .systemFont(ofSize: 18)
        pwTextField.placeholderFontScale = 0.8
        pwTextField.placeholder = "비밀번호(6자 이상) 작성"
        pwTextField.placeholderColor = .signatureColor ?? UIColor()
        pwTextField.borderInactiveColor = .clear
        pwTextField.borderActiveColor = .signatureColor
        pwTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(20)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(70)
        }
        
        addSubview(pwCheckTextField)
        pwCheckTextField.tintColor = .blackAndWhiteColor
        pwCheckTextField.textColor = .blackAndWhiteColor
        pwCheckTextField.returnKeyType = .done
        pwCheckTextField.isSecureTextEntry = true
        pwCheckTextField.font = .systemFont(ofSize: 18)
        pwCheckTextField.placeholderFontScale = 0.8
        pwCheckTextField.placeholder = "비밀번호 확인"
        pwCheckTextField.placeholderColor = .signatureColor ?? UIColor()
        pwCheckTextField.borderInactiveColor = .clear
        pwCheckTextField.borderActiveColor = .signatureColor
        pwCheckTextField.snp.makeConstraints { make in
            make.top.equalTo(pwTextField.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(70)
        }
        
        addSubview(checkLabel)
        checkLabel.customize(textColor: UIColor.customRedColor!, backgroundColor: .clear, fontSize: 12, alignment: .left)
        checkLabel.snp.makeConstraints { make in
            make.top.equalTo(pwCheckTextField.snp_bottomMargin).offset(20)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(20)
        }
        
        addSubview(registerButton)
        registerButton.customize(title: "회원가입", titleColor: .white, backgroundColor: UIColor.signatureColor!, fontSize: 17, cornerRadius: 7)
        registerButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(60)
        }
    }
}

