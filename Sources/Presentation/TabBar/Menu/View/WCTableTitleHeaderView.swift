//
//  WCTableTitleHeaderView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 3/22/24.
//

import UIKit
import SnapKit

final class WCTableTitleHeaderView: BaseTableHeaderFooterView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blackAndWhiteColor
        label.font = .boldSystemFont(ofSize: 19)
        return label
    }()
    
    override func configureLayouts() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
        }
    }
    
    func configure(titleText: String) {
        titleLabel.text = titleText
    }
}
