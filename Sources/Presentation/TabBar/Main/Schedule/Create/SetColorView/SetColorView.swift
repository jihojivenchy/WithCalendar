//
//  SetColorView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class SetColorView: UIView {
    //MARK: - Properties
    
    final let titleLabel = UILabel()
    final let colorWell = UIColorWell()
    final let colorCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = .zero
        layout.minimumInteritemSpacing = .zero
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SetColorCollectionViewCell.self, forCellWithReuseIdentifier: SetColorCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        self.backgroundColor = .whiteAndCustomBlackColor
        self.layer.cornerRadius = 7
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.5
       
        addSubview(titleLabel)
        titleLabel.text = "Color"
        titleLabel.configure(textColor: UIColor.signatureColor!, backgroundColor: .clear, fontSize: 18, alignment: .center)
        titleLabel.sizeToFit()
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        addSubview(colorWell)
        colorWell.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(15)
        }
        
        addSubview(colorCollectionView)
        colorCollectionView.showsVerticalScrollIndicator = false
        colorCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(35)
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
        }
        
    }
    
}
