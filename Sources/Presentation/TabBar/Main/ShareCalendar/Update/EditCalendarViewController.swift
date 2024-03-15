//
//  EditCalendarViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class EditCalendarViewController: UIViewController {
    //MARK: - Properties
    final var shareCalendarDataModel = ShareCalendarDataModel()
    final var editCalendarData : ShareCalendarCategoryData?
    final let editCalendarDataService = EditCalendarDataService()
    final let editCalendarView = EditCalendarView() //View
    
    private lazy var saveButton : UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: #selector(completeButtonTapped(_:)))
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
        
        setupSubViews()
        setupNavigationBar()
        updateButtonFunctionForCalendarOwner()
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        view.backgroundColor = .customWhiteAndBlackColor
        
        view.addSubview(editCalendarView)
        editCalendarView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        editCalendarView.editButton.addTarget(self, action: #selector(deleteOrExitPressed(_:)), for: .touchUpInside)
        
        editCalendarView.titleTextField.text = editCalendarData?.calendarName
        
        editCalendarView.editTableView.delegate = self
        editCalendarView.editTableView.dataSource = self
        
        editCalendarView.titleTextField.delegate = self
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationItem.title = "편집"
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.backBarButtonItem = navigationBackButton
        navigationController?.navigationBar.tintColor = .blackAndWhiteColor
    }

    //현재 편집하는 캘린더의 주인인지 아닌지 체크하여, 버튼의 기능을 다르게 구성.
    private func updateButtonFunctionForCalendarOwner() {
        guard let editCalendarData = editCalendarData else{return}
        let uid = editCalendarData.memberUidArray[0]
        
        if editCalendarDataService.checkCalendarOwner(ownerUID: uid) {
            self.editCalendarView.editButton.customize(title: "삭제", titleColor: UIColor.signatureColor!, backgroundColor: .white, fontSize: 13, cornerRadius: 30)
            self.shareCalendarDataModel.ownerCheckType = true
            
        }else{
            self.editCalendarView.editButton.customize(title: "나가기", titleColor: UIColor.signatureColor!, backgroundColor: .white, fontSize: 11, cornerRadius: 30)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - ButtonMethod
    @objc private func saveButtonPressed(_ sender : UIBarButtonItem) {
        guard let title = editCalendarView.titleTextField.text else{return}
        guard let userCount = editCalendarData?.memberUidArray.count else{return}
        
        if title == "" {
            showAlert(title: "제목입력", message: "제목을 입력해주세요.")
            
        }else{
            
            if userCount > 1 {
                self.editCalendarData?.calendarName = title //캘린더 제목 변경
                saveEditAlert()
                
            }else{
                showAlert(title: "유저초대", message: "1명 이상의 유저를 초대해주세요.")
            }
        }
    }
    
    @objc private func deleteOrExitPressed(_ sender : UIButton) {
        //현재 캘린더의 주인이 나라면 Delete작업을 수행.
        //주인이 아니라면 Exit작업을 수행.
        if shareCalendarDataModel.ownerCheckType {
            deleteAlert()
            
        }else{
            leaveAlert()
        }
    }
}

//MARK: - Extension
extension EditCalendarViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editCalendarData?.memberNameArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ParticipantTableViewCell.identifier, for: indexPath) as! ParticipantTableViewCell
        
        if indexPath.row == 0 {
            cell.crownImageView.isHidden = false
        }else{
            cell.crownImageView.isHidden = true
        }
        
        cell.nameLabel.text = editCalendarData?.memberNameArray[indexPath.row]
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.whiteAndCustomBlackColor
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //cell을 클릭했을 때 애니메이션 구현
        triggerHapticFeedback() //유저에게 리액션을 주기 위한 미세한 진동음.
        
        //1. 현재 캘린더 관리자가 자신인지 체크.
        //2. index 0은 나 자신이기 때문에 제외하고, 유저를 제외시킬 수 있음.
        if shareCalendarDataModel.ownerCheckType {
            if indexPath.row != 0 {
                removeUserFromList(index: indexPath.row)
            }
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

extension EditCalendarViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

//footerView인 눌러서 초대하기를 누르면 inviteView로 보낼 수 있도록.
extension EditCalendarViewController : ParticipantFooterDelegate {
    func footerViewTapped() {
        let vc = SearchUserViewController()
        vc.searchUserDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension EditCalendarViewController : SearchUserDelegate {
    func inviteUserToShareCalendar(user: UserData) {
        guard let uidArray = editCalendarData?.memberUidArray else{return}
        
        //해당 유저가 이미 리스트에 존재한다면 추가하지 않음.
        if uidArray.contains(user.userUid) {
        }else{
            inviteUser(user: user)
        }
    }
    
    //해당 유저를 캘린더 데이터에 추가하고
    //만약 일전에 제외시켰던 유저라면 제외명단에서 데이터를 삭제해줌. 이유는 제외명단에 추가되어 있으면 이후에 캘린더 수정정보를 저장할 때 문제가 생김.
    private func inviteUser(user: UserData) {
        self.editCalendarData?.memberNameArray.append(user.NickName)
        self.editCalendarData?.memberUidArray.append(user.userUid)
        
        self.shareCalendarDataModel.removeUserList.removeAll(where: {$0 == user.userUid})
        
        self.editCalendarView.editTableView.reloadData()
    }
    
    //유저 cell을 클릭하면 유저를 명단에서 제외시키는 alert.
    private func removeUserFromList(index: Int) {
        let action = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.removeUserData(index: index)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        showAlert(title: "제외", message: "해당 유저를 명단에서 제외합니다.", actions: [action, cancelAction])
    }
    
    //해당 유저를 캘린더 정보에서 삭제하고
    //해당 유저를 제외명단에 추가함. 이후에 캘린더 수정정보를 저장할 때, 제외명단에 있는 사람들은 공유캘린더 데이터를 삭제해줘야함.
    private func removeUserData(index: Int) {
        guard let removeUserUID = editCalendarData?.memberUidArray[index] else{return} //삭제하려는 유저UID
        
        shareCalendarDataModel.removeUserList.append(removeUserUID) //삭제한 유저 명단에 넣어줌.
        
        editCalendarData?.memberNameArray.remove(at: index) //캘린더 데이터에서 해당 유저이름 삭제.
        editCalendarData?.memberUidArray.remove(at: index) //캘린더 데이터에서 해당 유저UID 삭제.
        
        editCalendarView.editTableView.reloadData()
    }
}

extension EditCalendarViewController {
    //캘린더 수정작업에 대한 확인 Alert
    private func saveEditAlert() {
        let action = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            //만약 제외한 유저가 없다면 수정한 정보를 그대로 저장.
            //하지만 제외한 유저가 있다면 제외한 유저는 공유캘린더 정보를 삭제해주어야 함.
            if self?.shareCalendarDataModel.removeUserList.count == 0 {
                self?.handleSaveEditCalendarData()
                
            }else{
                self?.handleSaveEditCalendarDataWithRemoveUser()
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        showAlert(title: "수정", message: "캘린더를 수정하시겠습니까?", actions: [action, cancelAction])
    }
    
    //캘린더 수정작업에 대한 후처리.
    private func handleSaveEditCalendarData() {
        guard let editCalendarData = editCalendarData else{return}
        CustomLoadingView.shared.startLoading(to: 0.5)
        
        editCalendarDataService.saveEditCalendarData(data: editCalendarData) { [weak self] result in
            switch result {
                
            case .success(_):
                CustomLoadingView.shared.stopLoading()
                self?.navigationController?.popViewController(animated: true)
                
            case .failure(let err):
                CustomLoadingView.shared.stopLoading()
                self?.showAlert(title: "수정실패", message: err.localizedDescription)
            }
        }
    }
    
    //명단에서 제외한 유저가 있을경우의 캘린더 수정작업에 대한 후처리.
    private func handleSaveEditCalendarDataWithRemoveUser() {
        guard let editCalendarData = editCalendarData else{return}
        CustomLoadingView.shared.startLoading(to: 0.5)
        
        editCalendarDataService.saveEditCalendarDataWithRemoveUserData(data: editCalendarData, removeUserList: shareCalendarDataModel.removeUserList){ [weak self] result in
            switch result {
                
            case .success(_):
                CustomLoadingView.shared.stopLoading()
                self?.navigationController?.popViewController(animated: true)
                
            case .failure(let err):
                CustomLoadingView.shared.stopLoading()
                self?.showAlert(title: "수정실패", message: err.localizedDescription)
            }
        }
    }
    
    //캘린더 삭제작업에 대한 확인 Alert
    //만약 리스트에서 제외한 유저가 존재한다면 삭제작업을 하지 않음. 모든 유저에게 공유캘린더 삭제작업이 이루어져야하기때문.
    private func deleteAlert() {
        let action = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            if self?.shareCalendarDataModel.removeUserList.count == 0 {
                self?.handleDeleteShareCalendarData()
                
            }else{
                self?.showAlert(title: "삭제실패", message: "제외된 유저가 존재합니다.")
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        showAlert(title: "삭제", message: "캘린더를 삭제하시겠습니까?", actions: [action, cancelAction])
    }
    
    //캘린더 삭제작업에 대한 후처리.
    private func handleDeleteShareCalendarData() {
        guard let editCalendarData = editCalendarData else{return}
        CustomLoadingView.shared.startLoading(to: 0.5)
        
        editCalendarDataService.deleteAllShareCalendarDataAndContent(data: editCalendarData) { [weak self] result in
            switch result {
                
            case .success(let uid):
                CustomLoadingView.shared.stopLoading()
                self?.saveDataPathInUserDefaults(userUID: uid) //유저의 기본 캘린더로 데이터 경로를 수정해줌.
                self?.navigationController?.popViewController(animated: true)
                
            case .failure(let err):
                CustomLoadingView.shared.stopLoading()
                self?.showAlert(title: "삭제실패", message: err.localizedDescription)
            }
        }
    }
    
    //캘린더 나가기작업에 대한 확인 Alert
    private func leaveAlert() {
        let action = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.handleLeaveShareCalendar()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        showAlert(title: "나가기", message: "공유캘린더에서 나가시겠습니까?", actions: [action, cancelAction])
    }
    
    //캘린더 나가기작업에 대한 후처리.
    private func handleLeaveShareCalendar() {
        guard let editCalendarData = editCalendarData else{return}
        CustomLoadingView.shared.startLoading(to: 0.5)
        
        editCalendarDataService.leaveShareCalendar(data: editCalendarData) { [weak self] result in
            switch result {
                
            case .success(let uid):
                CustomLoadingView.shared.stopLoading()
                self?.saveDataPathInUserDefaults(userUID: uid) //유저의 기본 캘린더로 데이터 경로를 수정해줌.
                self?.navigationController?.popViewController(animated: true)
                
            case .failure(let err):
                CustomLoadingView.shared.stopLoading()
                self?.showAlert(title: "Error 나가기 실패", message: err.localizedDescription)
            }
        }
    }
}
