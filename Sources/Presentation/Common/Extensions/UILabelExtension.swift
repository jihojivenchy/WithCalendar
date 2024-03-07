//
//  UILabelExtension.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit

extension UILabel {
    func configure(textColor: UIColor, backgroundColor: UIColor, fontSize: CGFloat, alignment: NSTextAlignment) {
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.font = .boldSystemFont(ofSize: fontSize)
        self.textAlignment = alignment
    }
}
