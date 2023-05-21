//
//  MyProfileView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class MyProfileView: UIView {
    //MARK: - Properties
    
    final let nameTextField = UITextField()
    final let idTextField = UITextField()
    
    final let codeContainerView = UIView()
    final let codeLabel = UILabel()
    final let codeChangeButton = UIButton()
    
    final let deleteAccountButton = UIButton()
    
    
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
      
        addSubview(nameTextField)
        nameTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0))
        nameTextField.leftViewMode = .always
        nameTextField.tintColor = .blackAndWhiteColor
        nameTextField.textColor = .blackAndWhiteColor
        nameTextField.returnKeyType = .done
        nameTextField.font = .boldSystemFont(ofSize: 16)
        nameTextField.placeholder = "닉네임을 입력하세요."
        nameTextField.clipsToBounds = true
        nameTextField.layer.cornerRadius = 7
        nameTextField.backgroundColor = .whiteAndCustomBlackColor
        nameTextField.clearButtonMode = .always
        nameTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
        
        addSubview(idTextField)
        idTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0))
        idTextField.leftViewMode = .always
        idTextField.isUserInteractionEnabled = false
        idTextField.textColor = .blackAndWhiteColor
        idTextField.font = .boldSystemFont(ofSize: 16)
        idTextField.clipsToBounds = true
        idTextField.layer.cornerRadius = 7
        idTextField.backgroundColor = .whiteAndCustomBlackColor
        idTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp_bottomMargin).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
        addSubview(codeContainerView)
        codeContainerView.backgroundColor = .whiteAndCustomBlackColor
        codeContainerView.layer.cornerRadius = 8
        codeContainerView.clipsToBounds = true
        codeContainerView.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp_bottomMargin).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
        codeContainerView.addSubview(codeLabel)
        codeLabel.customize(textColor: UIColor.blackAndWhiteColor!, backgroundColor: .clear, fontSize: 16, alignment: .left)
        codeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(10)
        }
        
        codeContainerView.addSubview(codeChangeButton)
        codeChangeButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        codeChangeButton.tintColor = .signatureColor
        codeChangeButton.snp.makeConstraints { make in
            make.centerY.equalTo(codeLabel)
            make.right.equalToSuperview().inset(15)
            make.width.height.equalTo(20)
        }
        
        addSubview(deleteAccountButton)
        deleteAccountButton.customize(title: "계정 삭제", titleColor: UIColor.customRedColor!, backgroundColor: UIColor.whiteAndCustomBlackColor!, fontSize: 15, cornerRadius: 7)
        deleteAccountButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
    }
}
