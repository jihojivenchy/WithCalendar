//
//  BaseTableHeaderFooterView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 3/22/24.
//

import UIKit

class BaseTableHeaderFooterView: UITableViewHeaderFooterView {
    
    // MARK: - Init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        configureAttributes()
        configureLayouts()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Configuration
    func configureAttributes() {

    }
    
    func configureLayouts() {
        
    }
}
