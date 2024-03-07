//
//  CalendarCollectionViewCell.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class CalendarCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "CalendarCollectionViewCell"
    
    final let dayLabel = UILabel()
    final let scheduleTableView = UITableView(frame: .zero, style: .plain)
    
    final var customCalendarData: [CustomCalendarData]? //tableView cell에 들어갈 이벤트 목록
    
    final var collectionViewHeight : CGFloat = 0
    private let margin : CGFloat = 6 //cell에서 테이블뷰의 높이를 구하기 위해 정확도를 높인 값.
    
    override init(frame: CGRect) {
            super.init(frame: frame)
        
        setupSubViews()
        scheduleTableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.identifier)
        scheduleTableView.separatorStyle = .none
        scheduleTableView.isUserInteractionEnabled = false
        scheduleTableView.dataSource = self
        scheduleTableView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewMethod
    func setupSubViews() {
        self.layer.cornerRadius = 10
        
        addSubview(dayLabel)
        dayLabel.configure(textColor: UIColor.blackAndWhiteColor!, backgroundColor: .clear, fontSize: 11, alignment: .center)
        dayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(2)
            make.left.right.equalToSuperview()
            make.height.equalTo(12)
        }
        
        addSubview(scheduleTableView)
        scheduleTableView.isScrollEnabled = false
        scheduleTableView.backgroundColor = .clear
        scheduleTableView.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp_bottomMargin).offset(13)
            make.bottom.equalToSuperview().inset(5)
            make.left.right.equalToSuperview()
        }
    }
    
    //animations나 completion 내에서 self에 대한 참조가 있지만, 순환참조가 발생하지 않는다.
    //UIView.animate method retains only the animation parameters until the animation completes or the view is deallocated.
    override var isSelected : Bool {
        didSet{
            if isSelected {
                self.backgroundColor = .lightGray.withAlphaComponent(0.1)
                
                UIView.animate(withDuration: 0.1, animations: {
                    self.dayLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    
                }, completion: { _ in
                    self.dayLabel.transform = .identity
                })
            }else{
                self.backgroundColor = .clear
            }
        }
    }
    
    private func getFontSize() -> CGFloat {
        return CGFloat(UserDefaults.standard.float(forKey: "fontSize"))
    }
    
    private func getFontName() -> String {
        return UserDefaults.standard.string(forKey: "fontName") ?? "Pretendard-SemiBold"
    }
}

//MARK: - CollectionView Cell안에 있는 tableview에 대한 DataSource
extension CalendarCollectionViewCell : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customCalendarData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.identifier, for: indexPath) as! ScheduleTableViewCell
        
        if let data = customCalendarData {
            cell.configureCalendarDataToUI(with: data[indexPath.row])
        }
        
        cell.scheduleLabel.font = UIFont(name: getFontName(), size: getFontSize())
        
        cell.selectionStyle = .none
        
        return cell
    }
    
}

extension CalendarCollectionViewCell : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let deviceHeight = UIScreen.main.bounds.size.height
        let tableViewHeight = calculateTableViewHeight()
        
        if deviceHeight > 750 {
            return tableViewHeight / 4
        }else{
            return tableViewHeight / 3
        }
    }
    
    private func calculateTableViewHeight() -> CGFloat {
        let collectionCellHeight = collectionViewHeight / 5
        let dayLabelHeight : CGFloat = 12
        let marginBetweenDayLabelAndTableView: CGFloat = 13
        let bottomInsetOfTableView: CGFloat = 5
        
        return (collectionCellHeight - (dayLabelHeight + marginBetweenDayLabelAndTableView + bottomInsetOfTableView)) + margin
    }
}

