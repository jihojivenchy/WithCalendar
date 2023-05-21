//
//  WriteEmailView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit
import TextFieldEffects

final class WriteEmailView: UIView {
    //MARK: - Properties
    
    final let progressBar = UIProgressView()
    final let titleLabel = UILabel()
    
    final let emailTextField = HoshiTextField()
    
    final let nextButton = UIButton()

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
        progressBar.progress = 0.5
        progressBar.progressTintColor = .signatureColor
        progressBar.layer.cornerRadius = 2
        progressBar.clipsToBounds = true
        progressBar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(7)
        }
        
        addSubview(titleLabel)
        titleLabel.text = "로그인에 사용할 아이디를 \n작성해주세요"
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .blackAndWhiteColor
        titleLabel.font = .boldSystemFont(ofSize: 25)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp_bottomMargin).offset(15)
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
        
        addSubview(nextButton)
        nextButton.customize(title: "다음", titleColor: .white, backgroundColor: UIColor.signatureColor!, fontSize: 17, cornerRadius: 7)
        nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(60)
        }
    }
}

