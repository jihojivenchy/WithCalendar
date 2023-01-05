//
//  CalendarCategoryViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/01/02.
//

import UIKit
import SnapKit
import Tabman
import Pageboy

final class CalendarCategoryViewController: TabmanViewController {
//MARK: - Properties
    final var delegate : CalendarCellPressDelegate?
    
    private var viewControllers : Array<UIViewController> = []
    private var titleArray : [String] = ["개인달력", "공유달력"]
    
    private lazy var addCalendarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(addButtonPressed(_:)))
        
        return button
    }()
    
    private lazy var navigationBackButton : UIBarButtonItem = {
        let button = UIBarButtonItem(title: nil, style: .plain, target: self, action: nil)
        return button
    }()
    
    //MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = .displayModeColor2
        navigationController?.navigationBar.prefersLargeTitles = true
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .displayModeColor1
        
        navBarAppearance()
        appendViewControllers()
        
        self.dataSource = self
        setBar()
    }
    
    //MARK: - View Method
    
    private func appendViewControllers() {
        let vc1 = PrivateCalendarViewController()
        let vc2 = ShareCalendarViewController()
        
        vc1.delegate = self
        vc2.delegate = self
        
        self.viewControllers.append(vc1)
        self.viewControllers.append(vc2)
    }
    
    private func navBarAppearance() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .displayModeColor1
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.topItem?.title = ""
        
        navigationItem.title = "Category"
        navigationItem.rightBarButtonItem = addCalendarButton
        navigationItem.backBarButtonItem = navigationBackButton
    }
    
    private func setBar() {
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap //Customize
        
        // Add to view
        addBar(bar, dataSource: self, at: .top)
        
        bar.backgroundView.style = .clear //버튼 백그라운드 스타일
        bar.layout.contentMode = .fit
        
        bar.buttons.customize { (button) in
            button.tintColor = .darkGray
            button.selectedTintColor = .displayModeColor2
            button.font = .systemFont(ofSize: 13)
            button.selectedFont = .boldSystemFont(ofSize: 15)
        }
        
        bar.indicator.tintColor = .customSignatureColor
        bar.indicator.weight = .light
        bar.indicator.overscrollBehavior = .bounce
        
        
    }
    
    //MARK: - ButtonMethod
    @objc private func addButtonPressed(_ sender : UIBarButtonItem) {
        self.navigationController?.pushViewController(AddShareCalendarViewController(), animated: true)
    }
}

//MARK: - Extension
extension CalendarCategoryViewController : PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        
        return viewControllers[index]
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        
        let item = TMBarItem(title: "")
        item.title = self.titleArray[index]
        
        return item
    }
    
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        
        return .at(index: 0)
    }
}

protocol CalendarCellPressDelegate {
    func cellPressed()
}

extension CalendarCategoryViewController : PrivateCalendarCellDelegate {
    func privateCellPressed() {
        self.delegate?.cellPressed()
        print("zz")
    }
}

extension CalendarCategoryViewController : ShareCalendarCellDelegate {
    func shareCellPressed() {
        self.delegate?.cellPressed()
        print("gg")
    }
}
