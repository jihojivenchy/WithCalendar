//
//  EditShareCalendarViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/01/04.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore
import TextFieldEffects

final class EditShareCalendarViewController: UIViewController {
//MARK: - Properties
    private let db = Firestore.firestore()
    final var shareCalendarData : ShareCalendarData = ShareCalendarData(calendarName: "", documentID: "", owner: "", ownerUid: "", member: [""], memberUid: [""])
    
    private lazy var deleteButton : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(deleteButtonPressed(_:)), for: .touchUpInside)
        button.tintColor = .customSignatureColor
        
        return button
    }()
    
    private lazy var saveButton : UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(saveButtonPressed(_:)))
        button.tintColor = .customSignatureColor
        
        return button
    }()
    
    private lazy var navigationBackButton : UIBarButtonItem = {
        let button = UIBarButtonItem(title: nil, style: .plain, target: self, action: nil)
        return button
    }()
    
    private let writeNameTextField = HoshiTextField()
    private let userTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private lazy var indicatorView : UIActivityIndicatorView = {
        let ia = UIActivityIndicatorView()
        ia.hidesWhenStopped = true
        ia.style = .large
        
        return ia
    }()
    
    private var checkUserState : Bool = false //유저가 방장인지 아닌지 체크
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        checkUserData()
        navBarAppearance()
        
        userTableView.delegate = self
        userTableView.dataSource = self
        userTableView.register(ShareUserTableViewCell.self, forCellReuseIdentifier: ShareUserTableViewCell.cellIdentifier)
        userTableView.rowHeight = 70
        userTableView.separatorStyle = .none
    }
    
    //MARK: - ViewMethods
    private func addSubViews() {
        view.backgroundColor = .displayModeColor1
        
        view.addSubview(writeNameTextField)
        writeNameTextField.delegate = self
        writeNameTextField.returnKeyType = .done
        writeNameTextField.backgroundColor = .clear
        writeNameTextField.placeholder = "달력이름"
        writeNameTextField.placeholderColor = .darkGray
        writeNameTextField.placeholderFontScale = 0.6
        writeNameTextField.font = .boldSystemFont(ofSize: 20)
        writeNameTextField.borderInactiveColor = .darkGray
        writeNameTextField.borderActiveColor = .darkGray
        writeNameTextField.textColor = .displayModeColor2
        writeNameTextField.tintColor = .displayModeColor2
        writeNameTextField.text = shareCalendarData.calendarName
        writeNameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(70)
        }
        
        view.addSubview(userTableView)
        userTableView.backgroundColor = .clear
        userTableView.showsVerticalScrollIndicator = false
        userTableView.snp.makeConstraints { make in
            make.top.equalTo(writeNameTextField.snp_bottomMargin).offset(20)
            make.left.bottom.right.equalToSuperview()
        }
        
        view.addSubview(deleteButton)
        deleteButton.clipsToBounds = true
        deleteButton.layer.masksToBounds = false
        deleteButton.layer.cornerRadius = 30
        deleteButton.backgroundColor = .displayModeColor3
        deleteButton.layer.shadowColor = UIColor.black.cgColor
        deleteButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        deleteButton.layer.shadowRadius = 5
        deleteButton.layer.shadowOpacity = 0.3
        deleteButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        view.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.width.height.equalTo(100)
        }
    }
    
    private func navBarAppearance() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance

        navigationItem.title = "편집"
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.backBarButtonItem = navigationBackButton
    }
    
    private func checkUserData() { //방장인지 방에 참여하고 있는 구성원인지 확인 후 delete버튼과 나가기 버튼을 구별
        guard let user = Auth.auth().currentUser else{return}
        
        if shareCalendarData.ownerUid == "\(user.uid).공유달력" {
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 21, weight: .light)
            var image = UIImage(systemName: "iphone.and.arrow.forward", withConfiguration: imageConfig)
            image = UIImage(systemName: "trash", withConfiguration: imageConfig)
            self.deleteButton.setImage(image, for: .normal)
            
            self.checkUserState = true
        }else{
            self.deleteButton.setTitle("Exit", for: .normal)
            self.deleteButton.setTitleColor(.customSignatureColor, for: .normal)
            self.deleteButton.titleLabel?.font = .boldSystemFont(ofSize: 13)
        }
    }
    
    private func checkIndex() -> Int { //내 데이터가 몇번째 인덱스인지 확인
        guard let user = Auth.auth().currentUser else{return 10}
        return shareCalendarData.memberUid.firstIndex(of: user.uid) ?? Int()
    }
    
    private func setAlert(title : String, subTitle : String) {
        let alert = UIAlertController(title: title, message: subTitle, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "확인", style: .default)
        yesAction.setValue(UIColor.displayModeColor2, forKey: "titleTextColor")
        
        alert.addAction(yesAction)
        
        present(alert, animated: true)
    }
    
    private func cellPressed(index: Int) {
        let alert = UIAlertController(title: "내보내기", message: nil, preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "확인", style: .default) { (action) in
            
            self.userTableView.reloadData()
        }
        deleteAction.setValue(UIColor.displayModeColor2, forKey: "titleTextColor")
        
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.displayModeColor2, forKey: "titleTextColor")
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    
//MARK: - ButtonMethods
    @objc private func deleteButtonPressed(_ sender : UIButton) {
        if checkUserState { //방장일 때
            checkStateAfter(title: "삭제하기")
            
        }else{ //방장이 아닌 멤버일뿐 때
            checkStateAfter(title: "나가기")
        }
    }
    
    private func checkStateAfter(title : String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "확인", style: .default) { (action) in
            if title == "삭제하기" {
                self.deletePressed()
            }else{
                self.exitPressed()
            }
        }
        deleteAction.setValue(UIColor.displayModeColor2, forKey: "titleTextColor")
        
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.displayModeColor2, forKey: "titleTextColor")
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @objc private func saveButtonPressed(_ sender : UIBarButtonItem){
        guard let title = self.writeNameTextField.text else{return}
        
        if title == "" {
            setAlert(title: "오류", subTitle: "제목을 입력해주세요.")
        }else{
            
            
        }
    }
    
    
//MARK: - DataMethods
    
    private func exitPressed() {
        guard let user = Auth.auth().currentUser else{return}
        let exitUserName = shareCalendarData.member[checkIndex()] //내 이름 정보
        
        for i in shareCalendarData.memberUid {
            
            if i != user.uid { //다른 유저들의 공유데이터에서 내 정보만 삭제
                
                db.collection("\(i).공유").document(shareCalendarData.documentID).updateData(["member" : FieldValue.arrayRemove([exitUserName])])
                
                db.collection("\(i).공유").document(shareCalendarData.documentID).updateData(["memberUid" : FieldValue.arrayRemove([user.uid])])
                
            }else{ //내 정보면 내 공유 데이터 삭제
                db.collection("\(i).공유").document(shareCalendarData.documentID).delete()
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func deletePressed() {
        
        for i in shareCalendarData.memberUid { //참여했던 모든 유저들의 공유데이터 정보 삭제
            db.collection("\(i).공유").document(shareCalendarData.documentID).delete()
        }
        
        deleteShareCalendar()
    }
    
    private func deleteShareCalendar() { //캘린더 내부일정들과 캘린더 정보 모두 삭제
        
        db.collection(shareCalendarData.ownerUid).document(shareCalendarData.documentID).delete()
        db.collection(shareCalendarData.ownerUid).document(shareCalendarData.documentID).collection("달력내용").getDocuments { querySnapShot, error in
            
            if let e = error {
                print("Error find calendar schedule memo data : \(e)")
            }else{
                guard let snapShotDocuments = querySnapShot?.documents else{return}
                
                for doc in snapShotDocuments {
                    
                    self.db.collection(self.shareCalendarData.ownerUid).document(self.shareCalendarData.documentID).collection("달력내용").document(doc.documentID).delete()
                }
                
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
}

//MARK: - Extension
extension EditShareCalendarViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

extension EditShareCalendarViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shareCalendarData.member.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShareUserTableViewCell.cellIdentifier, for: indexPath) as! ShareUserTableViewCell
        
        cell.followImageView.image = UIImage(systemName: "person.circle")
        cell.followLabel.text = shareCalendarData.member[indexPath.row]
        
        if indexPath.row == 0 {
            cell.kingImageView.isHidden = false
        }else{
            cell.kingImageView.isHidden = true
        }
        
        if checkIndex() == indexPath.row {
            print(checkIndex())
        }else{
            
        }
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.displayModeColor3
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //섹션 헤더타이틀
        return "참가자"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .clear
            headerView.textLabel?.textColor = .darkGray
            headerView.textLabel?.font = .boldSystemFont(ofSize: 13)
            headerView.frame.size.height = 30
        }
    }//headertitle에 컬러넣기
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = AddShareFooterView()
        view.footViewDelegate = self
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
}

extension EditShareCalendarViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension EditShareCalendarViewController : ShareFooterViewDelegate { //footview를 눌렀을 때
    func viewPressed() {
        let vc = SearchUserViewController()
        vc.searchDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension EditShareCalendarViewController : SearchViewDelegate { //초대하기 누르면 배열에 유저 정보 추가
    func sendinviteData(name: String, uid: String) {
        
        
        self.userTableView.reloadData()
    }
}
