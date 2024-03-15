//
//  FindPasswordViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class FindPasswordViewController: UIViewController {
    //MARK: - Properties
    final var registerDataModel = RegisterDataModel()
    final let findPassWordService = FindPassWordService()
    final let findPasswordView = FindPasswordView() //View
    private let loadingView = WCLoadingView()
    
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
        findPasswordView.emailTextField.becomeFirstResponder()
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        view.backgroundColor = .whiteAndBlackColor
        
        view.addSubview(findPasswordView)
        findPasswordView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        findPasswordView.emailTextField.delegate = self
        findPasswordView.sendButton.addTarget(self, action: #selector(sendButtonPressed(_:)), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationItem.title = ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    //MARK: - ButtonMethod
    
    @objc private func sendButtonPressed(_ sender : UIButton){
        guard let email = findPasswordView.emailTextField.text else{return}
        
        if email == "" {
            showAlert(title: "전송 실패", message: "이메일을 작성해주세요.")
            
        }else{
            loadingView.startLoading()
            handleFindPW(userID: email)
        }
    }
    
}

//MARK: - TextFieldDelegate
extension FindPasswordViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

//MARK: - 비밀번호 찾기 작업.
extension FindPasswordViewController {
    //해당 이메일로 비밀번호를 찾을 수 있는 메세지를 보낼 때 에러와 성공에 대한 후처리.
    private func handleFindPW(userID: String) {
        
        findPassWordService.firebaseFindPW(userID: userID) { [weak self] result in
            switch result {
                
            case .success(_):
                self?.loadingView.stopLoading()
                self?.showAlert(title: "전송 완료", message: "메일을 확인해주세요.")
                
            case .failure(let err):
                print("Error 전송 실패: \(err.localizedDescription)")
                
                if err.localizedDescription == "The email address is badly formatted." {
                    self?.showAlert(title: "전송 실패", message: "이메일을 확인해주세요.")
                    
                }else if err.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                    self?.showAlert(title: "전송 실패", message: "회원이 아닙니다.")
                    
                }else{
                    self?.showAlert(title: "전송 실패", message: "")
                }
                
                self?.loadingView.stopLoading()
            }
        }
    }
}
