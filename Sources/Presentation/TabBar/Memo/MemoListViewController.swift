//
//  MemoListViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit
import UIColorHexSwift
import FirebaseAuth
import FirebaseFirestore

final class MemoListViewController: BaseViewController {
    // MARK: - UI
    private lazy var memoListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(MemoListCell.self)
        tableView.delegate = self
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var createMemoButton : UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .done,
            target: self,
            action: #selector(createMemoButtonTapped(_:))
        )
        return button
    }()
    
    private lazy var navigationBackButton : UIBarButtonItem = {
        let button = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        return button
    }()
    
    // MARK: - Properties
    private var memoDataModel = MemoDataModel()
    private let memoDataService = MemoDataService()
    private let editMemoDataService = EditMemoDataService() //삭제 기능 사용하기 위해서.
    
    private typealias DataSource = UITableViewDiffableDataSource<Section, MemoData>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MemoData>
    private var dataSource: DataSource?
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        tabBarController?.tabBar.isHidden = false
        handleFetchMemoList()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: Configuration
    override func configureAttributes() {
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = createMemoButton
        configureNavigationBarAppearance()
        configureDataSource()
    }
    
    // MARK: - Layouts
    override func configureLayouts() {
        view.backgroundColor = .customWhiteAndBlackColor
        view.addSubview(memoListTableView)
        memoListTableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    //MARK: - ButtonMethod
    @objc private func createMemoButtonTapped(_ sender : UIBarButtonItem) {
        guard isUserLoggedIn() else{
            showAlert(title: "로그인", message: "로그인이 필요한 서비스입니다.")
            return
        }
        
        navigationController?.pushViewController(AddMemoViewController(), animated: true)
    }
}

// MARK: - DiffableDataSource
extension MemoListViewController {
    private func configureDataSource() {
        dataSource = DataSource(
            tableView: memoListTableView
        ) { [weak self] tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(MemoListCell.self, for: indexPath) else {
                return UITableViewCell()
            }
            guard let self else { return UITableViewCell() }
            
            cell.configure(memoData: item)
            cell.delegate = self
            return cell
        }
    }
   
    private func applySectionSnapshot(with memoList: [MemoData]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(memoList)
        dataSource?.apply(snapshot)
    }
}

extension MemoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //cell을 클릭했을 때 애니메이션 구현
        triggerHapticFeedback() //유저에게 리액션을 주기 위한 미세한 진동음.
        
        let snapshot = dataSource?.snapshot()
        if let item = snapshot?.itemIdentifiers[indexPath.row] {
            let vc = EditMemoViewController()
            vc.memoData = item
            present(vc, animated: true)
        }
    }
}

// MARK: - Cell Delegate
extension MemoListViewController : MemoCellDelegate {
    func longPressed(documentID: String) {
        let action = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.handleDeleteMemoData(documentID: documentID)
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

// MARK: - 메모 데이터를 가져오는 작업.
extension MemoListViewController {
    /// 메모 리스트 조회
    private func fetchMemoList(completion: @escaping (Result<[MemoData], NetworkError>) -> Void) {
        let db = Firestore.firestore()
        
        // 유저 정보 가져오기
        guard let user = Auth.auth().currentUser else {
            completion(.failure(.authenticationRequired))
            return
        }
        
        // 유저의 메모 컬렉션에 접근
        db.collection("\(user.uid).메모").order(by: "date", descending: true).addSnapshotListener { qs, error in
            var memoList: [MemoData] = []
            
            guard let snapshotDocuments = qs?.documents else {
                completion(.failure(.unknown(error?.localizedDescription)))
                return
            }
            
            // 도큐먼트 리스트를 순회하며, 데이터 조회 -> 가공 -> 리스트에 추가
            snapshotDocuments.forEach { snapshot in
                let data = snapshot.data()
                
                guard let memoData = data["memo"] as? String,
                      let dateData = data["date"] as? String,
                      let fixData = data["fix"] as? Int,
                      let fixColorData = data["fixColor"] as? String else{return}
                
                // 리스트에 추가
                memoList.append(MemoData(
                    memo: memoData,
                    date: dateData,
                    fix: fixData,
                    fixColor: fixColorData,
                    documentID: snapshot.documentID
                ))
            }
            
            // 중요 메모를 앞으로 정렬
            memoList.sort { (first, second) -> Bool in
                return first.fix > second.fix
            }
            completion(.success(memoList))
        }
    }
    
    /// 메모 리스트 조회 및 결과 핸들링
    private func handleFetchMemoList() {
        CustomLoadingView.shared.startLoading(to: 0)
        
        fetchMemoList { result in
            DispatchQueue.main.async { [weak self] in
                CustomLoadingView.shared.stopLoading()
                guard let self else { return }
                
                switch result {
                case .success(let memoList):
                    self.applySectionSnapshot(with: memoList)
                    
                case .failure(let error):
                    self.showErrorAlert(error)
                    
                }
            }
        }
    }
    
    /// 에러 종류에 따라 달리 보여주는 Alert
    private func showErrorAlert(_ error: NetworkError) {
        switch error {
        case .authenticationRequired:
            showAlert(title: "로그인 오류", message: "로그인이 필요합니다.")
            
        case .unknown(let description):
            showAlert(title: "오류", message: description ?? "알 수 없는 오류가 발생했습니다.")
        }
    }
}

extension MemoListViewController {
    enum Section: CaseIterable {
        case main
    }
}
