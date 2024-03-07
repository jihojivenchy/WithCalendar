//
//  NotificationManagerViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/05/19.
//

import UIKit
import SnapKit

final class NotificationManagerViewController: UIViewController {
    //MARK: - Properties
    final var notiManagerDataModel = NotificationManagerDataModel()
    final let memoView = MemoView() //Memo 뷰를 재사용함.
    
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupSubViews()
        handleGetNotificationIdentifiers()
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        view.backgroundColor = .customWhiteAndBlackColor
        
        view.addSubview(memoView)
        memoView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        memoView.memoTableview.delegate = self
        memoView.memoTableview.dataSource = self
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationItem.title = "알림 리스트"
        navigationController?.navigationBar.tintColor = .blackAndWhiteColor
    }
    
    //MARK: - ButtonMethod
    
}

//MARK: - Extension
extension NotificationManagerViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notiManagerDataModel.pendingRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MemoListCell.identifier, for: indexPath) as! MemoListCell
        
        let request = notiManagerDataModel.pendingRequests[indexPath.row]
        let subTitle = notiManagerDataModel.customSubTitleArray[indexPath.row]
        
        cell.titleLabel.text = request.identifier
        cell.dateLabel.text = "\(subTitle) - \(request.content.body)"
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.whiteAndCustomBlackColor
        cell.selectedBackgroundView = backgroundView
        
        cell.tintColor = .signatureColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //cell을 클릭했을 때 애니메이션 구현
        triggerHapticFeedback() //유저에게 리액션을 주기 위한 미세한 진동음.
        
        
        deleteNotificationAlert(at: indexPath.row)
    }
}

//MARK: - Notification Request 정보들을 가져오고, 유저가 편하게 볼 수 있도록 가공.
extension NotificationManagerViewController {
    private func handleGetNotificationIdentifiers() {
        
        notiManagerDataModel.getAllNotificationIdentifiers { [weak self] requests in
            guard let self = self else{return}
            
            self.notiManagerDataModel.pendingRequests = requests
            self.configureSubTitleArray(requests)
            
            DispatchQueue.main.async {
                self.memoView.memoTableview.reloadData()
            }
        }
    }
    
    private func configureSubTitleArray(_ request: [UNNotificationRequest]) {
        for i in request {
            let subtitleLength = i.content.subtitle.count
            let title: String

            if subtitleLength == 29 {
                title = i.content.subtitle.getPrefix(13).getSuffix(7) //"2023년 05월 04일"
                
            }else{
                title = i.content.subtitle.getPrefix(21).getSuffix(15) //"2023년 05월 04일 13시 00분"
            }
        
            notiManagerDataModel.customSubTitleArray.append(title)
        }
    }
}

//MARK: - Notification Request 정보를 삭제하는 작업.
extension NotificationManagerViewController {
    private func deleteNotificationAlert(at indexRow: Int) {
        let action = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.deleteNotification(at: indexRow)
            self?.deleteIndexToNotiAraay(at: indexRow)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        showAlert(title: "삭제하기", message: "알림을 삭제하시겠습니까?", actions: [action, cancelAction])
    }
    
    private func deleteNotification(at indexRow: Int) {
        let identifier = notiManagerDataModel.pendingRequests[indexRow].identifier
        
        let notificationService = NotificationService()
        notificationService.removeNotificationRequest(with: identifier)
    }
    
    private func deleteIndexToNotiAraay(at indexRow: Int) {
        notiManagerDataModel.pendingRequests.remove(at: indexRow)
        notiManagerDataModel.customSubTitleArray.remove(at: indexRow)
        
        memoView.memoTableview.reloadData()
    }
}
