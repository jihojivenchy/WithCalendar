//
//  AddMemoViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class AddMemoViewController: UIViewController {
    //MARK: - Properties
    final var memoDataModel = MemoDataModel()
    
    final let addMemoDataService = AddMemoDataService()
    final let addMemoView = AddMemoView() //View
    
    private lazy var saveButton : UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: #selector(saveButtonPressed(_:)))
        
        return button
    }()
    
    private lazy var clipButton : UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "pin.slash"), style: .done, target: self, action: #selector(clipButtonPressed(_:)))
         
        return button
    }()
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        self.addKeyboardNotifications() //notification 추가
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubViews()
        setupNavigationBar()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardNotifications() //notification 제거
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        view.backgroundColor = .customWhiteAndBlackColor
        
        view.addSubview(addMemoView)
        addMemoView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItems = [saveButton, clipButton]
        navigationController?.navigationBar.tintColor = .blackAndWhiteColor
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //color를 선택하는 뷰를 보여줌.
    private func setClipColor() {
        let vc = SetColorViewController()
        vc.modalPresentationStyle = .custom
        vc.setColorDelegate = self
        self.present(vc, animated: true)
    }
    
    //MARK: - ButtonMethod
    @objc private func clipButtonPressed(_ sender : UIBarButtonItem) {
        //1. fixColor가 "" 라면 유저가 아직 클립을 선정하지 않았고, 이제 클립 설정을 원한다는 것을 의미. 클립의 컬러를 설정해주는 뷰를 올려줌.
        //2. fixColor가 ""가 아니라면 컬러 데이터가 있는 것으로 유저가 클립을 취소했음을 의미. 다시 원상복귀해줌.
        if memoDataModel.fixColor == "" {
            setClipColor() //컬러를 선택하는 뷰를 보여줌.
            clipButton.image = UIImage(systemName: "pin") //클립 이미지 변경.
            clipButton.tintColor = .signatureColor
            memoDataModel.fixColor = "#00925BFF"
            
        }else{ //원래대로 돌려주는 로직, 클립취소.
            memoDataModel.fixColor = ""
            clipButton.image = UIImage(systemName: "pin.slash")
            clipButton.tintColor = .blackAndWhiteColor
        }
    }
    
    @objc private func saveButtonPressed(_ sender : UIBarButtonItem) {
        guard let memoText = addMemoView.memoTextView.text else{return}
        let fixColorString = memoDataModel.fixColor
        let dateString = Date().convertDateToString(format: "yyyy년 MM월 dd일 HH시 mm분")  //현재 시간을 포맷해서 String으로 저장.
        
        if memoText == "" {
            showAlert(title: "내용작성", message: "내용을 작성해주세요.")
        }else{
            
            //fixColorString이 ""라면 유저가 클립설정을 하지 않은 메모로 클립 설정을 하지 않은 데이터로 저장. fix = 0
            //반대로 유저가 클립설정을 했다면 fix = 1과 클립의 컬러를 저장.
            if fixColorString == "" {
                let memoData = MemoData(memo: memoText, date: dateString, fix: 0, fixColor: "", documentID: "")
                handleSetMemoData(memoData: memoData)
                
            }else{
                let memoData = MemoData(memo: memoText, date: dateString, fix: 1, fixColor: fixColorString, documentID: "")
                handleSetMemoData(memoData: memoData)
            }
            
        }
    }
    
   
}

//MARK: - 컬러를 선택했을 때, 클립의 색깔을 변경해주는 작업.
extension AddMemoViewController : SetColorDelegate {
    func selectedColor(color: String) {
        memoDataModel.fixColor = color
        clipButton.tintColor = UIColor(color)
    }
}

//MARK: - 키보드를 감지했을 때 취해야 할 작업.
extension AddMemoViewController {
    //노티피케이션 달아주기.
    private func addKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //키보드가 올라온다는 알림을 받으면 실행하는 메서드
    @objc private func keyboardWillShow(_ noti: NSNotification){
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            addMemoView.memoTextView.snp.remakeConstraints { make in
                make.top.equalToSuperview().inset(10)
                make.left.right.equalToSuperview().inset(15)
                make.bottom.equalToSuperview().inset(keyboardHeight + 10)
            }
        }
    }
    
    // 키보드가 사라졌다는 알림을 받으면 실행할 메서드
    @objc private func keyboardWillHide(_ noti: NSNotification){
        addMemoView.memoTextView.snp.remakeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
    }
    
    // 노티피케이션을 제거하는 메서드
    private func removeKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

}

//MARK: - 메모 데이터를 저장하는 작업.
extension AddMemoViewController {
    
    private func handleSetMemoData(memoData: MemoData) {
        CustomLoadingView.shared.startLoading(to: 0)
        
        addMemoDataService.setMemoData(data: memoData) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(_):
                    CustomLoadingView.shared.stopLoading()
                    self?.navigationController?.popViewController(animated: true)
                    
                case .failure(let err):
                    print("Error 메모 데이터 저장 실패 : \(err.localizedDescription)")
                    self?.showAlert(title: "저장 실패", message: "네트워크 상태를 확인해주세요.")
                    CustomLoadingView.shared.stopLoading()
                }
            }
        }
    }
}
