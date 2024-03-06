//
//  CalendarCategoryViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit
import Tabman
import Pageboy

final class CalendarCategoryViewController: TabmanViewController {
    //MARK: - Properties
    private var viewControllers : [UIViewController] = []
    
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
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubViews()
        setupNavigationBar()
        
        let vc1 = PrivateCalendarViewController()
        let vc2 = ShareCalendarViewController()
        
        viewControllers.append(vc1)
        viewControllers.append(vc2)
        
        self.dataSource = self
        customTabBar()
    }
    
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        view.backgroundColor = .customWhiteAndBlackColor
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationItem.title = "카테고리"
        navigationItem.rightBarButtonItem = addRightButton
        navigationItem.backBarButtonItem = navigationBackButton
        navigationController?.navigationBar.tintColor = .blackAndWhiteColor
        
    }
    
    private func customTabBar() {
        // Create bar
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        
        //bar안에 버튼 숫자에 맞게 버튼을 배치.
        bar.layout.contentMode = .fit
        bar.layout.alignment = .centerDistributed
        
        //bar의 하단 인디케이터.
        bar.indicator.weight = .light
        bar.indicator.tintColor = .signatureColor
        
        bar.indicator.overscrollBehavior = .bounce
        
        //bar의 컬러
        bar.backgroundView.style = .clear
        
        //선택되었을 때와 선택되지 않았을 때
        bar.buttons.customize { button in
            button.tintColor = .darkGray
            button.selectedTintColor = .blackAndWhiteColor
            
            button.font = .boldSystemFont(ofSize: 13)
            button.selectedFont = .boldSystemFont(ofSize: 15.5)
        }

        // Add to view
        addBar(bar, dataSource: self, at: .top)
    }
    
    //MARK: - ButtonMethod
    @objc private func addButtonPressed(_ sender : UIBarButtonItem) {
        self.navigationController?.pushViewController(CreateShareCalendarViewController(), animated: true)
    }
}


extension CalendarCategoryViewController : PageboyViewControllerDataSource, TMBarDataSource {
    // MARK: - PageboyViewControllerDataSource
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    // MARK: - TMBarDataSource
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        if index == 0 {
            return TMBarItem(title: "개인달력")
        }else{
            return TMBarItem(title: "공유달력")
        }
    }
}
    






