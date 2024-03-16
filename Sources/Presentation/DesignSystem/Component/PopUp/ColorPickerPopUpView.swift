//
//  ColorPickerPopUpView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 3/16/24.
//

import UIKit
import SnapKit

/// 컬러를 선택하는 팝업 뷰
final class ColorPickerPopUpView: BasePopUpView {
    // MARK: - UI
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
        collectionView.backgroundColor = .clear
        collectionView.register(SetColorCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    // MARK: - Property
    override var containerHeight: CGFloat { 420 }
    override var dismissYPosition: CGFloat { 220 }
    
    // MARK: - Configuration
    override func configureAttributes() {
        super.configureAttributes()
        addTapGestureForHide()
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        super.configureLayouts()
        container.addSubview(collectionView)
        
        container.snp.makeConstraints { make in
            make.top.equalTo(self.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(containerHeight)
        }
        
        dragHandleBar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(25)
            make.height.equalTo(5)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(dragHandleBar.snp_bottomMargin).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(280)
        }
        
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(55)
        }
    }
}

// MARK: - CompositionalLayout
extension ColorPickerPopUpView {
    private func configureLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / 5),
            heightDimension: .absolute(70)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(70)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - Data Source
extension ColorPickerPopUpView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ColorCollection.hexValues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(SetColorCollectionViewCell.self, for: indexPath) else {
            return UICollectionViewCell()
        }
        
        cell.colorImageView.backgroundColor = UIColor(ColorCollection.hexValues[indexPath.row])
        
//        
//        if setColorDataModel.selectedColor == color {
//            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
//        }
        
        return cell
    }
}

extension ColorPickerPopUpView: UICollectionViewDelegate {
    
}
