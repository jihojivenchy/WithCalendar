//
//  TodoListTableViewCell.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/11/02.
//

import UIKit
import SnapKit

class TodoListTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "todoListCell"
    
    let memoLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        
        addSubview(memoLabel)
        memoLabel.textColor = .black
        memoLabel.textAlignment = .center
        memoLabel.font = .systemFont(ofSize: 10)
        memoLabel.layer.cornerRadius = 5
        memoLabel.clipsToBounds = true
        memoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(45)
            make.height.equalTo(12)
        }
        
    }

}
