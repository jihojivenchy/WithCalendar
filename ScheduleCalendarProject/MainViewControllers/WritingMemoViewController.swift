//
//  WritingMemoViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/11/02.
//

import UIKit
import SnapKit

final class WritingMemoViewController: UIViewController {
//MARK: - Properties
    
    private let memoView = UIView()
    private let memoLabel = UILabel()
    private let memoTextView = UITextView()
    
    private let saveMemoDataButton = UIButton()
    
    
    
//MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        memoTextView.text = UserDefaults.standard.string(forKey: "writedMemo")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        
    }
    
    //MARK: - ViewMethod
    
    private func addSubViews() {
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        
        view.addSubview(memoLabel)
        memoLabel.text = "메모"
        memoLabel.textColor = .black
        memoLabel.font = .boldSystemFont(ofSize: 20)
        memoLabel.sizeToFit()
        memoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(15)
        }
        
        view.addSubview(saveMemoDataButton)
        saveMemoDataButton.addTarget(self, action: #selector(saveDataButtonPressed(_:)), for: .touchUpInside)
        saveMemoDataButton.setTitle("완료", for: .normal)
        saveMemoDataButton.setTitleColor(.black, for: .normal)
        saveMemoDataButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        saveMemoDataButton.snp.makeConstraints { make in
            make.centerY.equalTo(memoLabel)
            make.right.equalToSuperview().inset(15)
        }
        
        view.addSubview(memoTextView)
        memoTextView.backgroundColor = .white
        memoTextView.returnKeyType = .next
        memoTextView.font = .systemFont(ofSize: 20)
        memoTextView.textColor = .black
        memoTextView.becomeFirstResponder()
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(memoLabel.snp_bottomMargin).offset(40)
            make.right.left.equalTo(view).inset(15)
            make.height.equalTo(300)
        }
       
    }
    
    @objc private func saveDataButtonPressed(_ sender : UIButton) {
        if let text = self.memoTextView.text {
            UserDefaults.standard.set(text, forKey: "writedMemo")
        }
        
        
        self.dismiss(animated: true)
    }

}

