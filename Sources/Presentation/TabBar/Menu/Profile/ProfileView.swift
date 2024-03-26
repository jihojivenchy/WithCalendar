//
//  ProfileView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 3/26/24.
//

import UIKit
import SnapKit

final class ProfileView: BaseView {
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름을 입력해주세요."
        textField.font = .boldSystemFont(ofSize: 16)
        textField.tintColor = .blackAndWhiteColor
        textField.textColor = .blackAndWhiteColor
        textField.layer.cornerRadius = 7
        textField.clipsToBounds = true
        textField.backgroundColor = .whiteAndCustomBlackColor
        textField.clearButtonMode = .always
        textField.addLeftPadding(with: 15)
        return textField
    }()
    
    private let idLabelContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteAndCustomBlackColor
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        return view
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .blackAndWhiteColor
        return label
    }()
    
    private let codeContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteAndCustomBlackColor
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        return view
    }()
    
    private let codeLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .blackAndWhiteColor
        return label
    }()
    
    let changeCodeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.tintColor = .signatureColor
        return button
    }()
    
    let deleteAccountButton: WCButton = {
        let button = WCButton(title: "계정 삭제")
        button.setTitleColor(.customRedColor, for: .normal)
        button.backgroundColor = .whiteAndCustomBlackColor
        return button
    }()
    
    override func configureLayouts() {
        addSubview(nameTextField)
        
        addSubview(idLabelContainer)
        idLabelContainer.addSubview(idLabel)
        
        addSubview(codeContainer)
        codeContainer.addSubview(codeLabel)
        codeContainer.addSubview(changeCodeButton)
    
        addSubview(deleteAccountButton)
        
        // 텍스트 필드
        nameTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
        idLabelContainer.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
    
        idLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
        }
        
        codeContainer.snp.makeConstraints { make in
            make.top.equalTo(idLabelContainer.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
        codeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(50)
        }
        
        changeCodeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
            make.width.height.equalTo(20)
        }
        
        deleteAccountButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(55)
        }
    }
}

extension ProfileView {
    func configure(user: User) {
        nameTextField.text = user.name
        idLabel.text = user.email
        codeLabel.text = "Code: \(user.code)"
    }
}
