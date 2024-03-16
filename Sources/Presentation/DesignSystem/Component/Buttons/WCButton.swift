//
//  WCButton.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 3/16/24.
//

import UIKit

/// 기본 버튼
final class WCButton: BaseButton {
    
    private let title: String
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
    }
    
    override func configureAttributes() {
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 17)
        layer.cornerRadius = 7
        clipsToBounds = true
        backgroundColor = .signatureColor
    }
}
