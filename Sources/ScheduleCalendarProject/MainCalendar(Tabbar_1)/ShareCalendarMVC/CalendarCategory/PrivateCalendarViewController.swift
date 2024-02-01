//
//  PrivateCalendarViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class PrivateCalendarViewController: UIViewController {
    //MARK: - Properties
    final let calendarCategoryDataService = CalendarCategoryDataService()
    private let privateCalendarTableview = UITableView(frame: .zero, style: .insetGrouped)
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        privateCalendarTableview.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubViews()
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        view.backgroundColor = .customWhiteAndBlackColor
        
        view.addSubview(privateCalendarTableview)
        privateCalendarTableview.delegate = self
        privateCalendarTableview.dataSource = self
        privateCalendarTableview.register(CalendarCategoryTableViewCell.self, forCellReuseIdentifier: CalendarCategoryTableViewCell.identifier)
        privateCalendarTableview.rowHeight = 70
        privateCalendarTableview.backgroundColor = .clear
        privateCalendarTableview.separatorStyle = .none
        privateCalendarTableview.showsVerticalScrollIndicator = false
        privateCalendarTableview.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
}

//MARK: - Extension
extension PrivateCalendarViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CalendarCategoryTableViewCell.identifier, for: indexPath) as! CalendarCategoryTableViewCell
        
        cell.titleLabel.text = "With Calendar"
        
        cell.tintColor = .signatureColor
        
        let calendarName = UserDefaults.standard.string(forKey: "CurrentSelectedCalendarName") //현재 선택한 캘린더
        
        if calendarName == "With Calendar" { //현재 선택한 캘린더가 With Calendar라면 체크마크.
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.whiteAndCustomBlackColor
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //cell을 클릭했을 때 애니메이션 구현
        triggerHapticFeedback() //유저에게 리액션을 주기 위한 미세한 진동음.
     
        calendarCategoryDataService.changeToPrivateCalendar() //개인 캘린더로 전환.
        tableView.reloadData()
    }
}
