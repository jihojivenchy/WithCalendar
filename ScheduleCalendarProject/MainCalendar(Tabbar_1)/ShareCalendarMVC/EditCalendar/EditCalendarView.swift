//
//  EditCalendarView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit
import TextFieldEffects

final class EditCalendarView: UIView {
    //MARK: - Properties
    final let titleTextField = HoshiTextField()
    
    final let editTableView = UITableView(frame: .zero, style: .grouped)
    final let editButton = UIButton()
    
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
        
        addSubview(editTableView)
        editTableView.register(ParticipantTableViewCell.self, forCellReuseIdentifier: ParticipantTableViewCell.identifier)
        editTableView.rowHeight = 70
        editTableView.separatorStyle = .none
        editTableView.backgroundColor = .clear
        editTableView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp_bottomMargin).offset(15)
            make.left.right.bottom.equalToSuperview()
        }
        
        addSubview(editButton)
        editButton.layer.shadowColor = UIColor.black.cgColor
        editButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        editButton.layer.shadowRadius = 10
        editButton.layer.shadowOpacity = 0.5
        editButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
        }
    }
    
    
}
