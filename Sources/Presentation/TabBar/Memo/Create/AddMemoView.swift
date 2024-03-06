//
//  AddMemoView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class AddMemoView: UIView {
    //MARK: - Properties
   
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
        
        
        addSubview(memoTextView)
        memoTextView.becomeFirstResponder()
        memoTextView.returnKeyType = .next
        memoTextView.font = .systemFont(ofSize: 18)
        memoTextView.textColor = .blackAndWhiteColor
        memoTextView.tintColor = .blackAndWhiteColor
        memoTextView.backgroundColor = .whiteAndCustomBlackColor
        memoTextView.clipsToBounds = true
        memoTextView.layer.cornerRadius = 7
        memoTextView.showsVerticalScrollIndicator = false
        memoTextView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        
    }
}
