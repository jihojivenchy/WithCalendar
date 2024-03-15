//
//  LoginViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class LoginViewController: UIViewController {
    //MARK: - Properties
    final var registerDataModel = RegisterDataModel()
    final let loginService = LoginService()
    final let loginView = LoginView() //View
    private let loadingView = WCLoadingView()
    private lazy var navigationBackButton : UIBarButtonItem = {
        let button = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return button
    }()
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubViews()
        setupNavigationBar()
    }

    //MARK: - ViewMethod
    private func setupSubViews() {
        view.backgroundColor = .whiteAndBlackColor
        
        view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        loginView.idTextField.delegate = self
        loginView.pwTextField.delegate = self
        
        loginView.loginButton.addTarget(self, action: #selector(loginButtonPressed(_:)), for: .touchUpInside)
        loginView.registerButton.addTarget(self, action: #selector(registerButtonPressed(_:)), for: .touchUpInside)
        loginView.findPWButton.addTarget(self, action: #selector(findButtonPressed(_:)), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationItem.title = ""
        navigationItem.backBarButtonItem = navigationBackButton
        navigationController?.navigationBar.tintColor = .blackAndWhiteColor
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - ButtonMethod
    @objc private func loginButtonPressed(_ sender : UIButton) {
        guard let email = loginView.idTextField.text else{return}
        guard let password = loginView.pwTextField.text else{return}
        
        //아이디와 비밀번호를 입력했는지 확인.
        if email == "" && password == "" {
            showAlert(title: "로그인 실패", message: "아이디 혹은 비밀번호를 입력해주세요.")
            
        }else{
            //로그인 시작.
            loadingView.startLoading()
            handleLogin(userEmail: email, userPW: password)
        }
    }
    
    @objc private func registerButtonPressed(_ sender : UIButton) {
        let vc = WriteNickNameViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func findButtonPressed(_ sender : UIButton) {
        let vc = FindPasswordViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - TextFieldDelegate
extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

//MARK: - 로그인 작업
extension LoginViewController {
    func handleLogin(userEmail: String, userPW: String) {
        
        loginService.firebaseLogin(userEmail: userEmail, userPW: userPW) { [weak self] result in
            DispatchQueue.main.async {
                
                switch result {
                case .success(let uid):
                    self?.loadingView.stopLoading()
                    
                    self?.saveDataPathInUserDefaults(userUID: uid) //해당 유저의 캘린더 데이터 경로를 저장.
                    self?.navigationController?.popViewController(animated: true)
                    
                case .failure(let err):
                    
                    print("Error 로그인 실패 : \(err.localizedDescription)")
                    
                    if err.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                        self?.showAlert(title: "아이디 확인", message: "회원이 아니신가요?")
                        
                    }else if err.localizedDescription == "The password is invalid or the user does not have a password."{
                        self?.showAlert(title: "비밀번호 확인", message: "비밀번호를 확인해주세요.")
                        
                    }else{
                        self?.showAlert(title: "로그인 실패", message: "다시 한번 확인해주세요.")
                    }
                    
                    self?.loadingView.stopLoading()
                }
            }
        }
    }
}

