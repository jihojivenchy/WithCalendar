//
//  FollowersViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/12/19.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

class FollowersViewController: UIViewController {
//MARK: - Properties
    private let db = Firestore.firestore()
    
    private var followUserData : [FollowUserData] = []
    
    private let followersUserTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        getFollowerUserData()
        
        followersUserTableView.delegate = self
        followersUserTableView.dataSource = self
        followersUserTableView.register(DisplayModeTableViewCell.self, forCellReuseIdentifier: DisplayModeTableViewCell.cellIdentifier)
        followersUserTableView.rowHeight = 70
        followersUserTableView.separatorStyle = .none
    }
    
//MARK: - ViewMethod
    private func addSubViews() {
        
        view.backgroundColor = .displayModeColor1
        
        view.addSubview(followersUserTableView)
        followersUserTableView.backgroundColor = .clear
        followersUserTableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
//MARK: - DataMethod
        
    private func getFollowerUserData() {
        guard let user = Auth.auth().currentUser else{return}
        
        db.collection("\(user.uid).팔로워").addSnapshotListener { qs, error in
            if let e = error {
                print("Error find following user data : \(e)")
            }else{
                guard let snapShotDocuments = qs?.documents else{return}
                for doc in snapShotDocuments {
                    let data = doc.data()
                    
                    guard let nameData = data["name"] as? String else{return}
                    guard let uidData = data["uid"] as? String else{return}
                    
                    let findData = FollowUserData(name: nameData, uid: uidData)
                    
                    self.followUserData.append(findData)
                }
            }
            DispatchQueue.main.async {
                self.followersUserTableView.reloadData()
            }
        }
    }
    
    
}

//MARK: - Extension

extension FollowersViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.followUserData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DisplayModeTableViewCell.cellIdentifier, for: indexPath) as! DisplayModeTableViewCell
        
        cell.displayLabel.text = self.followUserData[indexPath.row].name
        
        cell.backgroundColor = .clear
        cell.accessoryType = .disclosureIndicator
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.displayModeColor3
        cell.selectedBackgroundView = backgroundView
        
        
        return cell
    }
    
}

extension FollowersViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = FollowCategoryCalViewController()
        vc.uid = self.followUserData[indexPath.row].uid
        self.navigationController?.pushViewController(vc, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
