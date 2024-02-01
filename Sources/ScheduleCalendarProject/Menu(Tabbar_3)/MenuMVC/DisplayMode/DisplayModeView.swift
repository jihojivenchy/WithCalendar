//
//  DisplayModeView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class DisplayModeView: UIView {
    //MARK: - Properties
    
    final let optionsTableview = UITableView(frame: .zero, style: .insetGrouped)
    
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
        
        addSubview(optionsTableview)
        optionsTableview.rowHeight = 75
        optionsTableview.backgroundColor = .clear
        optionsTableview.separatorStyle = .none
        optionsTableview.showsVerticalScrollIndicator = false
        optionsTableview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }
}
