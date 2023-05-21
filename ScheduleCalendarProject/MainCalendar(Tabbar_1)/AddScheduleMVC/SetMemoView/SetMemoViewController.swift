//
//  SetMemoViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class SetMemoViewController: UIViewController {
    //MARK: - Properties
    final let setMemoView = SetMemoView() //View
    final var setMemoDelegate : SetMemoDelegate?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubViews()
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        view.backgroundColor = .clear
        
        view.addSubview(setMemoView)
        setMemoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setMemoView.doneButton.addTarget(self, action: #selector(doneButtonClicked(_:)), for: .touchUpInside)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: - ButtonMethod
    @objc private func doneButtonClicked(_ sender : UIButton) {
        self.dismiss(animated: true)
        guard let memo = setMemoView.memoTextView.text else{return}
        
        if memo == "" {
            setMemoDelegate?.sendMemo(memo: "")
        }else{
            setMemoDelegate?.sendMemo(memo: memo)
        }
    }
}

protocol SetMemoDelegate : AnyObject {
    func sendMemo(memo: String)
}
