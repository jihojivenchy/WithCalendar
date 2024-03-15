////
////  CustomLoadingView.swift
////  ScheduleCalendarProject
////
////  Created by 엄지호 on 2023/04/19.
////
//
//import UIKit
//import SnapKit
//import NVActivityIndicatorView
//
//final class CustomLoadingView {
//    static let shared = CustomLoadingView()
//    
//    private let backgroundView = UIView()
//    private let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50),
//                                                          type: .ballRotateChase,
//                                                          color: .signatureColor,
//                                                          padding: 0)
//    
//    private init() {
//        backgroundView.addSubview(activityIndicator)
//        activityIndicator.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
//        }
//    }
//    
//    
//    func startLoading(to alpha: CGFloat) {
//        DispatchQueue.main.async {
//            let windowScene = UIApplication.shared.connectedScenes.first {$0.activationState == .foregroundActive} as? UIWindowScene
//            
//            windowScene?.windows.first?.addSubview(self.backgroundView)
//            self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(alpha)
//            self.backgroundView.snp.makeConstraints { (make) in
//                make.edges.equalToSuperview()
//            }
//            
//            self.activityIndicator.startAnimating()
//        }
//        
//    }
//    
//    func stopLoading() {
//        DispatchQueue.main.async {
//            self.activityIndicator.stopAnimating()
//            self.backgroundView.snp.removeConstraints()
//        }
//    }
//}
