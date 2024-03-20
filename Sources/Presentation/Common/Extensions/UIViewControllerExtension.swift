//
//  UIViewControllerExtension.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import FirebaseAuth

extension UIViewController {
    func triggerHapticFeedback() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
    }
    
    func showAlert(title : String, message: String? = nil, actions: [UIAlertAction]? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let alertActions = actions {
            //action을 차례대로 컨트롤러에 추가.
            for action in alertActions {
                action.setValue(UIColor.blackAndWhiteColor, forKey: "titleTextColor")
                alertController.addAction(action)
            }
            
        }else{
            let defaultAction = UIAlertAction(title: "확인", style: .default)
            defaultAction.setValue(UIColor.blackAndWhiteColor, forKey: "titleTextColor")
            
            alertController.addAction(defaultAction)
        }
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
        
    }
    
    // 애니메이션
    func performTransition(with view: UIView, duration: TimeInterval) {
        UIView.transition(with: view, duration: duration, options: .transitionCrossDissolve, animations: nil)
    }
    
    func showToast(message: String, durationTime : TimeInterval, delayTime : TimeInterval, width : CGFloat) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - (width / 2), y: view.frame.size.height-100, width: width, height: 40))
        
        toastLabel.backgroundColor = .signatureColor
        toastLabel.textColor = UIColor.white
        toastLabel.font = .boldSystemFont(ofSize: 16)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: durationTime, delay: delayTime, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    //개인 캘린더의 CollectionID와 DocumentID를 저장해둠. 달력에 이벤트를 저장할 때 해당 경로로 데이터를 저장함.
    func saveDataPathInUserDefaults(userUID: String) {
        UserDefaults.standard.set(userUID, forKey: "CalendarColletionID")
        UserDefaults.standard.set("With Calendar", forKey: "CalendarDocumentID")
        UserDefaults.standard.set("With Calendar", forKey: "CurrentSelectedCalendarName")
    }
    
    //데이터 경로 정보를 초기화. 로그아웃하면 데이터를 볼 수 없도록 하기 위해서 초기화를 해줌.
    func initDataPath() {
        UserDefaults.standard.set("", forKey: "CalendarColletionID")
        UserDefaults.standard.set("", forKey: "CalendarDocumentID")
        UserDefaults.standard.set("With Calendar", forKey: "CurrentSelectedCalendarName")
    }
    
    //유저의 로그인 상태를 파악.
    func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    //이벤트가 공휴일인지 체크. 공휴일데이터는 삭제나 편집을 못하도록 만들기 위해서.
    func checkHolidayData(color: String) -> Bool {
        return color != "#CC3636FF"
    }
}

// MARK: - NavigationBarAppearance
extension UIViewController {
    func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .blackAndWhiteColor
    }
}

// MARK: - Hide Keyboard
extension UIViewController {
    /// 화면의 빈 공간을 터치해 키보드를 가리고 싶은 경우, 필요한 뷰 컨트롤러에서 메서드 호출.
    /// 사용 시  tap gesture recognizer간 충돌 발생하지 않도록 주의해서 사용해야함.
    func enableKeyboardHiding(shouldCancelTouchesInView: Bool = true) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = shouldCancelTouchesInView
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}
