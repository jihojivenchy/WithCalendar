//
//  ShareCalendarViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class ShareCalendarViewController: UIViewController {
    //MARK: - Properties
    final var shareCalendarDataModel = ShareCalendarDataModel()
    final let calendarCategoryDataService = CalendarCategoryDataService()
    private let shareCalendarTableview = UITableView(frame: .zero, style: .insetGrouped)
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        shareCalendarTableview.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleGetShareCalendarDataForCategory()
        setupSubViews()
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        view.backgroundColor = .customWhiteAndBlackColor
        
        view.addSubview(shareCalendarTableview)
        shareCalendarTableview.delegate = self
        shareCalendarTableview.dataSource = self
        shareCalendarTableview.register(CalendarCategoryTableViewCell.self, forCellReuseIdentifier: CalendarCategoryTableViewCell.identifier)
        shareCalendarTableview.rowHeight = 70
        shareCalendarTableview.backgroundColor = .clear
        shareCalendarTableview.separatorStyle = .none
        shareCalendarTableview.showsVerticalScrollIndicator = false
        shareCalendarTableview.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }

    }
    
}

//MARK: - Extension
extension ShareCalendarViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shareCalendarDataModel.shareCalendarCategoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CalendarCategoryTableViewCell.identifier, for: indexPath) as! CalendarCategoryTableViewCell
        
        let shareCalendarData = shareCalendarDataModel.shareCalendarCategoryArray[indexPath.row]
        
        cell.titleLabel.text = shareCalendarData.calendarName
        
        cell.personImageView.isHidden = false
        cell.personCountLabel.isHidden = false
        cell.personCountLabel.text = "\(shareCalendarData.memberUidArray.count)"
        cell.calendarCategoryCellDelegate = self
        cell.indexRow = indexPath.row
        
        let calendarName = UserDefaults.standard.string(forKey: "CurrentSelectedCalendarName") //현재 선택한 캘린더
        
        if calendarName == shareCalendarData.calendarName { //현재 선택한 캘린더가 With Calendar라면 체크마크.
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        cell.tintColor = .signatureColor
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.whiteAndCustomBlackColor
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //cell을 클릭했을 때 애니메이션 구현
        triggerHapticFeedback() //유저에게 리액션을 주기 위한 미세한 진동음.
        
        let shareCalendarData = shareCalendarDataModel.shareCalendarCategoryArray[indexPath.row]
        
        calendarCategoryDataService.changeToShareCalendar(collectionID: shareCalendarData.ownerUid,
                                                          documentID: shareCalendarData.documentID,
                                                          calendarName: shareCalendarData.calendarName)
        
        tableView.reloadData()
    }
}

extension ShareCalendarViewController {
    private func handleGetShareCalendarDataForCategory() {
        CustomLoadingView.shared.startLoading(to: 0)
        
        calendarCategoryDataService.getShareCalendarDataForCategory { [weak self] result in
            DispatchQueue.main.async {
                switch result {

                case .success(let data):
                    CustomLoadingView.shared.stopLoading()
                    self?.shareCalendarDataModel.shareCalendarCategoryArray = data
                    self?.shareCalendarTableview.reloadData()

                case .failure(let err):
                    CustomLoadingView.shared.stopLoading()
                    self?.showAlert(title: "데이터 찾기 실패", message: err.localizedDescription)
                }
            }
        }
    }
    
    private func cellEditPressed(indexRow: Int) {
        let vc = EditCalendarViewController()
        vc.editCalendarData = shareCalendarDataModel.shareCalendarCategoryArray[indexRow]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ShareCalendarViewController : CalendarCategoryCellDelegate {
    func sendIndexRow(indexRow: Int) {
        self.cellEditPressed(indexRow: indexRow)
    }
}
