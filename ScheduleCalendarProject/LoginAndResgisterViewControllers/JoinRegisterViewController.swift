//
//  UserRegisterViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/11/03.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

class JoinRegisterViewController: UIViewController {
    
    //MARK: - Properties
    private let db = Firestore.firestore()
    
    private let dismissButton = UIButton()
    
    private let logoLabel = UILabel()
    
    private let nickNameTextField = UITextField()
    
    private let idTextField = UITextField()
    
    private let passwordTextField = UITextField()
    
    private let registerButton = UIButton()
    
    private let checkBoxButton = UIButton()
    
    private var checkSign : Bool = false
    
    private let agreeLabel = UILabel()
    private let infomationButton = UIButton()
    
    private lazy var indicatorView : UIActivityIndicatorView = {
       let ia = UIActivityIndicatorView()
        ia.hidesWhenStopped = true
        ia.style = .large
        
        return ia
    }()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        
    }
    
    //MARK: - ViewMethod
    
    private func addSubViews() {
        view.backgroundColor = .customGray
        
        view.addSubview(dismissButton)
        dismissButton.setBackgroundImage(UIImage(systemName: "x.circle"), for: .normal)
        dismissButton.tintColor = .black
        dismissButton.addTarget(self, action: #selector(dismissButtonPressed(_:)), for: .touchUpInside)
        dismissButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.left.equalTo(view).inset(10)
            make.width.height.equalTo(30)
        }
        
        view.addSubview(logoLabel)
        logoLabel.text = "With Plan"
        logoLabel.textColor = .black
        logoLabel.textAlignment = .center
        logoLabel.font = .boldSystemFont(ofSize: 35)
        logoLabel.snp.makeConstraints { make in
            make.top.equalTo(dismissButton.snp_bottomMargin).offset(15)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(70)
            
        }
        
        view.addSubview(nickNameTextField)
        nickNameTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0)) //여백주기
        nickNameTextField.leftViewMode = .always
        nickNameTextField.clearButtonMode = .always
        nickNameTextField.backgroundColor = .white
        nickNameTextField.placeholder = "닉네임"
        nickNameTextField.clipsToBounds = true
        nickNameTextField.layer.borderWidth = 1
        nickNameTextField.layer.cornerRadius = 10
        nickNameTextField.layer.borderColor = UIColor.darkGray.cgColor
        nickNameTextField.textColor = .black
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(logoLabel.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(50)
        }
        
        view.addSubview(idTextField)
        idTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0)) //여백주기
        idTextField.leftViewMode = .always
        idTextField.clearButtonMode = .always
        idTextField.backgroundColor = .white
        idTextField.placeholder = "아이디(이메일 형식)"
        idTextField.clipsToBounds = true
        idTextField.layer.borderWidth = 1
        idTextField.layer.cornerRadius = 10
        idTextField.layer.borderColor = UIColor.darkGray.cgColor
        idTextField.textColor = .black
        idTextField.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp_bottomMargin).offset(18)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(50)
        }
        
        view.addSubview(passwordTextField)
        passwordTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0)) //여백주기
        passwordTextField.leftViewMode = .always
        passwordTextField.clearButtonMode = .always
        passwordTextField.backgroundColor = .white
        passwordTextField.placeholder = "비밀번호(6글자 이상)"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.clipsToBounds = true
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.layer.borderColor = UIColor.darkGray.cgColor
        passwordTextField.textColor = .black
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp_bottomMargin).offset(18)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(50)
        }
        
        view.addSubview(checkBoxButton)
        checkBoxButton.layer.borderWidth = 1
        checkBoxButton.layer.borderColor = UIColor.systemBlue.cgColor
        checkBoxButton.setImage(UIImage(systemName: "checkmark"), for: .selected)
        checkBoxButton.tintColor = .systemBlue
        checkBoxButton.addTarget(self, action: #selector(checkBoxPressed(_:)), for: .touchUpInside)
        checkBoxButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp_bottomMargin).offset(70)
            make.left.equalToSuperview().inset(15)
            make.width.height.equalTo(23)
        }
        
        view.addSubview(agreeLabel)
        agreeLabel.text = "개인정보 이용 및 수집 동의(필수)"
        agreeLabel.textColor = .black
        agreeLabel.font = .systemFont(ofSize: 15)
        agreeLabel.sizeToFit()
        agreeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(checkBoxButton)
            make.left.equalTo(checkBoxButton.snp_rightMargin).offset(15)
        }
        
        view.addSubview(infomationButton)
        infomationButton.setTitle("(약관 보기)", for: .normal)
        infomationButton.setTitleColor(.darkGray, for: .normal)
        infomationButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        infomationButton.addTarget(self, action: #selector(informationButtonPressed(_:)), for: .touchUpInside)
        infomationButton.sizeToFit()
        infomationButton.snp.makeConstraints { make in
            make.centerY.equalTo(agreeLabel)
            make.right.equalToSuperview().inset(15)
        }
        
        view.addSubview(registerButton)
        registerButton.setTitle("가입하기", for: .normal)
        registerButton.backgroundColor = .systemBlue
        registerButton.setTitleColor(.black, for: .normal)
        registerButton.layer.cornerRadius = 10
        registerButton.clipsToBounds = true
        registerButton.addTarget(self, action: #selector(registerButtonPressed(_:)), for: .touchUpInside)
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(checkBoxButton.snp_bottomMargin).offset(40)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(55)
        }
        
        view.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.width.height.equalTo(100)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){ //화면 터치 시 키보드내려감
        self.view.endEditing(true)
        
    }
    
    private func setAlert(message : String, secondMessage : String) {
        let alert = UIAlertController(title: message, message: secondMessage, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "확인", style: .default) { action in
            if message == "가입완료" {
                self.dismiss(animated: true)
            }
        }
        
        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - ButtonMethod
    @objc private func dismissButtonPressed(_ sender : UIButton) {
        self.dismiss(animated: true)
        
    }
    
    @objc private func checkBoxPressed(_ sender : UIButton){
        sender.isSelected.toggle()
        if sender.isSelected == true{
            checkSign = true
        }else{
            checkSign = false
        }
    }
    
    @objc private func informationButtonPressed(_ sender : UIButton){
        let centerURL = "https://iosjiho.tistory.com/51"
        let contractURL = NSURL(string: centerURL)
        
        if UIApplication.shared.canOpenURL(contractURL! as URL){
            
            UIApplication.shared.open(contractURL! as URL)
        }
    }
    
    
    @objc private func registerButtonPressed(_ sender : UIButton) {
        guard let email = idTextField.text else{return}
        guard let password = passwordTextField.text else{return}
        guard let nickName = nickNameTextField.text else{return}
        
        if checkSign == true{ //약관 동의 체크
        
            if nickName != "" {
                self.indicatorView.startAnimating()
                
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let e = error{
                        print(e.localizedDescription)
                        self.indicatorView.stopAnimating()
                        self.setAlert(message: "가입실패", secondMessage: "형식에 맞게 작성해주세요.")
                    }else{
                        
                        guard let user = authResult?.user else {return}
                        
                        self.db.collection("Users").document(user.uid).setData(["NickName" : nickName,
                                                                                "email" : email,
                                                                                "userUid" : user.uid])//가입과 동시에 유저 닉네임 저장
                        
                        self.db.collection(user.uid).document("With Calendar").setData(["calendarName" : "With Calendar", "date" : Date().timeIntervalSince1970]) //가입과 동시에 기본 캘린더 생성
                        
                        UserDefaults.standard.set("With Calendar", forKey: "currentCalendar") //Current Calendar 저장
                        
                        self.indicatorView.stopAnimating()
                        self.setAlert(message: "가입완료", secondMessage: "가입을 환영합니다!")
                    }
                }
            }
        }else{
            setAlert(message: "약관 동의가 필요합니다.", secondMessage: "")
        }
    }
}
