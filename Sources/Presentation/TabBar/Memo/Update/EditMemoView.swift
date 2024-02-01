//
//  EditMemoView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class EditMemoView: UIView {
    //MARK: - Properties
   
    final let dismissButton = UIButton()
    final let saveButton = UIButton()
    final let deleteButton = UIButton()
    final let clipButton = UIButton()
    
    final let memoTextView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        self.backgroundColor = .customWhiteAndBlackColor
        
        addSubview(dismissButton)
        dismissButton.setBackgroundImage(UIImage(systemName: "x.circle"), for: .normal)
        dismissButton.tintColor = .lightGrayAndWhiteColor
        dismissButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(15)
            make.width.height.equalTo(30)
        }
        
        
        addSubview(deleteButton)
        deleteButton.setBackgroundImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = .lightGrayAndWhiteColor
        deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(19)
            make.right.equalToSuperview().inset(15)
            make.width.height.equalTo(25)
        }
        
        addSubview(clipButton)
        clipButton.setBackgroundImage(UIImage(systemName: "pin"), for: .normal)
        clipButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(19)
            make.right.equalToSuperview().inset(65)
            make.width.height.equalTo(25)
        }
        
        
        addSubview(saveButton)
        saveButton.isHidden = true
        saveButton.setBackgroundImage(UIImage(systemName: "checkmark"), for: .normal)
        saveButton.tintColor = .lightGrayAndWhiteColor
        saveButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(19)
            make.right.equalToSuperview().inset(15)
            make.width.height.equalTo(25)
        }
        
        
        addSubview(memoTextView)
        memoTextView.returnKeyType = .next
        memoTextView.font = .systemFont(ofSize: 18)
        memoTextView.textColor = .blackAndWhiteColor
        memoTextView.tintColor = .blackAndWhiteColor
        memoTextView.backgroundColor = .whiteAndCustomBlackColor
        memoTextView.clipsToBounds = true
        memoTextView.layer.cornerRadius = 7
        memoTextView.showsVerticalScrollIndicator = false
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(dismissButton.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(20)
        }
        
    }
}
