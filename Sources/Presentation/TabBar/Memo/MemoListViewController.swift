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
    private let memoService = MemoService()
    
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
        fetchMemoList()
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
        
        navigationController?.pushViewController(CreateMemoViewController(), animated: true)
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
            self?.deleteMemo(documentID: documentID)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        showAlert(title: "삭제", message: "메모를 삭제하시겠습니까?", actions: [action, cancelAction])
    }
    
    /// 메모 삭제
    private func deleteMemo(documentID: String) {
        Task {
            do {
                try await memoService.deleteMemo(documentID: documentID)
                deleteMemoItem(documentID: documentID)
            } catch {
                showErrorAlert(error)
            }
        }
    }
    
    /// 현재 메모 리스트에서 삭제된 데이터를 제거 및 업데이트
    private func deleteMemoItem(documentID: String) {
        guard let currentSnapshot = dataSource?.snapshot() else { return }
        
        if let deletedItem = currentSnapshot
            .itemIdentifiers(inSection: .main)
            .first(where: { $0.documentID == documentID })
        {
            var updatedSnapshot = currentSnapshot
            updatedSnapshot.deleteItems([deletedItem])
            dataSource?.apply(updatedSnapshot)
        }
    }
}

// MARK: - 메모 데이터를 가져오는 작업.
extension MemoListViewController {
    /// 메모 리스트 조회
    private func fetchMemoList() {
        CustomLoadingView.shared.startLoading(to: 0)
        
        Task {
            do {
                let memoList = try await memoService.fetchMemoList()
                applySectionSnapshot(with: memoList)
                
            } catch {
                showErrorAlert(error)
            }
            CustomLoadingView.shared.stopLoading()
        }
    }
    
    /// 에러 종류에 따라 달리 보여주는 Alert
    private func showErrorAlert(_ error: Error) {
        guard let networkError = error as? NetworkError else {
            showAlert(title: "오류", message: error.localizedDescription)
            return
        }
        
        switch networkError {
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
