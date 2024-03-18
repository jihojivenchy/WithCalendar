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
        collectionView.register(ColorPickerCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    // MARK: - Property
    override var containerHeight: CGFloat { 420 }
    override var dismissYPosition: CGFloat { 220 }
    
    weak var delegate: ColorPickerDelegate?
    var selectedColor = String()
    
    // MARK: - Configuration
    override func configureAttributes() {
        super.configureAttributes()
        addTapGestureForHide(shouldCancelTouchesInView: false)
    }
    
    // MARK: - Layouts
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
        guard let cell = collectionView.dequeueReusableCell(ColorPickerCell.self, for: indexPath) else {
            return UICollectionViewCell()
        }
        
        cell.configure(hexColorString: ColorCollection.hexValues[indexPath.row])
        
        if selectedColor == ColorCollection.hexValues[indexPath.row] {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
        } else {
            collectionView.deselectItem(at: indexPath, animated: false)
        }
        
        return cell
    }
}

// MARK: - Delegate
extension ColorPickerPopUpView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        triggerHapticFeedback()
        selectedColor = ColorCollection.hexValues[indexPath.row]
        
        // delegate에게 전달
        if selectedColor == "ColorWell" {
            delegate?.showColorPickerController()
        }
    }
}

extension ColorPickerPopUpView {
    /// 유저에게 리액션을 주기 위한 미세한 진동음
    func triggerHapticFeedback() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
    }
}

/// ColorPickerPopupView에 대한 델리게이트 프로토콜
protocol ColorPickerDelegate: AnyObject {
    /// ColorPickerPopUpView -> UIColorWell이 들어있는 Cell 클릭 -> Controller에서 ColorPickerVC를 보여주기
    func showColorPickerController()
    func completedButtonTapped(_ selectedColorHexString: String)
}

