//
//  MemoDetailViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/11/24.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

class ReadSimpleMemoViewController: UIViewController {
//MARK: - Properties
    private let db = Firestore.firestore()
    
    private let dismissButton = UIButton()
    private let saveDataButton = UIButton()
    private let deleteButton = UIButton()
    
    var memoData = String()
    private let memoTextView = UITextView()
    
//MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotifications()
    }
    
//MARK: - ViewMethod
    
    private func addSubViews() {
        view.backgroundColor = .customGray
        
        view.addSubview(dismissButton)
        dismissButton.setBackgroundImage(UIImage(systemName: "x.circle"), for: .normal)
        dismissButton.tintColor = .darkGray
        dismissButton.addTarget(self, action: #selector(dismissButtonPressed(_:)), for: .touchUpInside)
        dismissButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.left.equalTo(view).inset(10)
            make.width.height.equalTo(35)
        }
        
        view.addSubview(saveDataButton)
        saveDataButton.setBackgroundImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        saveDataButton.tintColor = .darkGray
        saveDataButton.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
        saveDataButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.right.equalTo(view).inset(10)
            make.width.height.equalTo(35)
        }
        
        view.addSubview(deleteButton)
        deleteButton.setBackgroundImage(UIImage(systemName: "trash.circle"), for: .normal)
        deleteButton.tintColor = .darkGray
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed(_:)), for: .touchUpInside)
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.right.equalTo(saveDataButton.snp_leftMargin).offset(-20)
            make.width.height.equalTo(35)
        }
        
        view.addSubview(memoTextView)
        memoTextView.text = self.memoData
        memoTextView.tintColor = .black
        memoTextView.backgroundColor = .white
        memoTextView.returnKeyType = .next
        memoTextView.font = .systemFont(ofSize: 20)
        memoTextView.textColor = .black
        memoTextView.clipsToBounds = true
        memoTextView.layer.cornerRadius = 10
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(saveDataButton.snp_bottomMargin).offset(30)
            make.right.left.equalTo(view).inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
    }//뷰 터치 시 endEditing 발생
    
    private func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ sender : NSNotification){
        if let keyboardFrame : NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangel = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangel.height + 10
            
            self.memoTextView.snp.remakeConstraints { make in
                make.top.equalTo(saveDataButton.snp_bottomMargin).offset(30)
                make.right.left.equalTo(view).inset(20)
                make.bottom.equalToSuperview().inset(keyboardHeight)
            }
        }
    }
    
    @objc private func keyboardWillHide(_ sender : NSNotification){
        
        self.memoTextView.snp.remakeConstraints { make in
            make.top.equalTo(saveDataButton.snp_bottomMargin).offset(30)
            make.right.left.equalTo(view).inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func textAlert() {
        let alert = UIAlertController(title: "내용 없음", message: "내용을 적어주세요", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "확인", style: .default)
        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
//MARK: - ButtonMethod
    @objc private func dismissButtonPressed(_ sender : UIButton) {
        self.dismiss(animated: true)
    }
    
    
    @objc private func saveButtonPressed(_ sender : UIButton) {
        let dfMatter = DateFormatter()
        dfMatter.dateFormat = "yyyy년 MM월 dd일 HH:mm"
        let date = dfMatter.string(from: Date())
        
        guard let user = Auth.auth().currentUser else{return}
        guard let memo = self.memoTextView.text else{return}
        
        if memo != "" {
            self.setModifiedData(uid: user.uid, memo: memo, date: date)
        }else{
            self.textAlert()
        }
        
    }
    
    @objc private func deleteButtonPressed(_ sender : UIButton) {
        let alert = UIAlertController(title: "삭제", message: "정말 삭제하시겠습니까?", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "확인", style: .default) { action in
            self.deleteMemoData()
        }
        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        let cancleAction = UIAlertAction(title: "취소", style: .cancel)
        cancleAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(alertAction)
        alert.addAction(cancleAction)
        
        present(alert, animated: true, completion: nil)
    }

//MARK: - DataMethod
    
    private func setModifiedData(uid : String, memo : String, date : String) {
        db.collection("\(uid).메모").whereField("memo", isEqualTo: self.memoData).getDocuments { querySnapShot, error in
            if let e = error {
                print("Error get simple memo document : \(e)")
            }else{
                guard let snapShotDocuments = querySnapShot?.documents else{return}
                    
                for doc in snapShotDocuments {
                    self.db.collection("\(uid).메모").document(doc.documentID).setData(["memo" : memo,
                                                                                       "date" : date])
                }
                self.dismiss(animated: true)
            }
        }
    }
    
    
    private func deleteMemoData() {
        guard let user = Auth.auth().currentUser else{return}
        
        db.collection("\(user.uid).메모").whereField("memo", isEqualTo: self.memoData).getDocuments { querySnapShot, error in
            if let e = error {
                print("Error get simple memo document : \(e)")
            }else{
                guard let snapShotDocuments = querySnapShot?.documents else{return}
                    
                for doc in snapShotDocuments {
                    self.db.collection("\(user.uid).메모").document(doc.documentID).delete()
                }
                self.dismiss(animated: true)
            }
        }
    }
}

//MARK: - Extension

