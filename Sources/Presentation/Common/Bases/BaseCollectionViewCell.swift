//
//  BaseCollectionViewCell.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2/1/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        configureAttributes()
        configureLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 기타 속성들을 설정하기 위한 메서드
    func configureAttributes() { }
    
    /// UI와 관련된 속성들(뷰 계층, 레이아웃 등)을 설정하기 위한 메서드
    func configureLayouts() { }
}
