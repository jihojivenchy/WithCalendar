//
//  SetMemoView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class SetMemoView: UIView {
    //MARK: - Properties
    
    final let titleLabel = UILabel()
    final let doneButton = UIButton()
    
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
        self.backgroundColor = .whiteAndCustomBlackColor
        
        addSubview(titleLabel)
        titleLabel.text = "메모"
        titleLabel.configure(textColor: UIColor.blackAndWhiteColor!, backgroundColor: .clear, fontSize: 18, alignment: .center)
        titleLabel.sizeToFit()
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        addSubview(doneButton)
        doneButton.setTitle("완료", for: .normal)
        doneButton.setTitleColor(.blackAndWhiteColor, for: .normal)
        doneButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        doneButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(20)
        }
        
        addSubview(memoTextView)
        memoTextView.becomeFirstResponder()
        memoTextView.returnKeyType = .next
        memoTextView.font = .systemFont(ofSize: 17)
        memoTextView.textColor = .blackAndWhiteColor
        memoTextView.tintColor = .blackAndWhiteColor
        memoTextView.backgroundColor = .clear
        memoTextView.showsVerticalScrollIndicator = false
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(320)
        }
        
    }
}
