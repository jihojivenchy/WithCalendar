//
//  UserInformationViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/11/17.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

final class RequestViewController: UIViewController {

//MARK: - Properties
    private let db = Firestore.firestore()
    final var delegate : RequestViewDelegate?
    
    private let backgroundView = UIView()
    private let personImageView = UIImageView()
    final let nameLabel = UILabel()
    final var uid = String()
    
    private let inviteButton = UIButton()
    private let calcelButton = UIButton()
    
//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
    }
    
//MARK: - ViewMethod
    
    private func addSubViews(){
        view.backgroundColor = .clear
        
        view.addSubview(backgroundView)
        backgroundView.clipsToBounds = true
        backgroundView.layer.masksToBounds = false
        backgroundView.layer.cornerRadius = 10
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundView.layer.shadowRadius = 10
        backgroundView.layer.shadowOpacity = 0.5
        backgroundView.backgroundColor = .displayModeColor3
        backgroundView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(230)
        }
        
        backgroundView.addSubview(personImageView)
        personImageView.image = UIImage(systemName: "person.crop.circle")
        personImageView.tintColor = .displayModeColor2
        personImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(35)
        }
        
        backgroundView.addSubview(nameLabel)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .displayModeColor2
        nameLabel.font = .boldSystemFont(ofSize: 17)
        nameLabel.sizeToFit()
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(personImageView.snp_bottomMargin).offset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        backgroundView.addSubview(inviteButton)
        inviteButton.addTarget(self, action: #selector(inviteButtonPressed(_:)), for: .touchUpInside)
        inviteButton.setTitle("초대하기", for: .normal)
        inviteButton.setTitleColor(.white, for: .normal)
        inviteButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        inviteButton.clipsToBounds = true
        inviteButton.layer.cornerRadius = 10
        inviteButton.backgroundColor = .customSignatureColor
        inviteButton.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        
        backgroundView.addSubview(calcelButton)
        calcelButton.addTarget(self, action: #selector(calcelButtonPressed(_:)), for: .touchUpInside)
        calcelButton.setTitle("취소", for: .normal)
        calcelButton.setTitleColor(.displayModeColor2, for: .normal)
        calcelButton.clipsToBounds = true
        calcelButton.layer.cornerRadius = 10
        calcelButton.snp.makeConstraints { make in
            make.top.equalTo(inviteButton.snp_bottomMargin).offset(20)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(30)
        }
        
    }

//MARK: - ButtonMethod
    
    @objc private func inviteButtonPressed(_ sender : UIButton) {
        guard let name = nameLabel.text else{return}
        delegate?.invitePressed(name: name, uid: self.uid)
        self.dismiss(animated: true)
    }
    
    
    @objc private func calcelButtonPressed(_ sender : UIButton) {
        self.dismiss(animated: true)
    }
}

protocol RequestViewDelegate {
    func invitePressed(name : String, uid : String)
}
