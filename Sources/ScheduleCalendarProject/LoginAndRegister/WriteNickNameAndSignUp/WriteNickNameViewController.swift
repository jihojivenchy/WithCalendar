//
//  WriteNickNameViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class WriteNickNameViewController: UIViewController {
    //MARK: - Properties
    final var registerDataModel = RegisterDataModel()
    final let writeNickNameView = WriteNickNameView() //View
    
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
        writeNickNameView.nickNameTextField.becomeFirstResponder()
    }

    //MARK: - ViewMethod
    private func setupSubViews() {
        view.backgroundColor = .whiteAndBlackColor
        
        view.addSubview(writeNickNameView)
        writeNickNameView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        writeNickNameView.nickNameTextField.delegate = self
        writeNickNameView.checkBoxButton.addTarget(self, action: #selector(checkBoxPressed(_:)), for: .touchUpInside)
        writeNickNameView.showContractButton.addTarget(self, action: #selector(showButtonPressed(_:)), for: .touchUpInside)
        writeNickNameView.nextButton.addTarget(self, action: #selector(nextButtonPressed(_:)), for: .touchUpInside)
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
    
    @objc private func checkBoxPressed(_ sender : UIButton){
        sender.isSelected.toggle()
        
        if sender.isSelected == true{
            registerDataModel.checkSign = true
        }else{
            registerDataModel.checkSign = false
        }
    }
    
    @objc private func showButtonPressed(_ sender : UIButton){
        let centerURL = "https://iosjiho.tistory.com/77"
        let contractURL = NSURL(string: centerURL)
        
        if UIApplication.shared.canOpenURL(contractURL! as URL){
            
            UIApplication.shared.open(contractURL! as URL)
        }
    }
    
    @objc private func nextButtonPressed(_ sender : UIButton){
        guard let name = writeNickNameView.nickNameTextField.text else{return}
        
        if name == "" {
            showAlert(title: "닉네임을 작성해주세요.", message: "")
            
        }else{
            if registerDataModel.checkSign{
                //다음단계로 이동
                let vc = WriteEmailViewController()
                vc.registerDataModel.userName = name //nickname 전달하기.
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else{
                showAlert(title: "약관동의", message: "약관에 동의해주세요.")
            }
        }
        
        
    }
    
}

//MARK: - Extension
extension WriteNickNameViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
