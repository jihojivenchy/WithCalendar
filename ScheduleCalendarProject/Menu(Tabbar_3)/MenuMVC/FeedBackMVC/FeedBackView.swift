//
//  FeedBackView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class FeedBackView: UIView {
    //MARK: - Properties
    
    final let sendButton = UIButton()

    final let goToCenterButton : UIButton = {
        let button = UIButton()
        
        return button
    }()

    private let containerView = UIView()
    final let feedBackTextView : UITextView = {
        let tv = UITextView()
        
        return tv
    }()


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
        
        addSubview(containerView)
        containerView.backgroundColor = .whiteAndCustomBlackColor
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 7
        containerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(25)
            make.height.equalTo(280)
        }
        
        containerView.addSubview(feedBackTextView)
        feedBackTextView.returnKeyType = .next
        feedBackTextView.font = .systemFont(ofSize: 20)
        feedBackTextView.textColor = .lightGray
        feedBackTextView.tintColor = .blackAndWhiteColor
        feedBackTextView.backgroundColor = .clear
        feedBackTextView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        addSubview(sendButton)
        sendButton.customize(title: "보내기 ", titleColor: .white, backgroundColor: UIColor.signatureColor!, fontSize: 17, cornerRadius: 7)
        sendButton.setImage(UIImage(systemName: "paperplane"), for: .normal)
        sendButton.tintColor = .white
        sendButton.semanticContentAttribute = .forceRightToLeft
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp_bottomMargin).offset(50)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(55)
        }
        
        addSubview(goToCenterButton)
        goToCenterButton.customize(title: "고객센터 바로가기", titleColor: .white, backgroundColor: UIColor.signatureColor!, fontSize: 17, cornerRadius: 7)
        goToCenterButton.snp.makeConstraints { make in
            make.top.equalTo(sendButton.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(55)
        }
        
    }
}

