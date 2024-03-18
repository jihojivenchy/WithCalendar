//
//  ColorPickerCell.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 3/16/24.
//

import UIKit
import SnapKit

final class ColorPickerCell: BaseCollectionViewCell {
    // MARK: - UI
    private let colorPreviewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 34 / 2
        return imageView
    }()
    
    private lazy var colorWell: UIColorWell = {
        let colorWell = UIColorWell()
        colorWell.isUserInteractionEnabled = false
        return colorWell
    }()
    
    // MARK: - Layouts
    override func configureLayouts() {
        addSubview(colorPreviewImageView)
        addSubview(colorWell)
        
        colorPreviewImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(34)
        }
        
        colorWell.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(34)
        }
    }
    
    override var isSelected: Bool {
        willSet {
            updateSelectionStateImage(newValue)
        }
    }
    
    private func updateSelectionStateImage(_ selected: Bool) {
        if selected {
            colorPreviewImageView.image = UIImage(systemName: "checkmark.circle")
        }else{
            colorPreviewImageView.image = .none
        }
    }
}

// MARK: - Configure
extension ColorPickerCell {
    func configure(hexColorString: String) {
        colorPreviewImageView.backgroundColor = UIColor(hexColorString)
        colorPreviewImageView.isHidden = hexColorString == "ColorWell" ? true : false
        colorWell.isHidden = hexColorString == "ColorWell" ? false : true
    }
}
