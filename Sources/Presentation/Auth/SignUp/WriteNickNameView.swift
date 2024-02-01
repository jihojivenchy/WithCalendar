//
//  WriteNickNameView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//


import UIKit
import SnapKit

final class WriteNickNameView: UIView {
    //MARK: - Properties
    
    final let progressBar = UIProgressView()
    final let titleLabel = UILabel()
    
    final let nickNameTextField = HoshiTextField()
    
    final let checkBoxButton = UIButton()
    
    final let agreeLabel = UILabel()
    final let showContractButton = UIButton()
    
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
        progressBar.progress = 0.25
        progressBar.progressTintColor = .signatureColor
        progressBar.layer.cornerRadius = 2
        progressBar.clipsToBounds = true
        progressBar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(7)
        }
        
        addSubview(titleLabel)
        titleLabel.text = "닉네임 작성과 함께 약관에 \n동의해주세요"
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .blackAndWhiteColor
        titleLabel.font = .boldSystemFont(ofSize: 25)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp_bottomMargin).offset(15)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(90)
        }
        
        addSubview(nickNameTextField)
        nickNameTextField.tintColor = .blackAndWhiteColor
        nickNameTextField.textColor = .blackAndWhiteColor
        nickNameTextField.returnKeyType = .done
        nickNameTextField.font = .systemFont(ofSize: 18)
        nickNameTextField.placeholderFontScale = 0.8
        nickNameTextField.placeholder = "닉네임 입력"
        nickNameTextField.placeholderColor = .signatureColor ?? UIColor()
        nickNameTextField.borderInactiveColor = .clear
        nickNameTextField.borderActiveColor = .signatureColor
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(40)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(70)
        }
        
        addSubview(checkBoxButton)
        checkBoxButton.layer.borderWidth = 1
        checkBoxButton.layer.borderColor = UIColor.signatureColor?.cgColor
        checkBoxButton.setImage(UIImage(systemName: "checkmark"), for: .selected)
        checkBoxButton.tintColor = .signatureColor
        checkBoxButton.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp_bottomMargin).offset(70)
            make.left.equalToSuperview().inset(15)
            make.width.height.equalTo(25)
        }
        
        addSubview(agreeLabel)
        agreeLabel.text = "개인정보 이용 및 수집 동의(필수)"
        agreeLabel.textColor = .blackAndWhiteColor
        agreeLabel.font = .systemFont(ofSize: 15)
        agreeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(checkBoxButton)
            make.left.equalTo(checkBoxButton.snp_rightMargin).offset(15)
            make.height.equalTo(30)
        }
        
        addSubview(showContractButton)
        showContractButton.setTitle("(약관 보기)", for: .normal)
        showContractButton.setTitleColor(.darkGray, for: .normal)
        showContractButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        showContractButton.snp.makeConstraints { make in
            make.centerY.equalTo(agreeLabel)
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(30)
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

