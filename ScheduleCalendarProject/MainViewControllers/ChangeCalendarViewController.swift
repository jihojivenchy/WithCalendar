//
//  ChangeCalendarViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/11/02.
//

import UIKit
import SnapKit

final class ChangeCalendarViewController: UIViewController {
//MARK: - Properties
    
    private let categoryTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private lazy var addRightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonPressed(_:)))
        
        return button
    }()
    
    private let navigationBackButton = UIBarButtonItem(title: nil, style: .plain, target: self, action: nil)
    
    private var calendarArray : [String] = ["지호쓰캘린더", "모둠캘린더"]
    
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
            make.height.equalTo(250)
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

    private func addCalendarAlert() { //달력 추가하기
        let alert = UIAlertController(title: "달력 추가", message: "달력은 총 3개까지 만들 수 있습니다.", preferredStyle: .alert)
        
        let shardAction = UIAlertAction(title: "공유달력 만들기", style: .default) { (action) in
            if self.calendarArray.count < 3 {
                self.navigationController?.pushViewController(ShareCalendarViewController(), animated: true)
            }else {
                self.warningAlert()
            }
        }
        shardAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        let addAction = UIAlertAction(title: "개인달력 만들기", style: .default) { (action) in
            if self.calendarArray.count < 3 {
                self.addPersonalCalendarAlert()
            }else {
                self.warningAlert()
            }
            
        }
        addAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
    
        alert.addAction(shardAction)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func editingCalendarAlert() { //선택 달력 편집하기
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
    }
    
    private func deleteAlert() {
        let alert = UIAlertController(title: "현재 선택된 달력을 삭제하시겠습니까?", message: "달력에 저장된 모든 일정이 삭제됩니다.", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "삭제", style: .default) { (action) in
            let chooseNumber = UserDefaults.standard.integer(forKey: "checkIndex")
            
            self.calendarArray.remove(at: chooseNumber)
            self.categoryTableView.reloadData()
        }
        deleteAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
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
    }
    
    private func addPersonalCalendarAlert() {
        let alert = UIAlertController(title: "추가", message: "추가 할 달력제목을 입력해주세요.", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.textColor = .black
            textField.font = .systemFont(ofSize: 15)
        }
        
        let changeAction = UIAlertAction(title: "추가", style: .default) { (action) in
            
            if let text = alert.textFields?[0].text {
                self.calendarArray.append(text)
                self.categoryTableView.reloadData()
            }
            
        }
        changeAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(changeAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func warningAlert() {
        let alert = UIAlertController(title: "달력은 3개까지만 만들 수 있어요!", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }

}

//MARK: - Extension

extension ChangeCalendarViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendarArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MemoCustomTableViewCell.cellIdentifier, for: indexPath) as! MemoCustomTableViewCell
        
        
        cell.memoLabel.text = calendarArray[indexPath.row]
        cell.separatorInset = UIEdgeInsets.zero
        cell.backgroundColor = .white
        cell.tintColor = .black
        
        if indexPath.row == UserDefaults.standard.integer(forKey: "checkIndex") {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        
        return cell
    }
    
}

extension ChangeCalendarViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.indexPathForSelectedRow?.row == 0 {
            UserDefaults.standard.set(0, forKey: "checkIndex")
            tableView.reloadData()
        }else if tableView.indexPathForSelectedRow?.row == 1{
            UserDefaults.standard.set(1, forKey: "checkIndex")
            tableView.reloadData()
        }else {
            UserDefaults.standard.set(2, forKey: "checkIndex")
            tableView.reloadData()
        }
        
        self.editingCalendarAlert()
        
    }
}
