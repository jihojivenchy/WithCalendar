//
//  ScheduleManagerTableViewCell.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class ScheduleManagerTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let identifier = "ScheduleManagerTableViewCell"
    
    private var longPressGestureRecognizer: UILongPressGestureRecognizer!
    final weak var scheduleMangerCellDelegate : ScheduleManagerCellDelegate?
    
    final let titleColorView = UIView()
    final let titleLabel = UILabel()
    final let subTitleLabel = UILabel()
    
    final var indexRow = Int()
    
    //MARK: - cell 내부 레이아웃에 관련된 프로퍼티로 모드에 따라 변경해줘야 함.
    final var mode : Int? {
        didSet {
            setupLayout()
        }
    }
    
    private var titleLabelTopConstraint: Constraint?
    private var titleLabelCenterYConstraint: Constraint?
    
    //MARK: - init
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
        
        addSubview(titleColorView)
        titleColorView.clipsToBounds = true
        titleColorView.layer.cornerRadius = 3
        titleColorView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(10)
            make.width.equalTo(4.5)
            make.height.equalTo(40)
        }
        
        addSubview(titleLabel)
        titleLabel.customize(textColor: UIColor.blackAndWhiteColor!, backgroundColor: .clear, fontSize: 16, alignment: .left)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(titleColorView.snp_rightMargin).offset(15)
            make.right.equalToSuperview().inset(20)
            
            //mode에 따라 레이아웃을 다르게.
            titleLabelTopConstraint = make.top.equalToSuperview().inset(15).constraint
            titleLabelCenterYConstraint = make.centerY.equalTo(titleColorView).constraint
        }
        
        addSubview(subTitleLabel)
        subTitleLabel.customize(textColor: .darkGray, backgroundColor: .clear, fontSize: 11, alignment: .left)
        subTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(titleColorView.snp_rightMargin).offset(15)
            make.right.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(12)
        }
    }
    
    
    private func setupLayout() {
        
        switch mode {
            
        case 0:
            subTitleLabel.isHidden = false
            titleLabelCenterYConstraint?.deactivate()
            titleLabelTopConstraint?.activate()
            
        case 1:
            subTitleLabel.isHidden = true
            titleLabelCenterYConstraint?.activate()
            titleLabelTopConstraint?.deactivate()
            
        default:
            break
        }
    }
    
    //cell을 클릭했을 때, 애니메이션
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            // When cell is highlighted, scale down to 95% of its original size
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            })
        } else {
            // When the user lifts their finger, restore the cell to its original size
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = .identity
            })
        }
    }

    //롱 제스처 설정.
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
            
            scheduleMangerCellDelegate?.sendIndexRow(indexRow: self.indexRow)
        }
    }
    
}

protocol ScheduleManagerCellDelegate : AnyObject {
    func sendIndexRow(indexRow: Int)
}
