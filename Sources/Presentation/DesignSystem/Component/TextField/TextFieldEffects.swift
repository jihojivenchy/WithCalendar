//
//  TextFieldEffects.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2/1/24.
//

import UIKit

class TextFieldEffects : UITextField {
    
    /// 텍스트 필드와 포커스에 대한 애니메이션
    enum AnimationType: Int {
        case textEntry    // 입력 시작
        case textDisplay  // 입력 마침
    }
    
    typealias AnimationCompletionHandler = (_ type: AnimationType)->()
    
    let placeholderLabel = UILabel()
    
    /// '텍스트 입력'  상태로 전환될 때, 필요한 애니메이션 설정
    func animateViewsForTextEntry() {
        fatalError("\(#function) must be overridden")  // 오버라이딩하지 않으면 에러가 등장
    }
    
    /// '입력된 텍스트 표시' 상태로 전환될 때, 필요한 애니메이션 설정
    func animateViewsForTextDisplay() {
        fatalError("\(#function) must be overridden")  // 오버라이딩하지 않으면 에러가 등장
    }
    
    /// 텍스트 필드의 애니메이션 작업이 끝났을 때, 알림을 받는 데 사용
    var animationCompletionHandler: AnimationCompletionHandler?
    
    /// 주어진 rect(영역) 내에서 뷰를 그리는 데 사용
    func drawViewsForRect(_ rect: CGRect) {
        fatalError("\(#function) must be overridden")
    }
    
    /// 텍스트 필드의 크기나 위치가 변경될 때, 따라서 뷰의 업데이트 수행하는데 사용
    func updateViewsForBoundsChange(_ bounds: CGRect) {
        fatalError("\(#function) must be overridden")
    }
    
    // MARK: - Overrides
    override func draw(_ rect: CGRect) {
        guard isFirstResponder == false else { return }
        drawViewsForRect(rect)
    }
    
    override func drawPlaceholder(in rect: CGRect) {
        // Don't draw any placeholders
    }
    
    override var text: String? {
        didSet {
            // 텍스트 필드에 텍스트가 있거나, 현재 텍스트 필드가 활성 상태인지
            if let text = text, text.isNotEmpty || isFirstResponder {
                animateViewsForTextEntry()
            } else {
                animateViewsForTextDisplay()
            }
        }
    }
    
    // MARK: - UITextField Observing
    /// 텍스트 필드가 뷰 계층에 추가되거나 제거될 때 호출되는 메서드
    override func willMove(toSuperview newSuperview: UIView!) {
        // 텍스트 필드가 뷰 계층에 추가될 때, 옵저버를 추가
        if newSuperview != nil {
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: UITextField.textDidEndEditingNotification, object: self)
            
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: UITextField.textDidBeginEditingNotification, object: self)
        } else {
            // 텍스트 필드가 뷰 계층에서 제거될 때, 옵저버를 제거
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    /// 텍스트 필드에서 editing을 시작할 때
    @objc func textFieldDidBeginEditing() {
        animateViewsForTextEntry()
    }
    
    /// 텍스트 필드에서 editing을 마쳤을 때
    @objc func textFieldDidEndEditing() {
        animateViewsForTextDisplay()
    }
}

extension String {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}
