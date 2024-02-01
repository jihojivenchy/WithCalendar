//
//  TextStackViewTableViewCell.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/12/13.
//

import UIKit
import SnapKit

class CategoryTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "TextStackViewCell"
    
    let memoTextView = UITextView()
    
    var check : Bool = true
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        
        
        
        
//        addSubview(memoTextView)
//        memoTextView.tintColor = .displayModeColor2
//        memoTextView.returnKeyType = .next
//        memoTextView.font = .systemFont(ofSize: 20)
//        memoTextView.textColor = .displayModeColor2
//        memoTextView.clipsToBounds = true
//        memoTextView.layer.cornerRadius = 10
//        memoTextView.snp.makeConstraints { make in
//            make.edges.equalToSuperview().inset(15)
//        }
    }
    
    
}
