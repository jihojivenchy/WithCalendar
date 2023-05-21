//
//  WelcomeView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit
import Lottie

final class WelcomeView: UIView {
    //MARK: - Properties
    
    final let progressBar = UIProgressView()
    final let titleLabel = UILabel()
    
    final let animationView = LottieAnimationView(name: "calendar")
    
    final let homeButton = UIButton()

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
        
        addSubview(progressBar)
        progressBar.backgroundColor = .lightGray
        progressBar.progress = 1
        progressBar.progressTintColor = .signatureColor
        progressBar.layer.cornerRadius = 2
        progressBar.clipsToBounds = true
        progressBar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(7)
        }
        
        addSubview(titleLabel)
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .blackAndWhiteColor
        titleLabel.font = .boldSystemFont(ofSize: 25)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp_bottomMargin).offset(15)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(90)
        }
        
        addSubview(animationView)
        animationView.play()
        animationView.loopMode = .loop
        animationView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottomMargin).offset(60)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(300)
        }
        
        addSubview(homeButton)
        homeButton.customize(title: "홈으로", titleColor: .white, backgroundColor: UIColor.signatureColor!, fontSize: 17, cornerRadius: 7)
        homeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(60)
        }
    }
}

