//
//  ShareCalendarViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/11/02.
//

import UIKit
import SnapKit

class ShareCalendarViewController: UIViewController {
//MARK: - Properties
    
    private lazy var searchBar : UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "닉네임을 입력해주세요."
        sb.delegate = self
        sb.tintColor = .black
        
        return sb
    }()
    
    private lazy var cancelButton : UIBarButtonItem = {
        let cb = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(cancelAction(_:)))
        
        return cb
    }()
    
    private let userIdTabelView = UITableView(frame: .zero, style: .insetGrouped)
    
//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        navBarAppearance()
        
        userIdTabelView.register(MemoCustomTableViewCell.self, forCellReuseIdentifier: MemoCustomTableViewCell.cellIdentifier)
        userIdTabelView.delegate = self
        userIdTabelView.dataSource = self
        userIdTabelView.rowHeight = 80
    }
    
//MARK: - ViewMethod
    private func addSubViews() {
        view.backgroundColor = .customGray
        
        view.addSubview(userIdTabelView)
        userIdTabelView.backgroundColor = .customGray
        userIdTabelView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.right.left.equalTo(view)
        }
        
    }
    
    private func navBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = cancelButton
        searchBar.becomeFirstResponder()
    }
    
//MARK: - ButtonMethod
    
    @objc func cancelAction(_ sender : UIBarButtonItem) {
        searchBar.resignFirstResponder()
    }
    

}

//MARK: - Extension

extension ShareCalendarViewController : UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        if let searchText = searchBar.text{
            print(searchText)
        }
        
    }
}


extension ShareCalendarViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MemoCustomTableViewCell.cellIdentifier, for: indexPath) as! MemoCustomTableViewCell
        
        
        cell.memoLabel.text = "지호쓰"
        cell.backgroundColor = .white
        cell.separatorInset = UIEdgeInsets.zero
        
        
        return cell
    }
    
}

extension ShareCalendarViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
