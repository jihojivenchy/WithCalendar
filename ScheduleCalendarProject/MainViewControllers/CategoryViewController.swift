//
//  ChangeCalendarViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/11/02.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

final class CategoryViewController: UIViewController {
//MARK: - Properties
    private let db = Firestore.firestore()
    private var calendarArray : [String] = []
    private var shareCalendarArray : [String] = []
    
    private let categoryTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private lazy var addRightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonPressed(_:)))
        
        return button
    }()
    
    private lazy var navigationBackButton : UIBarButtonItem = {
        let button = UIBarButtonItem(title: nil, style: .plain, target: self, action: nil)
        return button
    }()
    
    var delegate : ChangeDataDelegate?
    
//MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        getCurrentCalendars()
        getShareCalendars()
        navBarAppearance()
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.register(MemoCustomTableViewCell.self, forCellReuseIdentifier: MemoCustomTableViewCell.cellIdentifier)
        categoryTableView.rowHeight = 50
    }
    
//MARK: - ViewMethod
    
    private func addSubViews() {
        view.backgroundColor = .customGray
        
        view.addSubview(categoryTableView)
        categoryTableView.clipsToBounds = true
        categoryTableView.layer.masksToBounds = false
        categoryTableView.layer.cornerRadius = 10
        categoryTableView.layer.shadowColor = UIColor.black.cgColor
        categoryTableView.layer.shadowOffset = CGSize(width: 0, height: 0)
        categoryTableView.layer.shadowRadius = 10
        categoryTableView.layer.shadowOpacity = 0.5
        categoryTableView.backgroundColor = .customGray
        categoryTableView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(350)
        }
        
    }
    
    private func navBarAppearance() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationItem.title = "목록"
        navigationItem.rightBarButtonItem = addRightButton
        navigationItem.backBarButtonItem = navigationBackButton
        navigationController?.navigationBar.tintColor = .black

    }

    
//MARK: - ButtonMethod
   
    @objc private func addButtonPressed(_ sender: UIBarButtonItem) {
        addCalendarAlert()
    }

    private func addCalendarAlert() {
        let alert = UIAlertController(title: "달력 추가", message: nil, preferredStyle: .alert)
        
        let shardAction = UIAlertAction(title: "공유달력 만들기", style: .default) { (action) in
            
            self.navigationController?.pushViewController(ShareCalendarViewController(), animated: true)
            
        }
        shardAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        let addAction = UIAlertAction(title: "개인달력 만들기", style: .default) { (action) in
            
            self.addPersonalCalendarAlert()
        }
        addAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
    
        alert.addAction(shardAction)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }//달력 추가하기
    
    private func addPersonalCalendarAlert() {
        let alert = UIAlertController(title: "추가", message: "추가 할 달력제목을 입력해주세요.", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.textColor = .black
            textField.font = .systemFont(ofSize: 15)
        }
        
        let changeAction = UIAlertAction(title: "추가", style: .default) { (action) in
            
            if let text = alert.textFields?[0].text {
                
                self.setCalendarData(calendarTitle: text)
                self.categoryTableView.reloadData()
            }
            
        }
        changeAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(changeAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }//개인 달력 추가하기
    
    private func editingCalendarAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        let nameEditAction = UIAlertAction(title: "달력제목 변경", style: .default) { (action) in
            self.changeCalendarNameAlert()
        }
        nameEditAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        let deleteAction = UIAlertAction(title: "삭제하기", style: .default) { (action) in
            self.deleteAlert()
        }
        deleteAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(nameEditAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }//선택 달력 편집하기
    
    private func deleteAlert() {
        let alert = UIAlertController(title: "현재 선택된 달력을 삭제하시겠습니까?", message: "달력에 저장된 모든 일정이 삭제됩니다.(달력 1개 이하 삭제불가)", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "삭제", style: .default) { (action) in
            
            if self.calendarArray.count > 1 {
                self.deleteCalendarData()
            }
        }
        deleteAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }//선택 달력 삭제 기능
    
    private func deleteCalendarData() {
        guard let calendar = UserDefaults.standard.string(forKey: "currentCalendar") else{return}
        guard let index = self.calendarArray.firstIndex(of: calendar) else{return}
        
        if let user = Auth.auth().currentUser{
            db.collection(user.uid).document(calendar).delete()
            self.calendarArray.remove(at: index)
            UserDefaults.standard.set(self.calendarArray[0], forKey: "currentCalendar")
            
            self.categoryTableView.reloadData()
        }
        
    }//캘린더 데이터 삭제
    
    private func changeCalendarNameAlert() {
        let alert = UIAlertController(title: "제목변경", message: "변경할 제목을 입력해주세요.", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.textColor = .black
            textField.font = .systemFont(ofSize: 15)
        }
        
        let changeAction = UIAlertAction(title: "변경", style: .default) { (action) in
            
            let chooseNumber = UserDefaults.standard.integer(forKey: "checkIndex")
            
            if let text = alert.textFields?[0].text {
                self.calendarArray[chooseNumber] = text
                self.categoryTableView.reloadData()
            }
        }
        changeAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(changeAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }//선택 달력 이름 변경
    
    
    private func setCalendarData(calendarTitle : String) {
        if let user = Auth.auth().currentUser {
            db.collection(user.uid).document(calendarTitle).setData(["calendarName" : calendarTitle,
                                                                      "date" : Date().timeIntervalSince1970])
        }
    }//캘린더 추가 생성(개인 달력 추가생성에서 사용)
    
    private func getCurrentCalendars() {
        
        if let user = Auth.auth().currentUser {
            db.collection(user.uid).order(by: "date", descending: false).addSnapshotListener { querySnapShot, error in
                if let e = error {
                    print("Error get Calendars : \(e)")
                }else {
                    self.calendarArray = []
                    
                    if let snapShotDocument = querySnapShot?.documents {
                        for doc in snapShotDocument{
                            
                            let data = doc.data()
                            guard let calendarTitle = data["calendarName"] as? String else{return}
                            self.calendarArray.append(calendarTitle)
                        }
                    }
                    DispatchQueue.main.async {
                        self.categoryTableView.reloadData()
                    }
                }
            }
        }
    }//나의 캘린더들 가져오기
    
    private func getShareCalendars(){
        guard let user = Auth.auth().currentUser else{return}
        
        db.collection("\(user.uid).공유").addSnapshotListener { querySnapShot, error in
            if let e = error {
                print("Error find share user data : \(e)")
            }else{
                
                guard let snapShotDocuments = querySnapShot?.documents else{return}
                
                for doc in snapShotDocuments {
                    let data = doc.data()
                    guard let sender = data["sender"] as? String else{return}
                    self.getShareCalendarData(owner: sender)
                }
            }
        }
    }
    
    private func getShareCalendarData(owner : String){
        db.collection("\(owner).공유달력").order(by: "date", descending: false).addSnapshotListener { querySnapShot, error in
            if let e = error {
                print("Error share calendar data : \(e)")
            }else{
                self.shareCalendarArray = []
                guard let snapShotDocuments = querySnapShot?.documents else{return}
                
                for doc in snapShotDocuments {
                    let data = doc.data()
                    guard let calendarTitle = data["calendarTitle"] as? String else{return}
                    
                    self.shareCalendarArray.append(calendarTitle)
                    
                }
                DispatchQueue.main.async {
                    self.categoryTableView.reloadData()
                }
            }
        }
    }

}

//MARK: - Extension

extension CategoryViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return calendarArray.count
        }else {
            return shareCalendarArray.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MemoCustomTableViewCell.cellIdentifier, for: indexPath) as! MemoCustomTableViewCell
        
        
        if indexPath.section == 0 {
            cell.memoLabel.text = calendarArray[indexPath.row]
            if cell.memoLabel.text == UserDefaults.standard.string(forKey: "currentCalendar") {
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        }else {
            cell.memoLabel.text = shareCalendarArray[indexPath.row]
            
            if cell.memoLabel.text == UserDefaults.standard.string(forKey: "currentCalendar") {
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        }
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.backgroundColor = .white
        cell.tintColor = .customPastelBlue
        
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //섹션 헤더타이틀
        
        if section == 0 {
            return "개인 달력"
        }else {
            return "공유 달력"
        }
        
        return ""
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .clear
            headerView.textLabel?.textColor = .black
            headerView.textLabel?.font = .boldSystemFont(ofSize: 15)
        }
    }//headertitle에 컬러넣기
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }//각 섹션 사이의 간격
    
}




extension CategoryViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedItem = tableView.cellForRow(at: indexPath) as? MemoCustomTableViewCell else{return}
        
        UserDefaults.standard.set(selectedItem.memoLabel.text, forKey: "currentCalendar")
        
        tableView.reloadData()
        
        self.editingCalendarAlert()
        
        delegate?.dataChange()
    }
}

protocol ChangeDataDelegate {//다른 달력으로 변경했을 때 메인 뷰의 달력메모 데이터도 변경해주기.
    
    func dataChange() 
    
}
