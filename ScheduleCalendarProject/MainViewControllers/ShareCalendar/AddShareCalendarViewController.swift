//
//  AddShareCalendarViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/01/02.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore
import TextFieldEffects

final class AddShareCalendarViewController: UIViewController {
//MARK: - Properties
    private let db = Firestore.firestore()
    
    private var userNameArray : [String] = []
    private var userUIDArray : [String] = []
    
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
    
    
//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubViews()
        navBarAppearance()
        getMyNameData()
        
        userTableView.delegate = self
        userTableView.dataSource = self
        userTableView.register(ShareUserTableViewCell.self, forCellReuseIdentifier: ShareUserTableViewCell.cellIdentifier)
        userTableView.rowHeight = 70
        userTableView.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        writeNameTextField.becomeFirstResponder()
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
        writeNameTextField.placeholderFontScale = 0.65
        writeNameTextField.font = .boldSystemFont(ofSize: 20)
        writeNameTextField.borderInactiveColor = .darkGray
        writeNameTextField.borderActiveColor = .darkGray
        writeNameTextField.textColor = .displayModeColor2
        writeNameTextField.tintColor = .displayModeColor2
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

        navigationItem.title = "Share Calendar"
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.backBarButtonItem = navigationBackButton
    }
    
    private func setAlert(title : String, subTitle : String) {
        let alert = UIAlertController(title: title, message: subTitle, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "확인", style: .default)
        yesAction.setValue(UIColor.displayModeColor2, forKey: "titleTextColor")
        
        alert.addAction(yesAction)
        
        present(alert, animated: true)
    }
    
    private func cellPressed(index: Int) {
        let alert = UIAlertController(title: "제외", message: "명단에서 제외합니다", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "확인", style: .default) { (action) in
            self.userNameArray.remove(at: index)
            self.userUIDArray.remove(at: index)
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
    @objc private func saveButtonPressed(_ sender : UIBarButtonItem){
        guard let title = self.writeNameTextField.text else{return}
        
        if title == "" {
            setAlert(title: "오류", subTitle: "제목을 입력해주세요.")
        }else{
            
            if userNameArray.count > 1 {
                setShareCalendar(calendarName: title)
            }else{
                setAlert(title: "오류", subTitle: "1명 이상 초대해주세요.")
            }
        }
    }
    
    
//MARK: - DataMethods
    private func getMyNameData() { //내 정보를 참가자에 넣기위해
        guard let user = Auth.auth().currentUser else{return}
        
        db.collection("Users").document(user.uid).getDocument{ querySnapShot, error in
            if let e = error {
                print("Error search User Data : \(e)")
            }else{
                
                guard let data = querySnapShot?.data() else{return}
                guard let nickName = data["NickName"] as? String else{return}
                
                self.userNameArray.append(nickName)
                self.userUIDArray.append(user.uid)
                
                DispatchQueue.main.async {
                    self.userTableView.reloadData()
                }
            }
        }
    }
    
    private func setShareCalendar(calendarName : String){ //방장의 uid를 가지고 공유달력을 만들고 documentID를 뿌려줌.
        guard let user = Auth.auth().currentUser else{return}
        
        db.collection("\(user.uid).공유달력").addDocument(data: [:]).getDocument { qs, error in
            if let e = error {
                print("Error set shareCalendarData : \(e)")
            }else{
                if let documentId = qs?.documentID {
                    self.indicatorView.startAnimating()
                    self.getHolidayData(uid: user.uid, calendarName: documentId) //공휴일 데이터 달력에 넣어주기
                    self.setInviteUserData(documentID: documentId, calendarName: calendarName)
                }
            }
        }
    }
    
    private func setInviteUserData(documentID : String, calendarName : String) {
        let owner = userNameArray[0]
        let ownerUid = "\(userUIDArray[0]).공유달력"
        let date = Date().timeIntervalSince1970
        
        for i in userUIDArray {
            db.collection("\(i).공유").document(documentID).setData(["calendarName" : calendarName,
                                                                       "owner" : owner,
                                                                       "ownerUid" : ownerUid,
                                                                       "member" : userNameArray,
                                                                       "memberUid" : userUIDArray,
                                                                       "date" : date])
        }
    }
}

//MARK: - Extension
extension AddShareCalendarViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

extension AddShareCalendarViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShareUserTableViewCell.cellIdentifier, for: indexPath) as! ShareUserTableViewCell
        
        cell.followImageView.image = UIImage(systemName: "person.circle")
        cell.followLabel.text = userNameArray[indexPath.row]
        
        if indexPath.row == 0 {
            cell.kingImageView.isHidden = false
        }else{
            cell.kingImageView.isHidden = true
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

extension AddShareCalendarViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row != 0 { //나 자신은 제외
            cellPressed(index: indexPath.row)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AddShareCalendarViewController : ShareFooterViewDelegate { //footview를 눌렀을 때
    func viewPressed() {
        let vc = SearchUserViewController()
        vc.searchDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AddShareCalendarViewController : SearchViewDelegate { //초대하기 누르면 배열에 유저 정보 추가
    func sendinviteData(name: String, uid: String) {
        self.userNameArray.append(name)
        self.userUIDArray.append(uid)
        
        self.userTableView.reloadData()
    }
}

//qtlz6
extension AddShareCalendarViewController {
    private func getHolidayData(uid : String, calendarName : String) {
        let array = ["2023", "2024"]
        
        for i in array {
            performRequest(year: i, uid: uid, calendarName: calendarName)
        }
        
    }
    
    private func performRequest(year : String, uid : String, calendarName : String) {
        if let url = URL(string: "https://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/getRestDeInfo?solYear=\(year)&ServiceKey=IIL7UWdyZVoWG7cxSTS8dR7GOOF39dZfa5Yb2ycPnkfuzythdYSJAHrD3ymecrT0Ll0p1B9F%2Bc3diiWELt3nUw%3D%3D&_type=json&numOfRows=20"){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if let e = error {
                    print("Error request holiday data \(e)")
                }else{
                    guard let safeData = data else{return}
                    self.parseJSON(data: safeData, uid: uid, calendarName: calendarName)
                }
            }
            task.resume()
        }
    }
    
    private func parseJSON(data : Data, uid : String, calendarName : String) {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(JSONResponse.self, from: data)
            
            let dateFormatter = DateFormatter()
            
            for data in decodedData.response.body.items.item {
                
                dateFormatter.dateFormat = "yyyyMMdd"
                let formattedDate = dateFormatter.date(from: String(data.locdate)) ?? Date()
                
                dateFormatter.dateFormat = "yyyy년 MM월 dd일"
                let resultDate = dateFormatter.string(from: formattedDate)
                
                dateFormatter.dateFormat = "yyyy년 MM월"
                let queryDate = dateFormatter.string(from: formattedDate)
                
                self.db.collection("\(uid).공유달력").document(calendarName).collection("달력내용").addDocument(data:
                                                                            ["startDate" : resultDate,
                                                                             "endDate"   : resultDate,
                                                                             "queryDate" : queryDate,
                                                                             "titleText" : data.dateName,
                                                                             "selectedColor" : "#CC3636FF",
                                                                             "labelColor" : "#CC3636FF",
                                                                              "detailMemo" : "",
                                                                             "backGrondColor" : "#00000000",
                                                                             "count" : 0,
                                                                             "controlIndex" : 0,
                                                                             "notification" : ""])
            }
            
            DispatchQueue.main.async {
                self.indicatorView.stopAnimating()
                self.navigationController?.popViewController(animated: true)
            }
            
        }catch {
            print("Error decoding")
        }
        
    }
}
