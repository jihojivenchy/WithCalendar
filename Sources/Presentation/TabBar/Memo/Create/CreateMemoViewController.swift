//
//  AddMemoViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class CreateMemoViewController: BaseViewController {
    // MARK: - UI
    private lazy var pinButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "pin.slash"),
            style: .done,
            target: self,
            action: #selector(pinButtonTapped(_:))
        )
    
        return button
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.returnKeyType = .next
        textView.font = .systemFont(ofSize: 18)
        textView.textColor = .blackAndWhiteColor
        textView.tintColor = .blackAndWhiteColor
        textView.backgroundColor = .whiteAndCustomBlackColor
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 7
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 10, bottom: 0, right: 10)
        return textView
    }()
    
    private lazy var completeButton: WCButton = {
        let button = WCButton(title: "완료")
        button.addTarget(self, action: #selector(completeButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private let loadingView = WCLoadingView()
    private lazy var colorPickerPopUpView: ColorPickerPopUpView = {
        let view = ColorPickerPopUpView()
        view.delegate = self
        return view
    }()
    
    // MARK: - Properties
    private let memoService = MemoService()
    private var memoData = MemoData(
        memo: "",
        date: "",
        fix: 0,
        fixColor: "",
        documentID: ""
    )
    
    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        addKeyboardNotifications()
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        removeKeyboardNotifications()
    }
    
    // MARK: Configuration
    override func configureAttributes() {
        view.backgroundColor = .customWhiteAndBlackColor
        navigationItem.title = "메모 작성"
        navigationItem.rightBarButtonItem = pinButton
        enableKeyboardHiding()
    }
    
    // MARK: - Layouts
    override func configureLayouts() {
        view.addSubview(textView)
        view.addSubview(completeButton)
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(95)
            make.left.right.equalToSuperview().inset(15)
        }
        
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(textView.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(55)
        }
    }
    
    // MARK: - ButtonMethod
    @objc private func pinButtonTapped(_ sender : UIBarButtonItem) {
        textView.endEditing(true)
        colorPickerPopUpView.show()
//        // fixColor가 비어있을 경우, 아직 고정핀 설정을 하지 않았음. 고정핀 컬러 설정 뷰 보여주기
//        if memoData.fixColor.isEmpty {
//            setClipColor()
//            memoData.fixColor = "#00925BFF"
//            pinButton.image = UIImage(systemName: "pin") //클립 이미지 변경.
//            pinButton.tintColor = .signatureColor
//            
//        } else {  // 원상복구
//            memoData.fixColor = ""
//            pinButton.image = UIImage(systemName: "pin.slash")
//            pinButton.tintColor = .blackAndWhiteColor
//        }
    }
    
    @objc private func completeButtonTapped(_ sender : UIButton) {
        guard let text = textView.text, !text.isEmpty else {
            showAlert(title: "내용을 작성해주세요.")
            return
        }
        
        memoData.date = Date().convertDateToString(format: "yyyy년 MM월 dd일 HH시 mm분")
        memoData.memo = text
        memoData.fix = memoData.fixColor.isEmpty ? 0 : 1
        createMemo()
    }
}

// MARK: - 컬러 팝업뷰의 Delegate
extension CreateMemoViewController: ColorPickerDelegate {
    func showColorPickerController() {
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.delegate = self
        present(colorPickerVC, animated: true)
    }
    
    func completedButtonTapped(_ selectedColorHexString: String) {
        print("")
    }
}

// MARK: - UIColorPickerViewControllerDelegate
extension CreateMemoViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        
        print(color.hexValue())
        pinButton.tintColor = UIColor(color.hexValue())
    }
}

// MARK: - 작성한 메모 생성
extension CreateMemoViewController {
    private func createMemo() {
        loadingView.startLoading()
        
        Task {
            do {
                try await memoService.createMemo(memoData)
                navigationController?.popViewController(animated: true)
                
            } catch {
                showAlert(title: "오류", message: error.localizedDescription)
            }
            loadingView.stopLoading()
        }
    }
}

// MARK: - Notification
extension CreateMemoViewController {
    /// 노티피케이션 추가
    private func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification ,
            object: nil
        )
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// 키보드가 올라올 경우
    @objc private func keyboardWillShow(_ noti: NSNotification) {
        let keyboardFrame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        let keyboardHeight = keyboardFrame?.cgRectValue.height ?? 291
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            textView.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(80 + keyboardHeight)
            }
        }
    }

    /// 키보드가 내려갈 경우
    @objc private func keyboardWillHide(_ noti: NSNotification) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }
            textView.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(95)
            }
        }
    }
    
    /// 노티피케이션 제거
    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
