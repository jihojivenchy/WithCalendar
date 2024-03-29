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
        collectionView.isScrollEnabled = false
        collectionView.register(ColorPickerCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    // MARK: - Property
    override var containerHeight: CGFloat { 420 }
    override var dismissYPosition: CGFloat { 220 }
    
    weak var delegate: ColorPickerDelegate?
    
    /// 컬러 리스트(마지막 인덱스는 ColorPickerVC에 의해 선택된 컬러)
    private var colorCollection = ColorCollection()
    
    /// 선택된 컬러
    var selectedColorHexString = String()
    
    // MARK: - Configuration
    override func configureAttributes() {
        super.configureAttributes()
        container.backgroundColor = .whiteAndCustomBlackColor
        addTapGestureForHide(shouldCancelTouchesInView: false)
        completeButton.addTarget(self, action: #selector(completeButtonTapped(_:)), for: .touchUpInside)
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
        return colorCollection.hexValues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(ColorPickerCell.self, for: indexPath) else {
            return UICollectionViewCell()
        }
        
        cell.configure(
            hexColorString: colorCollection.hexValues[indexPath.row],
            isLastIndex: indexPath.row == 19
        )
        
        if selectedColorHexString == colorCollection.hexValues[indexPath.row] {
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
        selectedColorHexString = colorCollection.hexValues[indexPath.row]
        
        // 마지막 인덱스일 경우, delegate를 통해 ColorPicker를 보여줌.
        if indexPath.row == 19 {
            delegate?.showColorPickerController()
        }
    }
}

// MARK: - Methods
extension ColorPickerPopUpView {
    /// ColorPickerVC에 의해 선택된 컬러로 업데이트
    func updateColorCollection(_ colorHexString: String) {
        selectedColorHexString = colorHexString
        colorCollection.hexValues.removeLast()
        colorCollection.hexValues.append(colorHexString)
        collectionView.reloadData()
    }
    
    /// 유저에게 리액션을 주기 위한 미세한 진동음
    private func triggerHapticFeedback() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
    }
    
    @objc private func completeButtonTapped(_ sender : UIButton) {
        delegate?.completedButtonTapped(selectedColorHexString)
        hide()
    }
}

/// ColorPickerPopupView에 대한 델리게이트 프로토콜
protocol ColorPickerDelegate: AnyObject {
    /// ColorPickerPopUpView -> UIColorWell이 들어있는 Cell 클릭 -> Controller에서 ColorPickerVC를 보여주기
    func showColorPickerController()
    func completedButtonTapped(_ selectedColorHexString: String)
}
