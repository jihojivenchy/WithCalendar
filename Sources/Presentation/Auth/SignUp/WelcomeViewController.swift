//
//  WelcomeViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit
import Lottie

final class WelcomeViewController: UIViewController {
    //MARK: - Properties
    final let welcomeView = WelcomeView() //View
    final var userName = ""
    private lazy var navigationBackButton : UIBarButtonItem = {
        let button = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return button
    }()
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubViews()
        setupNavigationBar()
    }

    //MARK: - ViewMethod
    private func setupSubViews() {
        view.backgroundColor = .whiteAndBlackColor
        
        view.addSubview(welcomeView)
        welcomeView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        welcomeView.titleLabel.text = "\(userName)님 With Claendar에 오신 것을 환영합니다!"
        welcomeView.homeButton.addTarget(self, action: #selector(homeButtonPressed(_:)), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    //MARK: - ButtonMethod
    
    @objc private func homeButtonPressed(_ sender : UIButton){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
