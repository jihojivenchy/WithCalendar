//
//  ScheduleViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/11/02.
//

import UIKit
import SnapKit


final class ScheduleViewController: UIViewController {
//MARK: - Properties
    
    private let scheduleTable = UITableView(frame: .zero, style: .insetGrouped)
    
    private let dateLabel = UILabel()
    
    private let backgrondView = UIView()
    
    private let addScheduleButton : UIButton = {
        let button = UIButton()
        button.setTitle("할 일을 추가해주세요.", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.5
        
        button.addTarget(self, action: #selector(addButtonPressed(_:)), for: .touchUpInside)
        
        return button
    }()
    
    
//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()

        self.isModalInPresentation = true                         //view의 스크롤 다운 dismiss가 안먹히게해줌.
        
        scheduleTable.register(MemoCustomTableViewCell.self, forCellReuseIdentifier: MemoCustomTableViewCell.cellIdentifier)
        scheduleTable.delegate = self
        scheduleTable.dataSource = self
        scheduleTable.rowHeight = 50
    }

//MARK: - ViewMethod
    
    private func addSubViews() {
        guard let savedDate = UserDefaults.standard.string(forKey: "selectedDate") else{return}
        
        view.backgroundColor = .clear
        
        view.addSubview(backgrondView)
        backgrondView.backgroundColor = .customGray
        backgrondView.clipsToBounds = true
        backgrondView.layer.cornerRadius = 10
        backgrondView.layer.masksToBounds = false
        backgrondView.layer.shadowColor = UIColor.black.cgColor
        backgrondView.layer.shadowOffset = CGSize(width: 0, height: 0)       //그림자의 위치
        backgrondView.layer.shadowRadius = 10                                //그림자 경계의 선명도
        backgrondView.layer.shadowOpacity = 0.5                              //그림자의 투명도
        backgrondView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(350)
            make.height.equalTo(530)
        }
        
        backgrondView.addSubview(scheduleTable)
        scheduleTable.backgroundColor = .customGray
        scheduleTable.layer.cornerRadius = 30
        scheduleTable.clipsToBounds = true
        scheduleTable.layer.masksToBounds = false
        scheduleTable.layer.shadowColor = UIColor.black.cgColor
        scheduleTable.layer.shadowOffset = CGSize(width: 0, height: 0)       //그림자의 위치
        scheduleTable.layer.shadowRadius = 10                                //그림자 경계의 선명도
        scheduleTable.layer.shadowOpacity = 0.5
        scheduleTable.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(350)
        }
        
        backgrondView.addSubview(dateLabel)
        dateLabel.text = savedDate
        dateLabel.textColor = .black
        dateLabel.font = .systemFont(ofSize: 25)
        dateLabel.textAlignment = .center
        dateLabel.backgroundColor = .customGray
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(scheduleTable.snp_topMargin).offset(-30)
            make.centerX.equalTo(scheduleTable)
            make.width.equalTo(300)
            make.height.equalTo(45)
        }
        
        backgrondView.addSubview(addScheduleButton)
        addScheduleButton.snp.makeConstraints { make in
            make.top.equalTo(scheduleTable.snp_bottomMargin).offset(30)
            make.centerX.equalTo(scheduleTable)
            make.width.equalTo(300)
            make.height.equalTo(45)
        }
    }
    
    private func navBarAppearance() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.dismiss(animated: true)
    }
    
//MARK: - ButtonMethod
    @objc private func addButtonPressed(_ sender : UIButton){
        
        present(WritingScheduleViewController(), animated: true)
        
    }
    
}

//MARK: - Extension

extension ScheduleViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MemoCustomTableViewCell.cellIdentifier, for: indexPath) as! MemoCustomTableViewCell
        
        
        cell.memoLabel.text = "ddddddddd"
        cell.separatorInset = UIEdgeInsets.zero
        cell.backgroundColor = .white
    
        
        return cell
    }
    
}

extension ScheduleViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

