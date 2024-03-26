//
//  MyProfileViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class MyProfileViewController: BaseViewController {
    // MARK: - UI
    private let profileView = ProfileView()
    
    // MARK: - Properties
    final var myProfileDataModel = MyProfileDataModel(userName: "", userEmail: "", userCode: "", userUID: "")
    final let myProfileDataService = MyProfileDataService()
    final let myProfileView = MyProfileView() //View
    private let loadingView = WCLoadingView()
    
    private lazy var saveButton : UIBarButtonItem = {
        let button = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(saveButtonPressed(_:)))
        
        return button
    }()
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleGetUserData()
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        navigationItem.title = "프로필 설정"
    }
    
    // MARK: - Layouts
    override func configureLayouts() {
        view.backgroundColor = .customWhiteAndBlackColor
        view.addSubview(profileView)
        
        profileView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        view.backgroundColor = .customWhiteAndBlackColor
        
        view.addSubview(myProfileView)
        myProfileView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        myProfileView.codeChangeButton.addTarget(self, action: #selector(codeChangeButtonPressed(_:)), for: .touchUpInside)
        myProfileView.deleteAccountButton.addTarget(self, action: #selector(deleteButtonPressed(_:)), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationItem.title = "프로필 설정"
        navigationItem.rightBarButtonItem = saveButton
        navigationController?.navigationBar.tintColor = .blackAndWhiteColor
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - ButtonMethod
    @objc private func saveButtonPressed(_ sender : UIBarButtonItem) {
        guard let nickName = myProfileView.nameTextField.text else{return}
        guard let code = myProfileView.codeLabel.text else{return}
        
        if nickName == "" {
            showAlert(title: "수정 불가", message: "닉네임을 입력해주세요.")
            
        }else{
            let str = code.components(separatedBy: ": ") //"Code: 1111" 부분에서 ": "를 기점으로 string을 쪼개기.
            let userCode = str[1] //쪼갠 str에서 원하는 부분만 가져오기.
            
            handleUpdateData(name: nickName, code: userCode)
        }
    }
    
    @objc private func codeChangeButtonPressed(_ sender : UIButton) {
        let userCode = myProfileDataModel.code.randomString(length: 5)
        
        myProfileView.codeLabel.text = "Code: \(userCode)"
    }
    
    @objc private func deleteButtonPressed(_ sender : UIButton) {
        showAccountDeleteAlert()
    }
}

//MARK: - 유저 정보가져오기, 정보수정, 정보삭제 등의 작업.
extension MyProfileViewController {
    //유저데이터를 가져올 때, 성공과 에러에 대한 후처리
    private func handleGetUserData() {
        loadingView.startLoading()
        
        myProfileDataService.fetchMyProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.myProfileDataModel = MyProfileDataModel(userName: data.userName, userEmail: data.userEmail, userCode: data.userCode, userUID: data.userUID)
                    
                    self?.myProfileView.nameTextField.text = data.userName
                    self?.myProfileView.idTextField.text = data.userEmail
                    self?.myProfileView.codeLabel.text = "Code: \(data.userCode)"
                    
                    
                    self?.loadingView.stopLoading()
                    
                case .failure(let err):
                    self?.loadingView.stopLoading()
                    print("Error 유저 데이터 찾기 실패 : \(err.localizedDescription)")
                }
            }
        }
    }
    
    //유저가 프로필을 수정했을 때, 성공과 에러에대한 후처리
    private func handleUpdateData(name: String, code: String) {
        loadingView.startLoading()
        
        myProfileDataService.updateMyprofile(userName: name, userCode: code) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self?.loadingView.stopLoading()
                    self?.navigationController?.popViewController(animated: true)
                    
                case .failure(let err):
                    self?.loadingView.stopLoading()
                    print("Error 유저 데이터 찾기 실패 : \(err.localizedDescription)")
                    self?.showAlert(title: "수정 실패", message: "데이터를 찾을 수 없음")
                }
            }
        }
    }
    
    //계정삭제에 대한 Alert
    private func showAccountDeleteAlert() {
        
        let action = UIAlertAction(title: "삭제", style: .default) { [weak self] _ in
            self?.handleDeleteAccount()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        showAlert(title: "계정삭제", message: "계정을 삭제하시겠습니까?", actions: [action, cancelAction])
    }
    
    //계정삭제를 진행했을 때, 성공과 에러에 대한 후처리
    private func handleDeleteAccount() {
        loadingView.startLoading()
        
        myProfileDataService.deleteAccount { [weak self] result in
            switch result {
                
            case .success(_):
                self?.loadingView.stopLoading()
                self?.navigationController?.popViewController(animated: true)
                print("성공")
                
            case .failure(let err):
                self?.loadingView.stopLoading()
                self?.showAlert(title: "삭제 실패", message: err.localizedDescription)
            }
        }
    }
}
