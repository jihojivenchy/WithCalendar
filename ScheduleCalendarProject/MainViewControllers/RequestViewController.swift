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
    let emailLabel = UILabel()
    var userUid = ""
    var myName = ""
    
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
        backgroundView.backgroundColor = .customGray
        backgroundView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(350)
        }
        
        backgroundView.addSubview(personImageView)
        personImageView.image = UIImage(systemName: "person.crop.circle")
        personImageView.tintColor = .black
        personImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        backgroundView.addSubview(nameLabel)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .black
        nameLabel.font = .boldSystemFont(ofSize: 20)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(personImageView.snp_bottomMargin).offset(30)
            make.right.left.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        backgroundView.addSubview(emailLabel)
        emailLabel.textAlignment = .center
        emailLabel.textColor = .black
        emailLabel.font = .boldSystemFont(ofSize: 20)
        emailLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp_bottomMargin).offset(20)
            make.right.left.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        backgroundView.addSubview(explainLabel)
        explainLabel.text = "공유 달력을 요청하시겠습니까? \n(공유 달력은 1개만 생성 가능)"
        explainLabel.numberOfLines = 2
        explainLabel.textColor = .black
        explainLabel.textAlignment = .center
        explainLabel.font = .boldSystemFont(ofSize: 16)
        explainLabel.clipsToBounds = true
        explainLabel.layer.cornerRadius = 10
        explainLabel.layer.borderWidth = 1
        explainLabel.layer.borderColor = UIColor.black.cgColor
        explainLabel.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp_bottomMargin).offset(35)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(110)
            make.centerX.equalToSuperview()
        }
        
        backgroundView.addSubview(yesButton)
        yesButton.addTarget(self, action: #selector(yesButtonPressed(_:)), for: .touchUpInside)
        yesButton.setTitle("요청", for: .normal)
        yesButton.setTitleColor(.black, for: .normal)
        yesButton.clipsToBounds = true
        yesButton.layer.cornerRadius = 10
        yesButton.layer.borderColor = UIColor.black.cgColor
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
        calcelButton.setTitleColor(.black, for: .normal)
        calcelButton.clipsToBounds = true
        calcelButton.layer.cornerRadius = 10
        calcelButton.layer.borderColor = UIColor.black.cgColor
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
        
        addPersonalCalendarAlert()
    }
    
    private func addPersonalCalendarAlert() {
        let alert = UIAlertController(title: "요청", message: "달력 제목을 입력해주세요.", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.textColor = .black
            textField.font = .systemFont(ofSize: 15)
        }
        
        let changeAction = UIAlertAction(title: "요청", style: .default) { (action) in
            
            guard let text = alert.textFields?[0].text else{return}
            guard let user = Auth.auth().currentUser else{return self.setAlert(title: "로그인", subTitle: "로그인이 필요합니다.")}
            
            if user.uid != self.userUid { //본인에게 요청하는 지 확인
                
                if text != "" { //달력의 이름을 적었는지
                    let dFMatter = DateFormatter()
                    dFMatter.dateFormat = "yyyy년 MM월 dd일 HH:mm"
                    let date = dFMatter.string(from: Date())
                    
                    self.db.collection("\(self.userUid)요청").addDocument(data: ["calendarTitle" : text,
                                                                               "sender" : self.myName,
                                                                                "date" : date])
                    self.dismiss(animated: true)
                }else{
                    self.setAlert(title: "달력 이름을 적어주세요.", subTitle: "")
                }
            }
            
            
        }
        changeAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(changeAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func setAlert(title : String, subTitle : String) {
        let alert = UIAlertController(title: title, message: subTitle, preferredStyle: .alert)
        
        let loginAction = UIAlertAction(title: "확인", style: .default)
        loginAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        
        alert.addAction(loginAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @objc private func calcelButtonPressed(_ sender : UIButton) {
        self.dismiss(animated: true)
    }

}
