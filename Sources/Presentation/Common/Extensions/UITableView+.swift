//
//  UITableView+.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2/1/24.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_ cellClass: T.Type) {
        register(cellClass.self, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func register<T: UITableViewHeaderFooterView>(_ viewClass: T.Type) {
        register(viewClass.self, forHeaderFooterViewReuseIdentifier: viewClass.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T? {
        dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier, for: indexPath) as? T
    }
    
    func dequeueReusableHeaderView<T: UITableViewHeaderFooterView>(_ viewClass: T.Type) -> T? {
        dequeueReusableHeaderFooterView(withIdentifier: viewClass.reuseIdentifier) as? T
    }
}
