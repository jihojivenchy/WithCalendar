//
//  WritePasswordViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class WritePasswordViewController: UIViewController {
    //MARK: - Properties
    final var registerDataModel = RegisterDataModel()
    final let registerDataService = RegisterDataService()
    final let writePasswordView = WritePasswordView() //View
    private let loadingView = WCLoadingView()
    
    private lazy var navigationBackButton : UIBarButtonItem = {
        let button = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return button
    }()
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(registerDataModel.userName)
        print(registerDataModel.userEmail)
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubViews()
        setupNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        writePasswordView.pwTextField.becomeFirstResponder()
    }
    
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        view.backgroundColor = .whiteAndBlackColor
        
        view.addSubview(writePasswordView)
        writePasswordView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        writePasswordView.pwTextField.delegate = self
        writePasswordView.pwCheckTextField.delegate = self
        writePasswordView.registerButton.addTarget(self, action: #selector(registerButtonPressed(_:)), for: .touchUpInside)
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
    
    @objc private func registerButtonPressed(_ sender : UIButton){
        self.view.endEditing(true)
        
        guard let checkText = writePasswordView.checkLabel.text else{return}
        guard let pwCheckText = writePasswordView.pwCheckTextField.text else{return}
        
        let userEmail = registerDataModel.userEmail
        let userName = registerDataModel.userName
        let userCode = registerDataModel.code.randomString(length: 5)
        
        let data = RegisterUserData(userName: userName, userCode: userCode,
                                    userEmail: userEmail, userPW: pwCheckText)
        
        //비밀번호와 비밀번호 확인을 모두 일치하게 작성해서 Check 라벨의 텍스트가 맞게 변경되었는지 확인.
        if checkText == "비밀번호가 일치합니다." {
            handleRegister(data: data)
            
        }else{
            showAlert(title: "양식오류", message: "비밀번호를 확인해주세요.")
        }
        
    }
    
}

//MARK: - TextFieldDelegate
extension WritePasswordViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let pwText = writePasswordView.pwTextField.text else{return }
        guard let checkText = writePasswordView.pwCheckTextField.text else{return}
        
        //1. 작성한 비밀번호와 비밀번호 확인이 동일한지 체크
        //2. 서로 아무것도 적지 않아서 동일한 경우는 비밀번호를 입력하라는 문구를 나타냄.
        if pwText == checkText {
            if pwText == "" {
                writePasswordView.checkLabel.textColor = .customRedColor
                writePasswordView.checkLabel.text = "비밀번호를 입력해주세요."
                
            }else{
                writePasswordView.checkLabel.textColor = .green
                writePasswordView.checkLabel.text = "비밀번호가 일치합니다."
            }
            
        }else{
            writePasswordView.checkLabel.textColor = .customRedColor
            writePasswordView.checkLabel.text = "비밀번호가 일치하지 않습니다."
        }
    }
}

//MARK: - 회원가입 작업.
extension WritePasswordViewController {
    //회원가입의 성공과 에러에 대한 후처리
    private func handleRegister(data: RegisterUserData) {
        loadingView.startLoading()
        
        registerDataService.firebaseRegister(data: data) { [weak self] result in
           
            DispatchQueue.main.async {
                
                switch result {
                case .success(let uid):
                    self?.loadingView.stopLoading()
                    
                    self?.saveDataPathInUserDefaults(userUID: uid)
                    
                    let vc = WelcomeViewController()
                    vc.userName = data.userName
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                case .failure(let err):
                    self?.loadingView.stopLoading()
                    
                    switch err {
                        
                    case .failedRegister(let actualError):
                        self?.showAlert(title: "가입 실패", message: actualError)
                        
                    case .failedSaveUserData(let actualError):
                        self?.showAlert(title: "유저정보 저장실패", message: actualError)
                        
                    case .failedURLRequest(let actualError):
                        self?.showAlert(title: "네트워킹 실패", message: actualError)
                        
                    case .failedSaveHolidayData(let actualError):
                        self?.showAlert(title: "공휴일정보 저장실패", message: actualError)
                    }
                }
            }
        }
    }
}
