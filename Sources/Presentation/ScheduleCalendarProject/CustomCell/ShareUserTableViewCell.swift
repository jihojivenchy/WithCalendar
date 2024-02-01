//
//  FollowUserTableViewCell.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/12/19.
//

import UIKit
import SnapKit
import AudioToolbox

class ShareUserTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "FollowUserCell"
    
    var delegate : FollowCellGestureDelegate?
    var index = Int()
    
    private let followBackView = UIView()
    let followImageView = UIImageView()
    let followLabel = UILabel()
   
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(cellLongPressed(_:))))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        
        addSubview(followBackView)
        followBackView.clipsToBounds = true
        followBackView.layer.cornerRadius = 10
        followBackView.backgroundColor = .displayModeColor3
        followBackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.right.left.equalToSuperview()
        }
        
        followBackView.addSubview(followImageView)
        followImageView.tintColor = .displayModeColor2
        followImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(10)
            make.height.width.equalTo(25)
        }
        
        followBackView.addSubview(followLabel)
        followLabel.textColor = .displayModeColor2
        followLabel.font = .boldSystemFont(ofSize: 14.5)
        followLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(followImageView.snp_rightMargin).offset(15)
            make.right.equalToSuperview().inset((self.accessoryView?.frame.size.width ?? 30) + 15)
            make.height.equalTo(30)
        }
    }
    
    @objc private func cellLongPressed(_ sender : UILongPressGestureRecognizer){

        if sender.state == UIGestureRecognizer.State.began {
            AudioServicesPlaySystemSound(1520)
            
            self.delegate?.cellPressed(index: index)
        }
    }
}

protocol FollowCellGestureDelegate {
    func cellPressed(index : Int)
}
