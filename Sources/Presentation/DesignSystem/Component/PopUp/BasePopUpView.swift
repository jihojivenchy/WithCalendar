//
//  BasePopUpView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 3/16/24.
//

import UIKit
import SnapKit

class BasePopUpView: BaseView {
    // MARK: - UI
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return view
    }()
    
    let dragHandleBar: UIView = {
        let view = UIView()
//        view.flex.width(25).height(5)
        view.backgroundColor = WCColor.gray08
        view.clipsToBounds = true
        view.layer.cornerRadius = 2.5
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        
        return label
    }()
    
    let completeButton = WCButton(title: "완료")
    
    // MARK: - Property
    /// 팝업 뷰의 높이(상속받는 객체는 이를 설정해주어야 함)
    var containerHeight: CGFloat { 0 }
    
    /// 드래그로 뷰를 어느 정도까지 내렸을 때 dismiss할 것인지 결정하는 y
    var dismissYPosition: CGFloat { 0 }
    
    // MARK: - Configuration
    override func configureAttributes() {
        backgroundColor = WCColor.backgroundBlur
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        container.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(container)
        addSubview(dragHandleBar)
        addSubview(titleLabel)
        addSubview(completeButton)
        
        container.snp.makeConstraints { make in
            make.top.equalTo(self.snp_bottomMargin)
            make.left.right.equalToSuperview()
            make.height.equalTo(containerHeight)
        }
    }
    
    // MARK: - HandleGesture
    @objc
    func handlePanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: container)
        let velocity = sender.velocity(in: container)
        
        let currentTranslationY: CGFloat = -containerHeight  // 초기 컨테이너의 오프셋
        let calculatedTranslationY = currentTranslationY + translation.y  // 초기 오프셋을 고려한 결과값
        
        switch sender.state {
        case .changed:
            // 아래로 드래그하거나 최대 높이 이내에서만 transform을 적용
            if calculatedTranslationY > currentTranslationY && calculatedTranslationY <= 0 {
                container.transform = CGAffineTransform(translationX: 0, y: calculatedTranslationY)
            }
            
        case .ended:
            if velocity.y > 1500 || calculatedTranslationY > -dismissYPosition {
                hide()
                
            } else {  // 원상복구
                UIView.animate(withDuration: 0.2) { [weak self] in
                    guard let self else { return }
                    self.container.transform = CGAffineTransform(translationX: 0, y: currentTranslationY)
                }
            }
            
        default:
            break
        }
    }
    
    // MARK: - Show & Hide
    func show() {
        setLayout()
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self else { return }
            self.container.transform = CGAffineTransform(translationX: 0, y: -containerHeight)
        })
    }

    private func setLayout() {
        let window = UIWindow.visibleWindow() ?? UIWindow()
        window.addSubview(self)
        window.bringSubviewToFront(self)
        
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func hide() {
        UIView.animate(
            withDuration: 0.2,
            animations: { [weak self] in
                guard let self else { return }
                self.container.transform = .identity
                
            }, completion: { [weak self] _ in
                guard let self else { return }
                self.removeFromSuperview()
            }
        )
    }
}

extension BasePopUpView {
    func addTapGestureForHide() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundTapped)))
    }
    
    @objc private func backgroundTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        
        if !container.frame.contains(location) {
            hide()
        }
    }
}

