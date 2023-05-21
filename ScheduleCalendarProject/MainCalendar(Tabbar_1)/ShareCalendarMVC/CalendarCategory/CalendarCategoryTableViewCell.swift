//
//  CalendarCategoryTableViewCell.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class CalendarCategoryTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let identifier = "CalendarCategoryTableViewCell"
    
    private var longPressGestureRecognizer: UILongPressGestureRecognizer!
    
    final weak var calendarCategoryCellDelegate : CalendarCategoryCellDelegate?
    final var indexRow = Int()
    
    final let containerView = UIView()
    final let calendarImageView = UIImageView()
    final let titleLabel = UILabel()
    
    final let personImageView = UIImageView()
    final let personCountLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
        setLongGesture()
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
            make.left.right.equalToSuperview()
        }
        
        containerView.addSubview(calendarImageView)
        calendarImageView.image = UIImage(systemName: "calendar")
        calendarImageView.tintColor = .blackAndWhiteColor
        calendarImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
            make.width.height.equalTo(22)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.customize(textColor: UIColor.blackAndWhiteColor!, backgroundColor: .clear, fontSize: 16, alignment: .left)
        titleLabel.sizeToFit()
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(calendarImageView)
            make.left.equalTo(calendarImageView.snp_rightMargin).offset(15)
        }
        
        containerView.addSubview(personImageView)
        personImageView.isHidden = true
        personImageView.image = UIImage(systemName: "person.circle")
        personImageView.tintColor = .darkGray
        personImageView.snp.makeConstraints { make in
            make.centerY.equalTo(calendarImageView)
            make.left.equalTo(titleLabel.snp_rightMargin).offset(25)
            make.width.height.equalTo(15)
        }
        
        containerView.addSubview(personCountLabel)
        personCountLabel.customize(textColor: .darkGray, backgroundColor: .clear, fontSize: 13, alignment: .left)
        personCountLabel.isHidden = true
        personCountLabel.sizeToFit()
        personCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(calendarImageView)
            make.left.equalTo(personImageView.snp_rightMargin).offset(10)
        }
        
    }
    
    private func setLongGesture() {
        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler(gestureRecognizer:)))
        longPressGestureRecognizer.minimumPressDuration = 0.5 //최소 0.5초간 눌러줘야함.
        addGestureRecognizer(longPressGestureRecognizer)
    }
    
    //cell을 길게 눌렀을 때
    @objc private func longPressHandler(gestureRecognizer: UILongPressGestureRecognizer) {
        // Perform a fine vibration when the long press gesture is completed
        if gestureRecognizer.state == .began {
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
            feedbackGenerator.prepare()
            feedbackGenerator.impactOccurred()
            
            calendarCategoryCellDelegate?.sendIndexRow(indexRow: self.indexRow)
        }
    }
    
}

protocol CalendarCategoryCellDelegate : AnyObject {
    func sendIndexRow(indexRow: Int)
}
