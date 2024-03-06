//
//  DisplayModeViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class DisplayModeViewController: UIViewController {
    //MARK: - Properties
    final let displayModeDataModel = DisplayModeDataModel()
    final let displayModeView = DisplayModeView() //View
    
    
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
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        view.backgroundColor = .customWhiteAndBlackColor
        
        view.addSubview(displayModeView)
        displayModeView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        displayModeView.optionsTableview.register(OptionTableViewCell.self, forCellReuseIdentifier: OptionTableViewCell.identifier)
        displayModeView.optionsTableview.delegate = self
        displayModeView.optionsTableview.dataSource = self
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationItem.title = "화면 설정"
        navigationController?.navigationBar.tintColor = .blackAndWhiteColor
    }
    
    //MARK: - ButtonMethod
    
}

//MARK: - Extension
extension DisplayModeViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayModeDataModel.displayOptionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OptionTableViewCell.identifier, for: indexPath) as! OptionTableViewCell
        
        let displayOption = displayModeDataModel.displayOptionArray[indexPath.row]
        
        cell.titleLabel.text = displayOption
        cell.tintColor = .signatureColor
        
        
        //저장되어 있는 인덱스를 가져와서 체크마크에 이용함.
        let interfaceIndex = UserDefaults.standard.integer(forKey: "Appearance")
        
        if indexPath.row == interfaceIndex {
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
        changeInterfaceStyle(index: indexPath.row)
        tableView.reloadData()
        
    }
}

extension DisplayModeViewController{
    private func changeInterfaceStyle(index : Int) {
        //그냥 뷰의 overrideUserInterfacestyle을 변경하는 것은 다른 뷰로 넘어갔을 때 제대로 적용되지 않고, 상태바에도 문제가 생김
        //이유는 뷰의 인터페이스 스타일을 변경해주면 뷰의 서브뷰에는 모두 적용이되지만, 상위계층에 있는 슈퍼뷰들에는 적용이되지 않음.
        //따라서 뷰의 최상위 계층에 있는 window의 스타일을 변경해줌.
        view.window?.overrideUserInterfaceStyle = UIUserInterfaceStyle(
            rawValue: index) ?? .unspecified
        
        //앱을 재시동했을 때도 유지될 수 있도록 저장해둠.
        UserDefaults.standard.set(index, forKey: "Appearance")
    }
}
