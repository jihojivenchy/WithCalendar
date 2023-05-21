//
//  LoginView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class LoginView: UIView {
    //MARK: - Properties
    final let titleLabel = UILabel()
    
    final let containerView = UIView()
    final let idTextField = UITextField()
    final let pwTextField = UITextField()
    
    final let loginButton = UIButton()
    final let findPWButton = UIButton()
    
    final let registerLabel = UILabel()
    final let registerButton = UIButton()
    
    final let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    
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
        titleLabel.text = "With Calendar"
        titleLabel.customize(textColor: UIColor.blackAndWhiteColor!, backgroundColor: .clear, fontSize: 32, alignment: .center)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(40)
        }
        
        addSubview(containerView)
        containerView.backgroundColor = .clear
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 7
        containerView.layer.borderColor = UIColor.darkGray.cgColor
        containerView.layer.borderWidth = 1
        containerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(120)
        }
        
        containerView.addSubview(idTextField)
        idTextField.customize(placeHolder: "아이디를 입력해주세요.", textColor: UIColor.blackAndWhiteColor!, tintColor: UIColor.blackAndWhiteColor!, fontSize: 16, backgroundColor: .clear)
        idTextField.clearButtonMode = .whileEditing
        idTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.left.right.equalToSuperview().inset(17)
            make.height.equalTo(55)
        }
        
        containerView.addSubview(pwTextField)
        pwTextField.customize(placeHolder: "비밀번호를 입력해주세요.", textColor: UIColor.blackAndWhiteColor!, tintColor: UIColor.blackAndWhiteColor!, fontSize: 16, backgroundColor: .clear)
        pwTextField.clearButtonMode = .whileEditing
        pwTextField.isSecureTextEntry = true
        textFieldBorderCustom(target: pwTextField) //위쪽에만 border를 넣어주기 위해.
        pwTextField.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(5)
            make.left.right.equalToSuperview().inset(17)
            make.height.equalTo(55)
        }
        
        
        addSubview(findPWButton)
        findPWButton.setTitle("PW 찾기", for: .normal)
        findPWButton.setTitleColor(.signatureColor, for: .normal)
        findPWButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        findPWButton.setUnderLine()
        findPWButton.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp_bottomMargin).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        addSubview(loginButton)
        loginButton.customize(title: "로그인", titleColor: .white, backgroundColor: UIColor.signatureColor!, fontSize: 16, cornerRadius: 7)
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(findPWButton.snp_bottomMargin).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(60)
        }
        
        addSubview(registerLabel)
        registerLabel.customize(textColor: .darkGray, backgroundColor: .clear, fontSize: 15, alignment: .center)
        registerLabel.text = "아직 계정이 없으신가요?"
        registerLabel.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp_bottomMargin).offset(80)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(20)
        }
        
        addSubview(registerButton)
        registerButton.setTitle("회원가입", for: .normal)
        registerButton.setTitleColor(.signatureColor, for: .normal)
        registerButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        registerButton.setUnderLine()
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(registerLabel.snp_bottomMargin).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        
        addSubview(loadingIndicator)
        loadingIndicator.color = .signatureColor
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    
    private func textFieldBorderCustom(target : UITextField) {
        
        let border = UIView()
        border.backgroundColor = .darkGray
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: target.frame.width, height: 1)
        
        target.addSubview(border)
    }
}
