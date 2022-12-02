//
//  LoginViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/11/03.
//

import UIKit
import FirebaseAuth
import SnapKit

class LoginViewController: UIViewController {
    
//MARK: - Properties
    var delegate : ChangeDataDelegate?
    
    private let dismissButton = UIButton()
    
    private let logoLabel = UILabel()
    
    private let idTextField = UITextField()
    
    private let passwordTextField = UITextField()
       
    private let registerLabel = UILabel()
    private let registerButton = UIButton()
    
    private let loginButton = UIButton()
    
    private lazy var indicatorView : UIActivityIndicatorView = {
       let ia = UIActivityIndicatorView()
        ia.hidesWhenStopped = true
        ia.style = .large
        
        return ia
    }()
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isModalInPresentation = true
        
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
        
        view.addSubview(idTextField)
        idTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0)) //여백주기
        idTextField.leftViewMode = .always
        idTextField.clearButtonMode = .always
        idTextField.backgroundColor = .white
        idTextField.placeholder = "아이디"
        idTextField.clipsToBounds = true
        idTextField.layer.borderWidth = 1
        idTextField.layer.cornerRadius = 10
        idTextField.layer.borderColor = UIColor.darkGray.cgColor
        idTextField.textColor = .black
        idTextField.snp.makeConstraints { make in
            make.top.equalTo(logoLabel.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(50)
        }
        
        view.addSubview(passwordTextField)
        passwordTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0)) //여백주기
        passwordTextField.leftViewMode = .always
        passwordTextField.clearButtonMode = .always
        passwordTextField.backgroundColor = .white
        passwordTextField.placeholder = "비밀번호"
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
        
        view.addSubview(loginButton)
        loginButton.setTitle("로그인", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
        loginButton.addTarget(self, action: #selector(loginButtonPressed(_:)), for: .touchUpInside)
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp_bottomMargin).offset(60)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(55)
        }
        
        view.addSubview(registerLabel)
        registerLabel.text = "With 계정이 없으신가요?"
        registerLabel.textColor = .black
        registerLabel.font = .systemFont(ofSize: 16)
        registerLabel.sizeToFit()
        registerLabel.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp_bottomMargin).offset(80)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        view.addSubview(registerButton)
        registerButton.addTarget(self, action: #selector(registerButtonPressed(_:)), for: .touchUpInside)
        registerButton.setTitle("회원가입", for: .normal)
        registerButton.setTitleColor(.systemBlue, for: .normal)
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(registerLabel.snp_bottomMargin).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(100)
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
    

//MARK: - ButtonMethod
    
    private func loginErrorAlert() {
        let alert = UIAlertController(title: "아이디 혹은 비밀번호를 확인하세요", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    @objc private func loginButtonPressed(_ sender : UIButton) {
        self.indicatorView.startAnimating()
        
        if let email = idTextField.text, let password = passwordTextField.text{
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    print(e)
                    self.indicatorView.stopAnimating()
                    self.loginErrorAlert()
                    
                }else{
                    self.indicatorView.stopAnimating()
                    self.delegate?.dataChange()
                    self.dismiss(animated: true)
                }
            }
        }
    }
    

    @objc private func dismissButtonPressed(_ sender : UIButton) {
        self.dismiss(animated: true)
        
    }
    
    @objc func registerButtonPressed(_ sender : UIButton) {
        let vc = UserRegisterViewController()
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true)
    }

}


