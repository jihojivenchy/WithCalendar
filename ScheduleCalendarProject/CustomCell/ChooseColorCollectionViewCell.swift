//
//  ChooseColorCollectionViewCell.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/11/02.
//

import UIKit
import SnapKit

class ChooseColorCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ChooseColorCell"
    
    let colorImage = UIImageView()
    
    override init(frame: CGRect) {
            super.init(frame: frame)
        
        self.addSubviews()
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        
        addSubview(colorImage)
        colorImage.clipsToBounds = true
        colorImage.layer.cornerRadius = 20
        colorImage.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
    }
}
