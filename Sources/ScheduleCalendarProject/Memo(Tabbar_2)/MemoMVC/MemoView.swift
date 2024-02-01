//
//  MemoView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class MemoView: UIView {
    //MARK: - Properties
    final let memoTableview = UITableView(frame: .zero, style: .grouped)
    
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
        
        addSubview(memoTableview)
        memoTableview.register(MemoTableViewCell.self, forCellReuseIdentifier: MemoTableViewCell.identifier)
        memoTableview.rowHeight = 80
        memoTableview.backgroundColor = .clear
        memoTableview.separatorStyle = .none
        memoTableview.showsVerticalScrollIndicator = false
//        memoTableview.contentInset = .zero
//        memoTableview.contentInsetAdjustmentBehavior = .never
        memoTableview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }
}
