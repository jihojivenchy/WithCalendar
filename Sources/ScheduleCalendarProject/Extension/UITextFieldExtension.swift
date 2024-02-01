//
//  UITextFieldExtension.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit

extension UITextField {
    
    func customize(placeHolder: String, textColor: UIColor, tintColor: UIColor, fontSize: CGFloat, backgroundColor: UIColor) {
        self.returnKeyType = .done
        self.placeholder = placeHolder
        self.textColor = textColor
        self.tintColor = tintColor
        self.font = .boldSystemFont(ofSize: fontSize)
        self.backgroundColor = backgroundColor
    }
    
}
