//
//  PlaceholderView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 3/26/24.
//

import UIKit
import SnapKit

final class PlaceholderView: BaseView {
    private let container = UIView()
    
    private let emojiImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .blackAndWhiteColor
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    override func configureLayouts() {
        addSubview(container)
        container.addSubview(emojiImageView)
        container.addSubview(titleLabel)
        container.addSubview(descriptionLabel)
        
        container.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(150)
        }
        
        emojiImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(70)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(emojiImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(20)
        }
    }
}

extension PlaceholderView {
    enum PlaceholderType {
        case needSignIn
        case emptyMemo
        case error
    }
    
    struct PlaceholderConfiguration {
        let title: String
        let description: String
    }
    
    func configure(for type: PlaceholderType, configuration: PlaceholderConfiguration? = nil) {
        switch type {
        case .needSignIn:
            emojiImageView.image = UIImage(named: "crying")?.resize(to: CGSize(width: 70, height: 70))
            titleLabel.text = "로그인이 필요합니다."
            descriptionLabel.text = "로그인 후 사용 가능한 기능입니다."
            
        case .emptyMemo:
            emojiImageView.image = UIImage(named: "suspicious")?.resize(to: CGSize(width: 70, height: 70))
            titleLabel.text = "작성된 메모가 없습니다."
            descriptionLabel.text = "새로운 메모를 작성해보세요."
            
        case .error:
            emojiImageView.image = UIImage(named: "thinking")?.resize(to: CGSize(width: 70, height: 70))
            titleLabel.text = "오류가 발생했습니다."
            descriptionLabel.text = "잠시 후 다시 시도해 주세요."
            
        }
        
        if let configuration {
            titleLabel.text = configuration.title
            descriptionLabel.text = configuration.description
        }
    }
}
