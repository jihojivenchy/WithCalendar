//
//  WCTextField.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2/1/24.
//

import UIKit

//titleTextField.tintColor = .blackAndWhiteColor
//titleTextField.textColor = .blackAndWhiteColor
//titleTextField.returnKeyType = .done
//titleTextField.font = .boldSystemFont(ofSize: 18)
//titleTextField.placeholderFontScale = 0.7
//titleTextField.placeholder = "달력이름"
//titleTextField.placeholderColor = .darkGray
//titleTextField.borderInactiveColor = .clear
//titleTextField.borderActiveColor = .darkGray

class WCTextField: TextFieldEffects {
    
    /// 텍스트 필드에 텍스트가 없을 때, 테두리 색상
    dynamic var borderInactiveColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    
    /// 텍스트 필드에 텍스트가 있을 때, 테두리 색상
    dynamic var borderActiveColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    
    /// 텍스트 필드의 플레이스 홀더 색상
    dynamic var placeholderColor: UIColor = .black {
        didSet {
            updatePlaceholder()
        }
    }
    
    /// 텍스트 필드의 플레이스 홀더 폰트 크기
    dynamic var placeholderFontScale: CGFloat = 0.65 {
        didSet {
            updatePlaceholder()
        }
    }
    
    /// 플레이스 홀더
    override var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            updateBorder()
            updatePlaceholder()
        }
    }
    
    /// 텍스트 필드의 활성 및 비활성 상태에 따라 테두리 두께를 정의
    private let borderThickness: (active: CGFloat, inactive: CGFloat) = (active: 2, inactive: 0.5)
    
    /// 비 활성화 상태의 테두리
    private let inactiveBorderLayer = CALayer()
    
    /// 활성화 상태의 테두리
    private let activeBorderLayer = CALayer()
    
    private let placeholderInsets = CGPoint(x: 0, y: 6)
    private let textFieldInsets = CGPoint(x: 0, y: 12)
    
    /// 활성화 상태일 때, 플레이스홀더 라벨의 위치
    private var activePlaceholderPoint: CGPoint = CGPoint.zero
    
    // MARK: - TextFieldEffects
    
    override func drawViewsForRect(_ rect: CGRect) {
        // 주어진 rect를 통해 frame 생성
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: rect.size.width, height: rect.size.height))
        
        // 플레이스 홀더 위치 조정
        placeholderLabel.frame = frame.insetBy(dx: placeholderInsets.x, dy: placeholderInsets.y)
        placeholderLabel.font = placeholderFontFromFont(font!)
        
        // 업데이트
        updateBorder()
        updatePlaceholder()
        
        // 레이어 추가
        layer.addSublayer(inactiveBorderLayer)
        layer.addSublayer(activeBorderLayer)
        
        addSubview(placeholderLabel)
    }
    
    override func animateViewsForTextEntry() {
        guard let text else { return }
        
        if text.isEmpty {
            UIView.animate(
                withDuration: 0.3,
                delay: 0.0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 1.0,
                options: .beginFromCurrentState,
                animations: ({ [weak self] in
                    guard let self else { return }
                    self.placeholderLabel.frame.origin = CGPoint(x: 10, y: self.placeholderLabel.frame.origin.y)
                    self.placeholderLabel.alpha = 0
            
                }), completion: { [weak self] _ in
                    self?.animationCompletionHandler?(.textEntry)
                }
            )
        }
        
        layoutPlaceholderInTextRect()
        placeholderLabel.frame.origin = activePlaceholderPoint
        
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.placeholderLabel.alpha = 1.0
        })
        
        activeBorderLayer.frame = rectForBorder(borderThickness.active, isFilled: true)
    }
    
    override func animateViewsForTextDisplay() {
        if let text = text, text.isEmpty {
            UIView.animate(
                withDuration: 0.35,
                delay: 0.0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 2.0,
                options: .beginFromCurrentState,
                animations: ({ [weak self] in
                    guard let self else { return }
                    self.layoutPlaceholderInTextRect()
                    self.placeholderLabel.alpha = 1
                    
                }), completion: { [weak self] _ in
                    self?.animationCompletionHandler?(.textDisplay)
                }
            )
            
            activeBorderLayer.frame = rectForBorder(borderThickness.active, isFilled: false)
            inactiveBorderLayer.frame = rectForBorder(borderThickness.inactive, isFilled: true)
        }
    }
    
    // MARK: - Private
    private func updateBorder() {
        inactiveBorderLayer.frame = rectForBorder(borderThickness.inactive, isFilled: !isFirstResponder)
        inactiveBorderLayer.backgroundColor = borderInactiveColor?.cgColor
        
        activeBorderLayer.frame = rectForBorder(borderThickness.active, isFilled: isFirstResponder)
        activeBorderLayer.backgroundColor = borderActiveColor?.cgColor
    }
    
    private func updatePlaceholder() {
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.sizeToFit()
        layoutPlaceholderInTextRect()
        
        if isFirstResponder || text!.isNotEmpty {
            animateViewsForTextEntry()
        }
    }
    
    private func placeholderFontFromFont(_ font: UIFont) -> UIFont! {
        let smallerFont = UIFont(descriptor: font.fontDescriptor, size: font.pointSize * placeholderFontScale)
        return smallerFont
    }
    
    private func rectForBorder(_ thickness: CGFloat, isFilled: Bool) -> CGRect {
        if isFilled {
            return CGRect(origin: CGPoint(x: 0, y: frame.height-thickness), size: CGSize(width: frame.width, height: thickness))
        } else {
            return CGRect(origin: CGPoint(x: 0, y: frame.height-thickness), size: CGSize(width: 0, height: thickness))
        }
    }
    
    private func layoutPlaceholderInTextRect() {
        let textRect = self.textRect(forBounds: bounds)
        var originX = textRect.origin.x
        switch self.textAlignment {
        case .center:
            originX += textRect.size.width/2 - placeholderLabel.bounds.width/2
        case .right:
            originX += textRect.size.width - placeholderLabel.bounds.width
        default:
            break
        }
        placeholderLabel.frame = CGRect(x: originX, y: textRect.height/2,
                                        width: placeholderLabel.bounds.width, height: placeholderLabel.bounds.height)
        activePlaceholderPoint = CGPoint(x: placeholderLabel.frame.origin.x, y: placeholderLabel.frame.origin.y - placeholderLabel.frame.size.height - placeholderInsets.y)
        
    }
    
    // MARK: - Overrides
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: textFieldInsets.x, dy: textFieldInsets.y)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: textFieldInsets.x, dy: textFieldInsets.y)
    }
}
