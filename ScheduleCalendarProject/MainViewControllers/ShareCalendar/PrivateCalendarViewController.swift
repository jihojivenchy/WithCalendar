//
//  PrivateCalendarViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/01/02.
//

import UIKit
import SnapKit
import FirebaseAuth

final class PrivateCalendarViewController: UIViewController {
//MARK: - Properties
    final var delegate : PrivateCalendarCellDelegate?
    private let privateCalendarTableView = UITableView(frame: .zero, style: .insetGrouped)
    
//MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        
        privateCalendarTableView.delegate = self
        privateCalendarTableView.dataSource = self
        privateCalendarTableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.cellIdentifier)
        privateCalendarTableView.rowHeight = 70
        privateCalendarTableView.separatorStyle = .none
    }
    
    //MARK: - ViewMethod
    private func addSubViews() {
        
        view.backgroundColor = .displayModeColor1
        
        view.addSubview(privateCalendarTableView)
        privateCalendarTableView.backgroundColor = .clear
        privateCalendarTableView.showsVerticalScrollIndicator = false
        privateCalendarTableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
//MARK: - DataMethod
}

//MARK: - Extension
extension PrivateCalendarViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.cellIdentifier, for: indexPath) as! CategoryTableViewCell
        
        cell.categoryImageView.image = UIImage(systemName: "calendar")
        cell.categoryLabel.text = "With Calendar"
        cell.personImageView.isHidden = true
        cell.tintColor = .customSignatureColor
        
        cell.backgroundColor = .clear
        cell.accessoryType = .checkmark
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.displayModeColor3
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
}

extension PrivateCalendarViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = Auth.auth().currentUser else{return}
        UserDefaults.standard.set(user.uid, forKey: "currentCollection")
        UserDefaults.standard.set("With Calendar", forKey: "currentDocument")
        UserDefaults.standard.set("With Calendar", forKey: "currentCalendarName")
        
        delegate?.privateCellPressed()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

protocol PrivateCalendarCellDelegate {
    func privateCellPressed()
}
