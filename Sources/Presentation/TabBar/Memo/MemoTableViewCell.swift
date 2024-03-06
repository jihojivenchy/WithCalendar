//
//  MemoTableViewCell.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class MemoTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let identifier = "MemoTableViewCell"
    
    private var longPressGestureRecognizer: UILongPressGestureRecognizer!
    final weak var cellDelegate : MemoCellDelegate?
    final var indexSection = Int() //롱프레스 제스쳐를 취했을 때, 어느 섹션에 있는 데이터인지 파악하도록.
    final var indexRow = Int() //섹션과 같은의미
    
    final let containerView = UIView()
    final let titleLabel = UILabel()
    final let dateLabel = UILabel()
    final let clipImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
        
        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler(gestureRecognizer:)))
        longPressGestureRecognizer.minimumPressDuration = 0.5 //최소 0.5초간 눌러줘야함.
        addGestureRecognizer(longPressGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        self.backgroundColor = .clear
        
        addSubview(containerView)
        containerView.backgroundColor = .whiteAndCustomBlackColor
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.left.right.equalToSuperview().inset(10)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.customize(textColor: UIColor.blackAndWhiteColor!, backgroundColor: .clear, fontSize: 18, alignment: .left)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(17)
            make.left.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(60)
            make.height.equalTo(20)
        }
        
        containerView.addSubview(dateLabel)
        dateLabel.customize(textColor: .darkGray, backgroundColor: .clear, fontSize: 11, alignment: .left)
        dateLabel.sizeToFit()
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(14)
            make.left.equalToSuperview().inset(15)
        }
        
        containerView.addSubview(clipImageView)
        clipImageView.isHidden = true
        clipImageView.image = UIImage(systemName: "pin")
        clipImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
            make.width.height.equalTo(25)
        }
    }
    
    //cell을 길게 눌렀을 때
    @objc private func longPressHandler(gestureRecognizer: UILongPressGestureRecognizer) {
        // Perform a fine vibration when the long press gesture is completed
        if gestureRecognizer.state == .began {
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
            feedbackGenerator.prepare()
            feedbackGenerator.impactOccurred()
            
            cellDelegate?.cellLognPressed(indexSection: indexSection, indexRow: indexRow)
        }
    }
}

protocol MemoCellDelegate : AnyObject {
    func cellLognPressed(indexSection: Int, indexRow: Int)
}