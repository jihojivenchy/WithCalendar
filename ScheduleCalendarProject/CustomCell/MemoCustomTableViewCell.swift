//
//  MemoCustomTableViewCell.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/11/02.
//

import UIKit
import SnapKit

class MemoCustomTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "MemoCustomCell"
    
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
        memoLabel.font = .systemFont(ofSize: 20)
        memoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(10)
            make.height.equalToSuperview()
        }
    }

}
