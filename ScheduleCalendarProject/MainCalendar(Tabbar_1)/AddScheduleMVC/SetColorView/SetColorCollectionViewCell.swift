//
//  SetColorCollectionViewCell.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class SetColorCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "SetColorCollectionViewCell"
    
    final let colorImageView = UIImageView()
    
    override init(frame: CGRect) {
            super.init(frame: frame)
        
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewMethod
    func setupSubViews() {
        self.backgroundColor = .clear
        
        addSubview(colorImageView)
        colorImageView.tintColor = .white
        colorImageView.clipsToBounds = true
        colorImageView.layer.cornerRadius = 34 / 2
        colorImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(34)
        }
    }
    
    //animations나 completion 내에서 self에 대한 참조가 있지만, 순환참조가 발생하지 않는다.
    //UIView.animate method retains only the animation parameters until the animation completes or the view is deallocated.
    override var isSelected : Bool {
        didSet{
            if isSelected {
                colorImageView.image = UIImage(systemName: "checkmark.circle")
            }else{
                colorImageView.image = .none
            }
        }
    }
}
