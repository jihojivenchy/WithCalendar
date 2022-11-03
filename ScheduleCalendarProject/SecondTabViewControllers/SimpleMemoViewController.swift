//
//  SimpleMemoViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/11/02.
//

import UIKit
import SnapKit

final class SimpleMemoViewController: UIViewController {

//MARK: - Properties
    
    private let memoTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private lazy var addRightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(ddd(_:)))
        
        return button
        
    }()
    
    
//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubViews()
        navBarAppearance()
        
        memoTableView.delegate = self
        memoTableView.dataSource = self
        memoTableView.register(MemoCustomTableViewCell.self, forCellReuseIdentifier: MemoCustomTableViewCell.cellIdentifier)
        memoTableView.rowHeight = 70
    }
    
//MARK: - ViewMethod
        
        private func addSubViews() {
            view.backgroundColor = .white
            
            view.addSubview(memoTableView)
            memoTableView.backgroundColor = .customGray
            memoTableView.snp.makeConstraints { make in
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
            navigationController?.hidesBarsOnSwipe = true
            
    //        navigationItem.backBarButtonItem = backButton
            navigationItem.title = "메모"
            navigationItem.rightBarButtonItem = addRightButton
            
            
        }
    
    @objc private func ddd(_ sender: UIBarButtonItem) {
        let vc = ScheduleViewController()
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true)
    }
    
}

//MARK: - Extension

extension SimpleMemoViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MemoCustomTableViewCell.cellIdentifier, for: indexPath) as! MemoCustomTableViewCell
        
        
        cell.memoLabel.text = "ddddddddd"
        cell.separatorInset = UIEdgeInsets.zero
        cell.backgroundColor = .white
    
        
        return cell
    }
    
}

extension SimpleMemoViewController : UITableViewDelegate {
    
}
