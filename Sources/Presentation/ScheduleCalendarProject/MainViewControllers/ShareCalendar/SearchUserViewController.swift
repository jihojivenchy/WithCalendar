//
//  SearchUserViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/11/02.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

final class SearchUserViewController: UIViewController {
//MARK: - Properties
    private let db = Firestore.firestore()
    private var searchUserArray : [SearchUserData] = []
    final var searchDelegate : SearchViewDelegate?
    
    private lazy var searchBar : UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Code 입력"
        sb.delegate = self
        sb.tintColor = .displayModeColor2
        sb.barTintColor = .customSignatureColor
        
        return sb
    }()
    
    private let userTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private var myNameData = String()
    
//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        navBarAppearance()
        
        userTableView.register(DisplayModeTableViewCell.self, forCellReuseIdentifier: DisplayModeTableViewCell.cellIdentifier)
        userTableView.delegate = self
        userTableView.dataSource = self
        userTableView.rowHeight = 70
    }
    
//MARK: - ViewMethod
    private func addSubViews() {
        view.backgroundColor = .displayModeColor1
        
        view.addSubview(userTableView)
        userTableView.backgroundColor = .clear
        userTableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
            
        }
        
    }
    
    private func navBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .displayModeColor2
        
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }
    
    private func getUserData(userCode : String) {
        
        db.collection("Users").whereField("code", isEqualTo: userCode).getDocuments { querySnapShot, error in
            if let e = error {
                print("Error search User Data : \(e)")
            }else{
                self.searchUserArray = []
                
                if let snapShotDocument = querySnapShot?.documents {
                    for doc in snapShotDocument {
                        let data = doc.data()
                        
                        guard let nickName = data["NickName"] as? String else{return}
                        guard let uid = data["userUid"] as? String else{return}
                        
                        let findData = SearchUserData(nickName: nickName, uid: uid)
                        
                        self.searchUserArray.append(findData)
                    }
                }
                
                DispatchQueue.main.async {
                    self.userTableView.reloadData()
                }
            }
        }
    }
    
    
    
//MARK: - ButtonMethod

}

//MARK: - Extension

extension SearchUserViewController : UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        if let searchText = searchBar.text{
            self.searchUserArray = []
            self.getUserData(userCode: searchText)
        }
    }
}


extension SearchUserViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchUserArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DisplayModeTableViewCell.cellIdentifier, for: indexPath) as! DisplayModeTableViewCell
        
        cell.displayLabel.text = self.searchUserArray[indexPath.row].nickName
        cell.displayLabel.font = .boldSystemFont(ofSize: 16)
        
        cell.backgroundColor = .clear
        cell.separatorInset = UIEdgeInsets.zero
        cell.accessoryType = .disclosureIndicator
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .displayModeColor3
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
}

extension SearchUserViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = RequestViewController()
        vc.nameLabel.text = self.searchUserArray[indexPath.row].nickName
        vc.uid = self.searchUserArray[indexPath.row].uid
        vc.delegate = self
        
        vc.modalPresentationStyle = .custom
        
        present(vc, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchUserViewController : RequestViewDelegate {
    func invitePressed(name: String, uid: String) {
        searchDelegate?.sendinviteData(name: name, uid: uid)
    }
    
}

protocol SearchViewDelegate {
    func sendinviteData(name : String, uid : String)
}
