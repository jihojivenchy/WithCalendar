//
//  ShareCalendarViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/01/02.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

final class ShareCalendarViewController: UIViewController {
    //MARK: - Properties
    private let db = Firestore.firestore()
    private var shareCalendarDataArray : [ShareCalendarData] = []
    final var delegate : ShareCalendarCellDelegate?
    
    private let shareCalendarTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private lazy var refresh : UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.addTarget(self, action: #selector(reloadAction), for: .valueChanged)
        
        return rf
    }()
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        getShareCalendarData()
        
        shareCalendarTableView.refreshControl = refresh
        shareCalendarTableView.delegate = self
        shareCalendarTableView.dataSource = self
        shareCalendarTableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.cellIdentifier)
        shareCalendarTableView.rowHeight = 70
        shareCalendarTableView.separatorStyle = .none
    }
    
    //MARK: - ViewMethod
    private func addSubViews() {
        
        view.backgroundColor = .displayModeColor1
        
        view.addSubview(shareCalendarTableView)
        shareCalendarTableView.backgroundColor = .clear
        shareCalendarTableView.showsVerticalScrollIndicator = false
        shareCalendarTableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc private func reloadAction() {
        refresh.endRefreshing()
    }
    
//MARK: - DataMethod
    private func getShareCalendarData() {
        guard let user = Auth.auth().currentUser else{return}
        
        db.collection("\(user.uid).공유").addSnapshotListener { qs, error in
            if let e = error {
                print("Error get share calendar data : \(e)")
            }else{
                guard let snapShotDocuments = qs?.documents else{return}
                self.shareCalendarDataArray = []
                
                for doc in snapShotDocuments {
                    let data = doc.data()
                    
                    guard let calendarNameData = data["calendarName"] as? String else{return}
                    guard let ownerData = data["owner"] as? String else{return}
                    guard let ownerUidData = data["ownerUid"] as? String else{return}
                    guard let memberArray = data["member"] as? [String] else{return}
                    guard let memberUidArray = data["memberUid"] as? [String] else{return}
                    
                    let findData = ShareCalendarData(calendarName: calendarNameData, documentID: doc.documentID, owner: ownerData, ownerUid: ownerUidData, member: memberArray, memberUid: memberUidArray)
                    
                    self.shareCalendarDataArray.append(findData)
                }
                
                DispatchQueue.main.async {
                    self.shareCalendarTableView.reloadData()
                }
            }
        }
    }
    
}

//MARK: - Extension

extension ShareCalendarViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shareCalendarDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.cellIdentifier, for: indexPath) as! CategoryTableViewCell
        
        cell.categoryImageView.image = UIImage(systemName: "calendar")
        cell.categoryLabel.text = self.shareCalendarDataArray[indexPath.row].calendarName
        cell.numberLabel.text = String(self.shareCalendarDataArray[indexPath.row].member.count)
        cell.index = indexPath.row
        cell.delegate = self
        cell.tintColor = .customSignatureColor
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.displayModeColor3
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
}

extension ShareCalendarViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(self.shareCalendarDataArray[indexPath.row].ownerUid, forKey: "currentCollection")
        UserDefaults.standard.set(self.shareCalendarDataArray[indexPath.row].documentID, forKey: "currentDocument")
        UserDefaults.standard.set(self.shareCalendarDataArray[indexPath.row].calendarName, forKey: "currentCalendarName")
        
        delegate?.shareCellPressed()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ShareCalendarViewController : CategoryCellGestureDelegate {
    func cellPressed(senderIndex: Int) {
        let alert = UIAlertController(title: "편집하기", message: nil, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "확인", style: .default) { (action) in
            let vc = EditShareCalendarViewController()
            vc.shareCalendarData = self.shareCalendarDataArray[senderIndex]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        yesAction.setValue(UIColor.displayModeColor2, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        cancelAction.setValue(UIColor.displayModeColor2, forKey: "titleTextColor")
        
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

protocol ShareCalendarCellDelegate {
    func shareCellPressed()
}
