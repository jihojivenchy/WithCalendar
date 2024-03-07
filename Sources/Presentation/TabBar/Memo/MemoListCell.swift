//
//  MemoListCell.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit
import UIColorHexSwift

final class MemoListCell: BaseTableViewCell {
    // MARK: - UI
    private let backgroundContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteAndCustomBlackColor
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blackAndWhiteColor
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .boldSystemFont(ofSize: 11)
        return label
    }()
    
    private let clipImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.image = UIImage(systemName: "pin")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    // MARK: - Properties
    private var longPressGestureRecognizer: UILongPressGestureRecognizer!
    weak var delegate : MemoCellDelegate?
    
    private var dataDocumentID = String()
    
    // MARK: - Configuration
    override func configureAttributes() {
        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler(gestureRecognizer:)))
        longPressGestureRecognizer.minimumPressDuration = 0.5 //최소 0.5초간 눌러줘야함.
        addGestureRecognizer(longPressGestureRecognizer)
    }
    
    // MARK: - Layouts
    override func configureLayouts() {
        addSubview(backgroundContainer)
        backgroundContainer.addSubview(titleLabel)
        backgroundContainer.addSubview(dateLabel)
        backgroundContainer.addSubview(clipImageView)
        
        // 컨테이너
        backgroundContainer.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.left.right.equalToSuperview().inset(10)
        }
        
        // 제목
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(17)
            make.left.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(60)
            make.height.equalTo(20)
        }
        
        // 날짜 표시 라벨
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(14)
            make.left.equalToSuperview().inset(15)
        }
        
        // 클립 이미지
        clipImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
            make.width.height.equalTo(25)
        }
    }
    
    @objc private func longPressHandler(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
            feedbackGenerator.prepare()
            feedbackGenerator.impactOccurred()
            
            delegate?.longPressed(documentID: dataDocumentID)
        }
    }
}

extension MemoListCell {
    func configure(memoData: MemoData) {
        dataDocumentID = memoData.documentID
        titleLabel.text = memoData.memo
        dateLabel.text = memoData.date
        clipImageView.tintColor = UIColor(memoData.fixColor)
        clipImageView.isHidden = memoData.fix == 0 ? true : false
    }
}

protocol MemoCellDelegate: AnyObject {
    func longPressed(documentID: String)
}
