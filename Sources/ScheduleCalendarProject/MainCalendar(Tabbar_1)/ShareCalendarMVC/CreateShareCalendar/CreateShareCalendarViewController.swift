//
//  CreateShareCalendarViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class CreateShareCalendarViewController: UIViewController {
    //MARK: - Properties
    final var shareCalendarDataModel = ShareCalendarDataModel()
    final let createShareCalendarDataService = CreateShareCalendarDataService()
    final let createShareCalendarView = CreateShareCalendarView() //View
    
    private lazy var createButton : UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: #selector(createButtonPressed(_:)))
        button.tintColor = .signatureColor
        
        return button
    }()
    
    private lazy var navigationBackButton : UIBarButtonItem = {
        let button = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
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
        
        handleFetchUserData()
        
        setupSubViews()
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createShareCalendarView.titleTextField.becomeFirstResponder()
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        view.backgroundColor = .customWhiteAndBlackColor
        
        view.addSubview(createShareCalendarView)
        createShareCalendarView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        createShareCalendarView.participantTableView.delegate = self
        createShareCalendarView.participantTableView.dataSource = self
        
        createShareCalendarView.titleTextField.delegate = self
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationItem.title = "공유달력"
        navigationItem.rightBarButtonItem = createButton
        navigationItem.backBarButtonItem = navigationBackButton
        navigationController?.navigationBar.tintColor = .blackAndWhiteColor
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - ButtonMethod
    @objc private func createButtonPressed(_ sender : UIBarButtonItem) {
        guard let title = createShareCalendarView.titleTextField.text else{return}
        
        if title == "" {
            showAlert(title: "제목입력", message: "제목을 입력해주세요.")
            
        }else{
            
            if shareCalendarDataModel.userDataArray.count > 1 {
                handleCreateShareCalendar(calendarTitle: title)
                
            }else{
                showAlert(title: "유저초대", message: "1명 이상의 유저를 초대해주세요.")
            }
        }
    }
}

//MARK: - Extension
extension CreateShareCalendarViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shareCalendarDataModel.userDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ParticipantTableViewCell.identifier, for: indexPath) as! ParticipantTableViewCell
        
        let data = shareCalendarDataModel.userDataArray[indexPath.row]
        
        if indexPath.row == 0 {
            cell.crownImageView.isHidden = false
        }else{
            cell.crownImageView.isHidden = true
        }
        
        cell.nameLabel.text = data.NickName
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.whiteAndCustomBlackColor
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //cell을 클릭했을 때 애니메이션 구현
        triggerHapticFeedback() //유저에게 리액션을 주기 위한 미세한 진동음.
        
        if indexPath.row != 0 { //0은 나 자신이기 때문에 제외하고, 유저를 제외시킴.
            removeUserFromList(index: indexPath.row)
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "참가자"
    }

    //header의 높이
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = ParticipantFooterView()
        footerView.participantDelegate = self
        
        return footerView
    }

    //footer의 높이
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
}

extension CreateShareCalendarViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

//footerView인 눌러서 초대하기를 누르면 inviteView로 보낼 수 있도록.
extension CreateShareCalendarViewController : ParticipantFooterDelegate {
    func footerViewTapped() {
        let vc = SearchUserViewController()
        vc.searchUserDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//검색한 유저를 share calendar로 초대할 때, 리스트에 추가.
extension CreateShareCalendarViewController : SearchUserDelegate {
    func inviteUserToShareCalendar(user: UserData) {
        let userDataArray = shareCalendarDataModel.userDataArray
        
        //해당 유저가 이미 리스트에 존재한다면 추가하지 않음.
        if userDataArray.contains(user) {
        }else{
            self.shareCalendarDataModel.userDataArray.append(user)
            self.createShareCalendarView.participantTableView.reloadData()
        }
    }
    
    //유저 cell을 클릭하면 유저를 명단에서 제외시키는 alert.
    private func removeUserFromList(index: Int) {
        let action = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.shareCalendarDataModel.userDataArray.remove(at: index)
            self?.createShareCalendarView.participantTableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        showAlert(title: "제외", message: "해당 유저를 명단에서 제외합니다.", actions: [action, cancelAction])
    }
}

extension CreateShareCalendarViewController {
    //본인 데이터 가져와서 리스트에 추가.
    private func handleFetchUserData() {
        CustomLoadingView.shared.startLoading(to: 0)
        
        createShareCalendarDataService.fetchUserDataFromFirestore { [weak self] result in
            DispatchQueue.main.async {
                switch result {

                case .success(let data):
                    CustomLoadingView.shared.stopLoading()
                    self?.shareCalendarDataModel.userDataArray.append(data)
                    self?.createShareCalendarView.participantTableView.reloadData()

                case .failure(let err):
                    print("Error 유저 정보 찾기 실패. : \(err.localizedDescription)")
                    CustomLoadingView.shared.stopLoading()
                }
            }
        }
    }
    
    //공유캘린더 생성.
    private func handleCreateShareCalendar(calendarTitle: String) {
        CustomLoadingView.shared.startLoading(to: 0.5)
        let userData = shareCalendarDataModel.userDataArray
        
        createShareCalendarDataService.createShareCalendar(userDataArray: userData, calendarTitle: calendarTitle) { [weak self] result in
            
            guard let self = self else{return}
            CustomLoadingView.shared.stopLoading()
            
            switch result {
                
            case .success(_):
                self.navigationController?.popViewController(animated: true)
                
            case .failure(let err):
                self.handleFailure(err)
            }
        }
    }
    
    private func handleFailure(_ error : CreateShareCalendarError) {
        switch error {
        case .failedSaveShareCalendarData(let actualError):
            showAlert(title: "저장 실패", message: actualError)
            
        case .invalidateDataError:
            showAlert(title: "네트워킹 실패", message: "데이터가 없습니다.")
            
        case .failedURLRequest(let actualError):
            showAlert(title: "네트워킹 실패", message: actualError)
            
        case .failedCreateShareCalendar(let actualError):
            showAlert(title: "생성 실패", message: actualError)
            
        case .failedSaveHolidayData(let actualError):
            showAlert(title: "공휴일 저장실패", message: actualError)
        }
    }
    
}
