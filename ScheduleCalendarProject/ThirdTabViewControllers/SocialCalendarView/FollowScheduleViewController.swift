//
//  CheckScheduleViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/12/19.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore
import UIColor_Hex_Swift

class FollowScheduleViewController: UIViewController {
    //MARK: - Properties
    private let db = Firestore.firestore()
    
    var calendarMemoArray : [CalendarMemoData] = []
    
    private let scheduleTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    let dateLabel = UILabel()
    
    private let backgrondView = UIView()
    
    
//MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        deleteNilValue()
        
        self.isModalInPresentation = true            //view의 스크롤 다운 dismiss가 안먹히게해줌.
        
        scheduleTableView.register(MemoCustomTableViewCell.self, forCellReuseIdentifier: MemoCustomTableViewCell.cellIdentifier)
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        scheduleTableView.rowHeight = 50
        scheduleTableView.separatorColor = .displayModeColor2
    }
    
    //MARK: - ViewMethod
    private func addSubViews() {
        
        view.backgroundColor = .clear
        
        view.addSubview(backgrondView)
        backgrondView.backgroundColor = .displayModeColor3
        backgrondView.clipsToBounds = true
        backgrondView.layer.cornerRadius = 10
        backgrondView.layer.borderColor = UIColor.displayModeColor2?.cgColor
        backgrondView.layer.borderWidth = 0.5
        backgrondView.layer.masksToBounds = false
        backgrondView.layer.shadowColor = UIColor.black.cgColor
        backgrondView.layer.shadowOffset = CGSize(width: 0, height: 0)       //그림자의 위치
        backgrondView.layer.shadowRadius = 10                                //그림자 경계의 선명도
        backgrondView.layer.shadowOpacity = 0.5                              //그림자의 투명도
        backgrondView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(280)
            make.height.equalTo(400)
        }
        
        backgrondView.addSubview(dateLabel)
        dateLabel.textColor = .displayModeColor2
        dateLabel.font = .boldSystemFont(ofSize: 18)
        dateLabel.textAlignment = .center
        dateLabel.backgroundColor = .clear
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.right.left.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        backgrondView.addSubview(scheduleTableView)
        scheduleTableView.backgroundColor = .clear
        scheduleTableView.layer.cornerRadius = 30
        scheduleTableView.clipsToBounds = true
        scheduleTableView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp_bottomMargin).offset(10)
            make.right.left.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view == self.view {
            self.dismiss(animated: true)
        }
    }
    
    private func deleteNilValue() { //빈 값은 표현하지 못하도록 만들기 위해
        
        let filterArray = self.calendarMemoArray.filter { data in
            return data.titleMemo != ""
        }
        
        self.calendarMemoArray = filterArray
        scheduleTableView.reloadData()
    }
    
    
//MARK: - ButtonMethod

}

//MARK: - Extension

extension FollowScheduleViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.calendarMemoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MemoCustomTableViewCell.cellIdentifier, for: indexPath) as! MemoCustomTableViewCell
        
        if self.calendarMemoArray[indexPath.row].detailMemo == "", self.calendarMemoArray[indexPath.row].count == 0{
            cell.addSubviews()
            
            cell.memoLabel.text = self.calendarMemoArray[indexPath.row].titleMemo
            cell.titleColorView.backgroundColor = UIColor(calendarMemoArray[indexPath.row].selectedColor)
            cell.subMemoLabel.text = ""
            
        }else if self.calendarMemoArray[indexPath.row].detailMemo != ""{
            cell.addSubMemoLabel()
            
            cell.memoLabel.text = self.calendarMemoArray[indexPath.row].titleMemo
            cell.titleColorView.backgroundColor = UIColor(calendarMemoArray[indexPath.row].selectedColor)
            cell.subMemoLabel.text = self.calendarMemoArray[indexPath.row].detailMemo
        }else{
            cell.addSubMemoLabel()
            
            cell.memoLabel.text = self.calendarMemoArray[indexPath.row].titleMemo
            cell.titleColorView.backgroundColor = UIColor(calendarMemoArray[indexPath.row].selectedColor)
            cell.subMemoLabel.text = "\(self.calendarMemoArray[indexPath.row].startDate) - \(self.calendarMemoArray[indexPath.row].endDate)"
        }
        
        
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        return cell
    }
    
}

extension FollowScheduleViewController : UITableViewDelegate {
    
}
