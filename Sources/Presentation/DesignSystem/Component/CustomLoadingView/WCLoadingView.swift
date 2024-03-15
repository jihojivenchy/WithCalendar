//
//  WCLoadingView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 3/15/24.
//

import UIKit
import SnapKit
import NVActivityIndicatorView

final class WCLoadingView: BaseView {
    private let activityIndicator = NVActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 50, height: 50),
        type: .ballRotateChase,
        color: .signatureColor,
        padding: 0
    )
    
    init(backgroundColor: UIColor = .clear) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }
    
    override func configureLayouts() {
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    func startLoading() {
        guard let window = UIWindow.visibleWindow() else { return }
        window.addSubview(self)
        
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        self.snp.removeConstraints()
        activityIndicator.stopAnimating()
    }
}
