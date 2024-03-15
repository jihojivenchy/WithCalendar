//
//  SearchUserViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class SearchUserViewController: UIViewController {
    //MARK: - Properties
    final var shareCalendarDataModel = ShareCalendarDataModel()
    final let searchUserDataService = SearchUserDataService()
    final let searchUserView = SearchUserView() //View
    private let loadingView = WCLoadingView()
    
    final weak var searchUserDelegate : SearchUserDelegate?
    
    private let searchBar = UISearchBar()
    
    private lazy var cancelButton : UIBarButtonItem = {
        let button = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonPressed(_:)))
        
        return button
    }()
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupSubViews()
        setupNavigationBar()
    }
    
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        view.backgroundColor = .customWhiteAndBlackColor
        
        view.addSubview(searchUserView)
        searchUserView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchUserView.userTableView.delegate = self
        searchUserView.userTableView.dataSource = self
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.tintColor = .blackAndWhiteColor
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    private func setupSearchBar() {
        searchBar.searchTextField.leftView?.tintColor = .signatureColor
        searchBar.barTintColor = .signatureColor
        searchBar.placeholder = "Code 입력"
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
    }

    //MARK: - ButtonMethod
    @objc private func cancelButtonPressed(_ sender : UIBarButtonItem) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

//MARK: - Extension
extension SearchUserViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shareCalendarDataModel.userDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OptionTableViewCell.identifier, for: indexPath) as! OptionTableViewCell
        
        let data = shareCalendarDataModel.userDataArray[indexPath.row]
        
        cell.titleLabel.text = data.NickName
        
        cell.accessoryType = .disclosureIndicator
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.whiteAndCustomBlackColor
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //cell을 클릭했을 때 애니메이션 구현
        triggerHapticFeedback() //유저에게 리액션을 주기 위한 미세한 진동음.
        
        let userData = shareCalendarDataModel.userDataArray[indexPath.row]
        inviteShareCalendarAlert(user: userData)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear

        let footerLabel = UILabel()
        footerLabel.numberOfLines = 0
        footerLabel.configure(textColor: .darkGray, backgroundColor: .clear, fontSize: 12, alignment: .left)
        footerLabel.text = "*공유달력 사용방법* \n\n1. 회원가입과 동시에 회원코드가 부여됩니다.\n(메뉴 -> 프로필 설정에서 확인가능) \n\n2. 검색 바에서 초대하고 싶은 유저의 코드를 입력합니다. \n\n3. 초대 후 뒤로 돌아가서 체크 버튼을 눌러 공유달력을 생성합니다. \n\n4. 달력을 편집하고 싶다면 카테고리 창에서 달력을 꾹 눌러주세요."

        footerView.addSubview(footerLabel)
        footerLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(15)
            make.left.right.equalToSuperview().inset(15)
        }

        return footerView
    }

    //footer의 높이
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 200
    }
    
}

extension SearchUserViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let text = searchBar.text else{return}
        
        if text != "" {
            handleFindUserData(code: text)
        }
    }
}

extension SearchUserViewController {
    //코드와 일치하는 유저정보를 찾고 성공과 에러에 대한 후처리.
    private func handleFindUserData(code: String) {
        loadingView.startLoading()
        
        searchUserDataService.findUserWithMatchingCode(code: code) { [weak self] result in
            DispatchQueue.main.async {
                switch result {

                case .success(let data):
                    self?.loadingView.stopLoading()
                    self?.shareCalendarDataModel.userDataArray = data
                    self?.searchUserView.userTableView.reloadData()

                case .failure(let err):
                    print("Error 코드와 일치하는 유저정보 찾기 실패 : \(err.localizedDescription)")
                    self?.loadingView.stopLoading()
                }
            }
        }
    }
    
    private func inviteShareCalendarAlert(user: UserData) {
        
        let action = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.searchUserDelegate?.inviteUserToShareCalendar(user: user)
            self?.showToast(message: "\(user.NickName)님을 초대하셨습니다.", durationTime: 1, delayTime: 2, width: 250)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        showAlert(title: "초대", message: "해당 유저를 공유 캘린더에 초대하시겠습니까?", actions: [action, cancelAction])
    }
}

protocol SearchUserDelegate : AnyObject {
    func inviteUserToShareCalendar(user : UserData)
}
