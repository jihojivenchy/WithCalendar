//
//  MenuView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class MenuView: UIView {
    //MARK: - Properties
    
    final let menuTableview = UITableView(frame: .zero, style: .insetGrouped)
    
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
        
        addSubview(menuTableview)
        menuTableview.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.identifier)
        menuTableview.rowHeight = 70
        menuTableview.backgroundColor = .clear
        menuTableview.separatorStyle = .none
        menuTableview.showsVerticalScrollIndicator = false
        menuTableview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }
}
