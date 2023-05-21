//
//  UIButtonExtension.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit

extension UIButton {
    //버튼 계속 사용되는 코드 묶어서 공용으로 사용.
    func customize(title: String, titleColor: UIColor, backgroundColor: UIColor, fontSize: CGFloat, cornerRadius: CGFloat) {
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: fontSize)
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        self.backgroundColor = backgroundColor
    }
    
    //button에 언더라인 추가
    func setUnderLine() {
        guard let title = title(for: .normal) else{return}
        
        let attributed = NSMutableAttributedString(string: title)
        attributed.addAttribute(.underlineStyle,
                                value: NSUnderlineStyle.single.rawValue,
                                range: NSRange(location: 0, length: title.count))
        
        setAttributedTitle(attributed, for: .normal)
    }
}
