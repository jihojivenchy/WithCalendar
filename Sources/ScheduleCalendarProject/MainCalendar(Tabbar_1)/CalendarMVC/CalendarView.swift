//
//  CalendarView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class CalendarView: UIView {
    //MARK: - Properties
    final weak var swipeDelegate : CalendarSwipeDelegate?
    
    final let titleLabel = UILabel()
    final let weekStackView = UIStackView()
    
    final let calendarCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = .zero
        layout.minimumInteritemSpacing = .zero
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    final let goTodayButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubViews()
        setupWeekStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(plusMonth(_:)))
        swipeRight.direction = .left
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(minusMonth(_:)))
        swipeLeft.direction = .right
        
        self.backgroundColor = .whiteAndCustomBlackColor
        self.layer.cornerRadius = 7
        self.clipsToBounds = true
        
        addSubview(titleLabel)
        titleLabel.customize(textColor: UIColor.blackAndWhiteColor!, backgroundColor: .clear, fontSize: 18, alignment: .center)
        titleLabel.sizeToFit()
        titleLabel.isUserInteractionEnabled = true
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        addSubview(goTodayButton)
        goTodayButton.isHidden = true
        goTodayButton.setTitle("Today", for: .normal)
        goTodayButton.setTitleColor(.blackAndWhiteColor, for: .normal)
        goTodayButton.titleLabel?.font = .boldSystemFont(ofSize: 11)
        goTodayButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(20)
        }
        
        addSubview(weekStackView)
        weekStackView.backgroundColor = .clear
        weekStackView.distribution = .fillEqually
        weekStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        addSubview(calendarCollectionView)
        calendarCollectionView.showsVerticalScrollIndicator = false
        calendarCollectionView.addGestureRecognizer(swipeLeft)
        calendarCollectionView.addGestureRecognizer(swipeRight)
        calendarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(weekStackView.snp_bottomMargin).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
        
    }
    
    private func setupWeekStackView() {
        let weekArray = ["일", "월", "화", "수", "목", "금", "토"]
        
        for i in weekArray {
            let label = UILabel()
            label.text = i
            label.customize(textColor: UIColor.blackAndWhiteColor!, backgroundColor: .clear, fontSize: 11, alignment: .center)
            
            if i == "일" {
                label.textColor = .customRedColor
            }else if i == "토" {
                label.textColor = .customBlueColor
            }
            
            self.weekStackView.addArrangedSubview(label)
        }
    }
    
    @objc func minusMonth(_ sender : UISwipeGestureRecognizer) {
        self.swipeDelegate?.minusMonthGesture()
    }
    
    @objc func plusMonth(_ sender : UISwipeGestureRecognizer) {
        self.swipeDelegate?.plusMonthGesture()
    }
}


protocol CalendarSwipeDelegate : AnyObject { //유저가 Swipe 제스처를 취했을 때, Controller에게 전달할 수 있도록.
    func plusMonthGesture()
    func minusMonthGesture()
}
