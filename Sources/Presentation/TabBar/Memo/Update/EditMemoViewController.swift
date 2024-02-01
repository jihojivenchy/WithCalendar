//
//  EditMemoViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class EditMemoViewController: UIViewController {
    //MARK: - Properties
    final var memoData = MemoData(memo: "", date: "", fix: 0, fixColor: "", documentID: "")
    final var memoDataModel = MemoDataModel()
    final let editMemoDataService = EditMemoDataService()
    final let editMemoView = EditMemoView() //View
    
    private var didShowSaveButton = false //showSaveButton 메서드가 딱 한번만 실행하도록 만들어주는 프로퍼티.
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addKeyboardNotifications() //notification 추가
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubViews()
        populateWithData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardNotifications() //notification 제거
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        view.backgroundColor = .customWhiteAndBlackColor
        
        view.addSubview(editMemoView)
        editMemoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        editMemoView.dismissButton.addTarget(self, action: #selector(dismissButtonPressed(_:)), for: .touchUpInside)
        editMemoView.clipButton.addTarget(self, action: #selector(clipButtonPressed(_:)), for: .touchUpInside)
        editMemoView.deleteButton.addTarget(self, action: #selector(deleteButtonPressed(_:)), for: .touchUpInside)
        editMemoView.saveButton.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //가져온 데이터들을 뷰에 적절하게 배치해줌.
    final func populateWithData() {
        if memoData.fix == 0{
            editMemoView.clipButton.setBackgroundImage(UIImage(systemName: "pin.slash"), for: .normal)
            editMemoView.clipButton.tintColor = .lightGrayAndWhiteColor
            
        }else{
            editMemoView.clipButton.setBackgroundImage(UIImage(systemName: "pin"), for: .normal)
            editMemoView.clipButton.tintColor = UIColor(memoData.fixColor)
        }
        
        editMemoView.memoTextView.text = memoData.memo
    }
    
    //color를 선택하는 뷰를 보여줌.
    private func setClipColor() {
        let vc = SetColorViewController()
        vc.modalPresentationStyle = .custom
        vc.setColorDelegate = self
        self.present(vc, animated: true)
    }
    
    //MARK: - ButtonMethod
    @objc private func dismissButtonPressed(_ sender : UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc private func clipButtonPressed(_ sender : UIButton) {
        showSaveButton() //클립을 눌러 수정이 일어났을 때, 버튼을 재구성.

        //유저의 메모 데이터가 클립을 설정하지 않았다면, 클립을 설정하고, 컬러를 선택하는 뷰를 보여줌.
        //유저의 메모 데이터가 클립을 설정했다면, 클립 설정을 취소
        if memoData.fix == 0 {
            
            memoData.fix = 1 //클립설정으로 변경해줌.
            memoData.fixColor = "#00925BFF" //default 컬러.
            setClipColor() //컬러를 선택하는 뷰를 보여줌.
            editMemoView.clipButton.setBackgroundImage(UIImage(systemName: "pin"), for: .normal)
            editMemoView.clipButton.tintColor = .signatureColor //default 컬러.
            
        }else{
            memoData.fix = 0
            memoData.fixColor = ""
            editMemoView.clipButton.setBackgroundImage(UIImage(systemName: "pin.slash"), for: .normal)
            editMemoView.clipButton.tintColor = .blackAndWhiteColor
        }
    }
    
    @objc private func deleteButtonPressed(_ sender : UIButton) {
        deleteDataAlert()
    }
    
    @objc private func saveButtonPressed(_ sender : UIButton) {
        guard let memoText = editMemoView.memoTextView.text else{return}
        let formatDate = Date().convertDateToString(format: "yyyy년 MM월 dd일 HH시 mm분") //현재 시간을 포맷해서 String으로 저장.
        
        memoData.memo = memoText
        memoData.date = formatDate
        
        if memoText == "" {
            showAlert(title: "메모 작성", message: "메모를 작성해주세요.")
        }else{
            handleUpdateData(memoData: memoData)
        }
    }
    
    
}

//MARK: - 컬러 선택했을 경우 클립의 색깔 변경 작업.
extension EditMemoViewController : SetColorDelegate {
    func selectedColor(color: String) {
        self.memoData.fixColor = color
        editMemoView.clipButton.tintColor = UIColor(color)
    }
}

//MARK: - 키보드를 감지했을 때 취해야 할 작업.
extension EditMemoViewController {
    //노티피케이션 달아주기.
    private func addKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //키보드가 올라온다는 알림을 받으면 실행하는 메서드
    @objc private func keyboardWillShow(_ noti: NSNotification){
        //editing이 시작되면 savebutton이 나타나고, delete버튼과 clip버튼은 옆으로 옮겨감. 키보드의 높이에 맞게 memoTextView의 크기를 맞춰준다.
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            //버튼 재구성
            showSaveButton()
            
            //텍스트뷰 레이아웃
            editMemoView.memoTextView.snp.remakeConstraints { make in
                make.top.equalTo(editMemoView.dismissButton.snp_bottomMargin).offset(30)
                make.left.right.equalToSuperview().inset(15)
                make.bottom.equalToSuperview().inset(keyboardHeight + 10)
            }
        }
    }
    
    // 키보드가 사라졌다는 알림을 받으면 실행할 메서드
    @objc private func keyboardWillHide(_ noti: NSNotification){
        //memoTextView의 크기를 원래대로 변경.
        editMemoView.memoTextView.snp.remakeConstraints { make in
            make.top.equalTo(editMemoView.dismissButton.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(20)
        }
        
        
    }
    
    // 노티피케이션을 제거하는 메서드
    private func removeKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //메모가 수정될려고 하면 저장하는 버튼을 보여주면서 버튼들의 레이아웃 재구성
    private func showSaveButton() {
        if didShowSaveButton {
            return
        }
            
        performTransition(with: self.editMemoView, duration: 0.5) //애니메이션.
        
        self.editMemoView.saveButton.isHidden = false
        
        self.editMemoView.deleteButton.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(19)
            make.right.equalToSuperview().inset(65)
            make.width.height.equalTo(25)
        }
        
        self.editMemoView.clipButton.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(19)
            make.right.equalToSuperview().inset(110)
            make.width.height.equalTo(25)
        }
        
        didShowSaveButton = true
    }
}

//MARK: - 데이터를 수정하고, 삭제하는 작업.
extension EditMemoViewController {
    //데이터를 삭제할지 물어보는 Alert
    private func deleteDataAlert() {
        
        let action = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let self = self else{return}
            let documentID = self.memoData.documentID
            self.handleDeleteData(documentID: documentID)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        showAlert(title: "삭제", message: "메모를 삭제하시겠습니까?", actions: [action, cancelAction])
    }
    
    //데이터를 삭제할 때 성공과 에러에 대한 후처리
    private func handleDeleteData(documentID: String) {
        editMemoDataService.deleteMemoData(documentID: documentID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(_):
                    self?.dismiss(animated: true)
                    
                case .failure(let err):
                    print("Error 메모 데이터 삭제 실패 : \(err.localizedDescription)")
                    self?.showAlert(title: "삭제 실패", message: "네트워크 상태를 확인해주세요.")
                }
            }
        }
    }
    
    //수정한 데이터를 저장할 때 성공과 에러에 대한 후처리
    private func handleUpdateData(memoData: MemoData) {
        editMemoDataService.updateMemoData(documentID: memoData.documentID, data: memoData) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(_):
                    self?.dismiss(animated: true)
                    
                case .failure(let err):
                    print("Error 메모 데이터 업데이트 실패 : \(err.localizedDescription)")
                    self?.showAlert(title: "저장 실패", message: "네트워크 상태를 확인해주세요.")
                }
            }
        }
    }
}
