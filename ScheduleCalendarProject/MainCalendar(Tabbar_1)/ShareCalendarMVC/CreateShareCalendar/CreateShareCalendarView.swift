//
//  CreateShareCalendarView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class CreateShareCalendarView: UIView {
    //MARK: - Properties
    final let titleTextField = HoshiTextField()
    
    final let participantTableView = UITableView(frame: .zero, style: .grouped)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = 7
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.5
        
        addSubview(titleTextField)
        titleTextField.tintColor = .blackAndWhiteColor
        titleTextField.textColor = .blackAndWhiteColor
        titleTextField.returnKeyType = .done
        titleTextField.font = .boldSystemFont(ofSize: 18)
        titleTextField.placeholderFontScale = 0.7
        titleTextField.placeholder = "달력이름"
        titleTextField.placeholderColor = .darkGray
        titleTextField.borderInactiveColor = .clear
        titleTextField.borderActiveColor = .darkGray
        titleTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }
        
        
        addSubview(participantTableView)
        participantTableView.register(ParticipantTableViewCell.self, forCellReuseIdentifier: ParticipantTableViewCell.identifier)
        participantTableView.rowHeight = 70
        participantTableView.separatorStyle = .none
        participantTableView.backgroundColor = .clear
        participantTableView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp_bottomMargin).offset(15)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
