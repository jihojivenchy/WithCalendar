//
//  WriteEmailViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class WriteEmailViewController: UIViewController {
    //MARK: - Properties
    final var registerDataModel = RegisterDataModel()
    final let writeEmailView = WriteEmailView() //View
    
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        writeEmailView.emailTextField.becomeFirstResponder()
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        view.backgroundColor = .whiteAndBlackColor
        
        view.addSubview(writeEmailView)
        writeEmailView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        writeEmailView.emailTextField.delegate = self
        writeEmailView.nextButton.addTarget(self, action: #selector(nextButtonPressed(_:)), for: .touchUpInside)
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
    
    //이메일 형식으로 작성했는지 파악.
    final func isValidEmail(email : String) -> Bool {
        return email.contains("@") && email.contains(".")
    }
    
    
    //MARK: - ButtonMethod
    
    @objc private func nextButtonPressed(_ sender : UIButton){
        guard let email = writeEmailView.emailTextField.text else{return}
        
        //1. email 텍스트 필드에 이메일을 작성했는지
        //2. 이메일 형식에 맞게 작성했는지
        if email == "" {
            showAlert(title: "양식오류", message: "이메일을 작성해주세요.")
            
        }else{
            
            if isValidEmail(email: email) {
                let vc = WritePasswordViewController()
                vc.registerDataModel.userEmail = email
                vc.registerDataModel.userName = self.registerDataModel.userName
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else{
                showAlert(title: "양식오류", message: "이메일 형식에 맞게 작성해주세요.")
            }
        }
    }
    
}

//MARK: - Extension
extension WriteEmailViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
