//
//  BaseViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2/1/24.
//

import UIKit

class BaseViewController: UIViewController {
   
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 기타 속성(데이터 소스, 네비게이션 바 등)들을 설정하기 위한 메서드
    func configureAttributes() { }
    
    /// UI와 관련된 속성들(뷰 계층, 레이아웃 등)을 설정하기 위한 메서드
    func configureLayouts() { }
}

// MARK: - Life cycles
extension BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .clear
//        navigationItem.backButtonTitle = ""
//        
        configureAttributes()
        configureLayouts()
    }
}
