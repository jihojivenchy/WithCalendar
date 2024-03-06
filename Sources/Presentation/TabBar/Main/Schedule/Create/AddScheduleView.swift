//
//  AddScheduleView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class AddScheduleView: UIView {
    //MARK: - Properties
    final let titleTextField = WCTextField()
    
    final let dismissButton = UIButton()
    final let saveButton = UIButton()
    final let deleteButton = UIButton()
    final let addScheduleTableView = UITableView(frame: .zero, style: .grouped)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        self.backgroundColor = .whiteAndCustomBlackColor
        
        addSubview(dismissButton)
        dismissButton.setBackgroundImage(UIImage(systemName: "x.circle"), for: .normal)
        dismissButton.tintColor = .signatureColor
        dismissButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(15)
            make.width.height.equalTo(25)
        }
        
        addSubview(saveButton)
        saveButton.setBackgroundImage(UIImage(systemName: "checkmark"), for: .normal)
        saveButton.tintColor = .signatureColor
        saveButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(17)
            make.right.equalToSuperview().inset(15)
            make.width.height.equalTo(22)
        }
        
        addSubview(deleteButton)
        deleteButton.setBackgroundImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.isHidden = true
        deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(17)
            make.right.equalToSuperview().inset(60)
            make.width.height.equalTo(22)
        }
        
        addSubview(titleTextField)
        titleTextField.tintColor = .blackAndWhiteColor
        titleTextField.textColor = .blackAndWhiteColor
        titleTextField.returnKeyType = .done
        titleTextField.font = .systemFont(ofSize: 20)
        titleTextField.placeholderFontScale = 0.7
        titleTextField.placeholder = "제목"
        titleTextField.placeholderColor = .signatureColor ?? UIColor()
        titleTextField.borderInactiveColor = .clear
        titleTextField.borderActiveColor = .signatureColor
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(saveButton.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }
        
        
        addSubview(addScheduleTableView)
        addScheduleTableView.register(AddScheduleTableViewCell.self, forCellReuseIdentifier: AddScheduleTableViewCell.identifier)
        addScheduleTableView.register(DateTimeModeSelectionTableViewCell.self, forCellReuseIdentifier: DateTimeModeSelectionTableViewCell.identifier)
        addScheduleTableView.rowHeight = 70
        addScheduleTableView.backgroundColor = .clear
        addScheduleTableView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp_bottomMargin)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
