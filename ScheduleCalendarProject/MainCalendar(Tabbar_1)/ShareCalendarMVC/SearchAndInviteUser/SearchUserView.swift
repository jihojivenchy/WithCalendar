//
//  SearchUserView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class SearchUserView: UIView {
    //MARK: - Properties
    final let userTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        self.backgroundColor = .clear
        
        addSubview(userTableView)
        userTableView.register(OptionTableViewCell.self, forCellReuseIdentifier: OptionTableViewCell.identifier)
        userTableView.rowHeight = 70
        userTableView.separatorStyle = .none
        userTableView.backgroundColor = .clear
        userTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
