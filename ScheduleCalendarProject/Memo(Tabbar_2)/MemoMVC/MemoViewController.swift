//
//  MemoViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit
import UIColor_Hex_Swift

final class MemoViewController: UIViewController {
    //MARK: - Properties
    final var memoDataModel = MemoDataModel()
    final let memoDataService = MemoDataService()
    final let memoView = MemoView() //View
    
    final let editMemoDataService = EditMemoDataService() //삭제 기능 사용하기 위해서.
    
    private lazy var addRightButton : UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(addButtonPressed(_:)))
        
        return button
    }()
    
    private lazy var navigationBackButton : UIBarButtonItem = {
        let button = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return button
    }()
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handleGetMemoData()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubViews()
        setupNavigationBar()
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
        
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = addRightButton
        navigationItem.backBarButtonItem = navigationBackButton
        navigationController?.navigationBar.tintColor = .blackAndWhiteColor
    }

    //MARK: - ButtonMethod
    @objc private func addButtonPressed(_ sender : UIBarButtonItem) {
        guard isUserLoggedIn() else{
            showAlert(title: "로그인", message: "로그인이 필요한 서비스입니다.")
            return
        }
        
        self.navigationController?.pushViewController(AddMemoViewController(), animated: true)
    }
}

//MARK: - 테이블뷰 내부 데이터 처리
extension MemoViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            
        case 0:
            return memoDataModel.fixMemodataArray.count
        case 1:
            return memoDataModel.unFixMemoDataArray.count
        default:
            return memoDataModel.unFixMemoDataArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.identifier, for: indexPath) as! MemoTableViewCell
        
        if indexPath.section == 0 {
            let fixMemoData = memoDataModel.fixMemodataArray[indexPath.row]
            
            cell.titleLabel.text = fixMemoData.memo
            cell.dateLabel.text = fixMemoData.date
            cell.clipImageView.tintColor = UIColor(fixMemoData.fixColor)
            cell.clipImageView.isHidden = false
            
        }else {
            let unFixMemoData = memoDataModel.unFixMemoDataArray[indexPath.row]
            
            cell.titleLabel.text = unFixMemoData.memo
            cell.dateLabel.text = unFixMemoData.date
            cell.clipImageView.isHidden = true
            
        }
        
        cell.indexSection = indexPath.section
        cell.indexRow = indexPath.row
        cell.cellDelegate = self
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.whiteAndCustomBlackColor
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //cell을 클릭했을 때 애니메이션 구현
        triggerHapticFeedback() //유저에게 리액션을 주기 위한 미세한 진동음.
        
        guard isUserLoggedIn() else{
            showAlert(title: "로그인", message: "로그인이 필요한 서비스입니다.")
            return
        }
        
        let vc = EditMemoViewController()
        
        if indexPath.section == 0 {
            vc.memoData = memoDataModel.fixMemodataArray[indexPath.row]
        }else {
            vc.memoData = memoDataModel.unFixMemoDataArray[indexPath.row]
        }
        
        self.present(vc, animated: true)
    }
    
    //섹션의 간격을 없애주기 위해서 헤더뷰, 푸터뷰의 크기를 .zero로 만들고, 헤더와 푸터의 높이를 .zero로 만든다.
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: .zero)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: .zero)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}

//MARK: - 메모 Cell을 길게 눌렀을 때 삭제 기능을 하는 작업.
extension MemoViewController : MemoCellDelegate {
    func cellLognPressed(indexSection: Int, indexRow: Int) {
        
        if indexSection == 0{ //fixData 쪽에서 프레스 제스쳐가 일어남. == 클립설정
            let memoData = self.memoDataModel.fixMemodataArray[indexRow]
            deleteDataAlert(memoData: memoData)
            
        }else{ //unFixData 쪽에서 프레스 제스쳐가 일어남. == 클립설정 안함
            let memoData = self.memoDataModel.unFixMemoDataArray[indexRow]
            deleteDataAlert(memoData: memoData)
        }
    }
    
    //데이터를 삭제할지 물어보는 Alert
    private func deleteDataAlert(memoData : MemoData) {
        
        let action = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.handleDeleteMemoData(documentID: memoData.documentID)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        showAlert(title: "삭제", message: "메모를 삭제하시겠습니까?", actions: [action, cancelAction])
    }
    
    //데이터를 삭제할 때 성공과 에러에 대한 후처리
    private func handleDeleteMemoData(documentID: String) {
        editMemoDataService.deleteMemoData(documentID: documentID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(_):
                    self?.dismiss(animated: true)
                    
                case .failure(let err):
                    print("Error 메모 데이터 삭제 실패 : \(err.localizedDescription)")
                    self?.showAlert(title: "삭제 실패", message: "네트워크 상태를 확인해주세요.")
                }
            }
        }
    }
}

//MARK: - 메모 데이터를 가져오는 작업.
extension MemoViewController {
    private func handleGetMemoData() {
        CustomLoadingView.shared.startLoading(to: 0)
        
        memoDataService.getUserMemoData { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    
                case .success((let unFixDataArray, let fixDataArray)):
                    CustomLoadingView.shared.stopLoading()
                    
                    self?.memoDataModel.unFixMemoDataArray = unFixDataArray
                    self?.memoDataModel.fixMemodataArray = fixDataArray
                    self?.memoView.memoTableview.reloadData()
                    
                case .failure(let err):
                    CustomLoadingView.shared.stopLoading()
                    self?.showAlert(title: "데이터 가져오기 실패", message: err.localizedDescription)
                }
            }
        }
    }
}
