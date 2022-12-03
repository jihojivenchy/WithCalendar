//
//  SetMemoDataViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/11/24.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

class WriteSimpleMemoViewController: UIViewController {
//MARK: - Properties
    private let db = Firestore.firestore()
    
    private lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(saveButtonPressed(_:)))
        
        return button
    }()
    
    private let memoTextView = UITextView()
    
    
//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        navBarAppearance()
    }
    
//MARK: - ViewMethod
    
    private func addSubViews() {
        view.backgroundColor = .customGray

        view.addSubview(memoTextView)
        memoTextView.tintColor = .black
        memoTextView.becomeFirstResponder()
        memoTextView.backgroundColor = .white
        memoTextView.returnKeyType = .next
        memoTextView.font = .systemFont(ofSize: 20)
        memoTextView.textColor = .black
        memoTextView.clipsToBounds = true
        memoTextView.layer.cornerRadius = 10
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.right.left.equalTo(view).inset(20)
            make.height.equalTo(300)
        }
    }
    
    private func navBarAppearance() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = saveButton
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
    }//뷰 터치 시 endEditing 발생
    
//MARK: - ButtonMethod
    @objc private func saveButtonPressed(_ sender : UIBarButtonItem){
        let dfMatter = DateFormatter()
        dfMatter.dateFormat = "yyyy년 MM월 dd일 HH:mm"
        let date = dfMatter.string(from: Date())
        
        guard let memo = self.memoTextView.text else{return}
        
        if memo != "" {
            
            if let user = Auth.auth().currentUser {
                db.collection("\(user.uid).메모").addDocument(data: ["memo" : memo,
                                                                   "date" : date])
                self.navigationController?.popViewController(animated: true)
            }else{
                setAlert(message: "로그인", secondMessage: "로그인 해주세요")
            }
        }else{
            setAlert(message: "내용 없음", secondMessage: "내용을 적어주세요")
        }
    }
    
    
    private func setAlert(message : String, secondMessage : String) {
        let alert = UIAlertController(title: message, message: secondMessage, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "확인", style: .default)
        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
//MARK: - Extension

