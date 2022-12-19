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
    
    private let backgroundView = UIView()
    
    private let personImageView = UIImageView()
    
    let nameLabel = UILabel()
    var userUid = String()
    var myName = String()
    
    private let explainLabel = UILabel()
    
    private let yesButton = UIButton()
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
            make.width.equalTo(300)
            make.height.equalTo(300)
        }
        
        backgroundView.addSubview(personImageView)
        personImageView.image = UIImage(systemName: "person.crop.circle")
        personImageView.tintColor = .displayModeColor2
        personImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        backgroundView.addSubview(nameLabel)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .displayModeColor2
        nameLabel.font = .boldSystemFont(ofSize: 20)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(personImageView.snp_bottomMargin).offset(30)
            make.right.left.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        backgroundView.addSubview(explainLabel)
        explainLabel.text = "Follow"
        explainLabel.numberOfLines = 2
        explainLabel.textColor = .displayModeColor2
        explainLabel.textAlignment = .center
        explainLabel.font = .boldSystemFont(ofSize: 16)
        explainLabel.clipsToBounds = true
        explainLabel.layer.cornerRadius = 10
        explainLabel.layer.borderWidth = 1
        explainLabel.layer.borderColor = UIColor.displayModeColor2?.cgColor
        explainLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp_bottomMargin).offset(35)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(100)
            make.centerX.equalToSuperview()
        }
        
        backgroundView.addSubview(yesButton)
        yesButton.addTarget(self, action: #selector(yesButtonPressed(_:)), for: .touchUpInside)
        yesButton.setTitle("확인", for: .normal)
        yesButton.setTitleColor(.displayModeColor2, for: .normal)
        yesButton.clipsToBounds = true
        yesButton.layer.cornerRadius = 10
        yesButton.layer.borderColor = UIColor.displayModeColor2?.cgColor
        yesButton.layer.borderWidth = 1
        yesButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(15)
            make.left.equalToSuperview().inset(20)
            make.width.equalTo(115)
            make.height.equalTo(33)
        }
        
        backgroundView.addSubview(calcelButton)
        calcelButton.addTarget(self, action: #selector(calcelButtonPressed(_:)), for: .touchUpInside)
        calcelButton.setTitle("취소", for: .normal)
        calcelButton.setTitleColor(.displayModeColor2, for: .normal)
        calcelButton.clipsToBounds = true
        calcelButton.layer.cornerRadius = 10
        calcelButton.layer.borderColor = UIColor.displayModeColor2?.cgColor
        calcelButton.layer.borderWidth = 1
        calcelButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(20)
            make.width.equalTo(115)
            make.height.equalTo(33)
        }
        
    }

//MARK: - ButtonMethod
    
    @objc private func yesButtonPressed(_ sender : UIButton) {
        doubleCheck()
    }
    
    private func doubleCheck() {
        guard let name = nameLabel.text else{return}
        
        if let user = Auth.auth().currentUser {
            db.collection("\(user.uid).팔로잉").whereField("name", isEqualTo: name).getDocuments { querySnapShot, error in
                if let e = error {
                    print("Error Check User : \(e)")
                }else{
                    if querySnapShot!.documents.isEmpty {
                        self.setFollowingUserData(myUid: user.uid, userName: name)
                    }
                    
                    self.dismiss(animated: true)
                }
            }
        }else{
            setAlert(title: "로그인", subTitle: "로그인이 필요합니다.")
        }
        
    }
    
    private func setFollowingUserData(myUid : String, userName : String) {
        
        db.collection("\(myUid).팔로잉").document(userUid).setData(["name" : userName,
                                                                     "uid" : userUid])
        
        db.collection("\(userUid).팔로워").document(myUid).setData(["name" : myName,
                                                                     "uid" : myUid])
    }
    
   
    private func setAlert(title : String, subTitle : String) {
        let alert = UIAlertController(title: title, message: subTitle, preferredStyle: .alert)
        
        let loginAction = UIAlertAction(title: "확인", style: .default)
        loginAction.setValue(UIColor.displayModeColor2, forKey: "titleTextColor")
        
        
        alert.addAction(loginAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @objc private func calcelButtonPressed(_ sender : UIButton) {
        self.dismiss(animated: true)
    }

}
