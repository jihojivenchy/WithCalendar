//
//  CustomCalendarViewCell.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/11/02.
//

import UIKit
import SnapKit

class CustomCalendarViewCell: UICollectionViewCell {
    
    static let identifier = "CalendarCell"
    
    let dayLabel = UILabel()
    let todoListTabelView = UITableView(frame: .zero, style: .plain)
    
    var firstText = ""
    var firstLabelColor = UIColor.clear
    var firstCellColor = UIColor.clear
    
    var secondText = ""
    var secondLabelColor = UIColor.clear
    var secondCellColor = UIColor.clear
    
    var thirdText = ""
    var thirdLabelColor = UIColor.clear
    var thirdCellColor = UIColor.clear

    var returnCellCount : Int = 0
    
    override init(frame: CGRect) {
            super.init(frame: frame)
        
        addSubviews()
        
        todoListTabelView.delegate = self
        todoListTabelView.dataSource = self
        todoListTabelView.register(TodoListTableViewCell.self, forCellReuseIdentifier: TodoListTableViewCell.cellIdentifier)
        todoListTabelView.rowHeight = 15
        todoListTabelView.separatorStyle = .none
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        
        self.layer.cornerRadius = 10
        
        addSubview(dayLabel)
        dayLabel.textColor = .black
        dayLabel.font = .systemFont(ofSize: 13)
        dayLabel.textAlignment = .center
        dayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(15)
        }
        
        addSubview(todoListTabelView)
        todoListTabelView.isScrollEnabled = false
        todoListTabelView.backgroundColor = .clear
        todoListTabelView.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp_bottomMargin).offset(15)
            make.width.equalToSuperview()
            make.height.equalTo(45)
        }
        
    }

}

extension CustomCalendarViewCell : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.returnCellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoListTableViewCell.cellIdentifier, for: indexPath) as! TodoListTableViewCell
        
        if indexPath.row == 0 {
            cell.memoLabel.text = self.firstText
            cell.memoLabel.backgroundColor = self.firstLabelColor
            cell.backgroundColor = self.firstCellColor
            
        }else if indexPath.row == 1 {
            cell.memoLabel.text = self.secondText
            cell.memoLabel.backgroundColor = self.secondLabelColor
            cell.backgroundColor = self.secondCellColor
            
        }else if indexPath.row == 2 {
            cell.memoLabel.text = self.thirdText
            cell.memoLabel.backgroundColor = self.thirdLabelColor
            cell.backgroundColor = self.thirdCellColor
            
        }else{
            cell.memoLabel.text = "zzzz"
            cell.memoLabel.backgroundColor = self.thirdLabelColor
        }
        
        
        return cell
    }
    
    
}

extension CustomCalendarViewCell : UITableViewDelegate {
    
}
