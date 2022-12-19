//
//  FollowCategoryCalViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/12/19.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

class FollowCategoryCalViewController: UIViewController {
    //MARK: - Properties
    private let db = Firestore.firestore()
    private var calendarCategoryArray : [String] = []
    
    var uid : String = ""{
        didSet{
            getFollowUserCalendars(uid: uid)
        }
    }
    
    private let categoryTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private lazy var navigationBackButton : UIBarButtonItem = {
        let button = UIBarButtonItem(title: nil, style: .plain, target: self, action: nil)
        return button
    }()
    
//MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        navBarAppearance()
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.cellIdentifier)
        categoryTableView.rowHeight = 70
    }
    
//MARK: - ViewMethod
    
    private func addSubViews() {
        view.backgroundColor = .displayModeColor1
        
        view.addSubview(categoryTableView)
        categoryTableView.showsVerticalScrollIndicator = false
        categoryTableView.backgroundColor = .displayModeColor1
        categoryTableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func navBarAppearance() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.title = "목록"
        navigationItem.backBarButtonItem = navigationBackButton
        
        self.navigationController?.navigationBar.tintColor = .displayModeColor2
    }
    
    
//MARK: - ButtonMethod
    
    private func getFollowUserCalendars(uid : String) {
        
        db.collection(uid).whereField("mode", isEqualTo: "true").addSnapshotListener { querySnapShot, error in
            if let e = error {
                print("Error get Calendars : \(e)")
            }else {
                self.calendarCategoryArray = []
                
                if let snapShotDocument = querySnapShot?.documents {
                    for doc in snapShotDocument{
                        
                        let data = doc.data()
                        guard let nameData = data["calendarName"] as? String else{return}
                        
                        self.calendarCategoryArray.append(nameData)
                    }
                }
                DispatchQueue.main.async {
                    self.categoryTableView.reloadData()
                }
            }
        }
    }//나의 캘린더들 가져오기
    
}

//MARK: - Extension

extension FollowCategoryCalViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendarCategoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.cellIdentifier, for: indexPath) as! CategoryTableViewCell
        
        
        cell.categoryLabel.text = self.calendarCategoryArray[indexPath.row]
        cell.categoryImageView.image = UIImage(systemName: "calendar")
        
        cell.backgroundColor = .clear
        cell.accessoryType = .disclosureIndicator
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .displayModeColor3
        cell.selectedBackgroundView = backgroundView
        
        
        return cell
    }
}




extension FollowCategoryCalViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = FollowUserCalendarViewController()
        vc.uid = self.uid
        vc.calendarName = self.calendarCategoryArray[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
