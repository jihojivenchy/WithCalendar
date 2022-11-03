//
//  MenuViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/11/02.
//

import UIKit
import SnapKit

final class MenuViewController: UIViewController {
//MARK: - Properties
    
    private let menuTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private lazy var categoryButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: nil)
        
        return button
    }()
    
//MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        navBarAppearance()
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.register(MemoCustomTableViewCell.self, forCellReuseIdentifier: MemoCustomTableViewCell.cellIdentifier)
    }
    

//MARK: - ViewMethod
            
    private func addSubViews() {
        view.backgroundColor = .customGray
    }
    
    private func navBarAppearance() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = categoryButton
        navigationItem.title = "설정"
        
        
    }
}
//MARK: - Extension

extension MenuViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MemoCustomTableViewCell.cellIdentifier, for: indexPath) as! MemoCustomTableViewCell
        
        cell.memoLabel.text = "ddddddddd"
        
        return cell
    }
    
    
}

extension MenuViewController : UITableViewDelegate {
    
}
