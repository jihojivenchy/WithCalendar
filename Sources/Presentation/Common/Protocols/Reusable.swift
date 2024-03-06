//
//  Reusable.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2/1/24.
//

import UIKit

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}

extension UITableViewCell: Reusable { }
extension UICollectionReusableView: Reusable { }
