//
//  ShareSignalViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/11/17.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

final class ShareRequestViewController: UIViewController {
//MARK: - Properties
    private let db = Firestore.firestore()
    private var shareRequestDataArray : [ShareRequestData] = []
    
    private let signalTableView = UITableView(frame: .zero, style: .grouped)
    
//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        
        navBarAppearance()
        
        signalTableView.delegate = self
        signalTableView.dataSource = self
        signalTableView.register(ShareSignalTableViewCell.self, forCellReuseIdentifier: ShareSignalTableViewCell.cellIdentifier)
        signalTableView.rowHeight = 165
        signalTableView.separatorStyle = .none
        
        getShareRequestData()
    }
    
//MARK: - ViewMethod
    
    private func addSubViews() {
        view.backgroundColor = .customGray
        
        view.addSubview(signalTableView)
        signalTableView.backgroundColor = .customGray
        signalTableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaInsets)
            make.left.right.equalTo(view)
        }
    }
    
    private func navBarAppearance() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "알림"
    }
    
    private func getShareRequestData(){
        if let user = Auth.auth().currentUser {
            db.collection("\(user.uid).요청").order(by: "date", descending: false).addSnapshotListener { querySnapShot, error in
                if let e = error {
                    print("Error get ShareRequestData : \(e)")
                }else{
                    self.shareRequestDataArray = []
                    
                    guard let snapShotDocument = querySnapShot?.documents else{return}
                    
                    for doc in snapShotDocument{
                        let data = doc.data()
                        
                        guard let senderData = data["sender"] as? String else{return}
                        guard let senderUidData = data["senderUid"] as? String else{return}
                        guard let calendarData = data["calendarTitle"] as? String else{return}
                        guard let dateData = data["date"] as? String else{return}
                        
                        let findData = ShareRequestData(sender: senderData, senderUid: senderUidData, title: calendarData, date: dateData, documnetID: doc.documentID)
                        
                        self.shareRequestDataArray.append(findData)
                    }
                    
                    DispatchQueue.main.async {
                        self.signalTableView.reloadData()
                    }
                }
            }
        }
    }
    
    private func deleteRequestData(documentID : String, indexNumber : Int) {
        if let user = Auth.auth().currentUser {
            db.collection("\(user.uid).요청").document(documentID).delete()
            self.shareRequestDataArray.remove(at: indexNumber)
            self.signalTableView.reloadData()
        }
    }
    
    private func setShareCalendarData(indexNumber : Int) {
        guard let user = Auth.auth().currentUser else{return}
        let sender = self.shareRequestDataArray[indexNumber].senderUid
        let title = self.shareRequestDataArray[indexNumber].title
        let date = self.shareRequestDataArray[indexNumber].date
        
        db.collection("\(user.uid).공유").addDocument(data: ["sender" : sender,
                                                          "calendarTitle" : title,
                                                          "shareUser" : user.uid])
        
        db.collection("\(sender).공유").addDocument(data: ["sender" : sender,
                                                        "calendarTitle" : title,
                                                        "shareUser" : user.uid])
        
        db.collection("\(sender).공유달력").document(title).setData(["calendarTitle" : title,
                                                                   "date" : date,
                                                                   "sender" : sender])
    }
    
    
}

//MARK: - Extension

extension ShareRequestViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shareRequestDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShareSignalTableViewCell.cellIdentifier, for: indexPath) as! ShareSignalTableViewCell
        
        
        cell.contentLabel.text = "\(self.shareRequestDataArray[indexPath.row].sender)님께서 \"\(self.shareRequestDataArray[indexPath.row].title)\" 공유 요청을 보냈습니다."
        cell.dateLabel.text = self.shareRequestDataArray[indexPath.row].date
        cell.documentID = self.shareRequestDataArray[indexPath.row].documnetID
        cell.index = indexPath.row
        cell.cellDelegate = self
        
        cell.contentView.isUserInteractionEnabled = false
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
         
        return cell
    }
    
}

extension ShareRequestViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ShareRequestViewController : CellActionDelegate {
    
    func yesButtonPressed(documentID: String, index : Int) {
        self.setShareCalendarData(indexNumber: index)
        self.deleteRequestData(documentID: documentID, indexNumber: index)
    }
    
    func noButtonPressed(documentID: String, index : Int) {
        self.deleteRequestData(documentID: documentID, indexNumber: index)
    }

}

