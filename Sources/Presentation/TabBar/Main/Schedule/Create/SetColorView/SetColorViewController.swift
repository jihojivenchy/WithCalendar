//
//  SetColorViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit
import UIColorHexSwift

final class SetColorViewController: UIViewController {
    //MARK: - Properties
    final var setColorDataModel = SetColorDataModel()
    final let setColorView = SetColorView() //View
    
    final weak var setColorDelegate : SetColorDelegate?
    
    private lazy var navigationBackButton : UIBarButtonItem = {
        let button = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        button.tintColor = .black
        
        return button
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubViews()
    }

    //MARK: - ViewMethod
    private func setupSubViews() {
        view.backgroundColor = .clear
        
        view.addSubview(setColorView)
        setColorView.colorCollectionView.dataSource = self
        setColorView.colorCollectionView.delegate = self
        setColorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(380)
        }
        
        setColorView.colorWell.selectedColor = UIColor(setColorDataModel.selectedColor)
        setColorView.colorWell.addTarget(self, action: #selector(colorWellValueChanged(_:)), for: .valueChanged)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        
        if touch.view == self.view { //터치한 뷰가 현재 뷰컨트롤러의 뷰인지 체크.
            self.dismiss(animated: true)
        }
    }
    
    //MARK: - ButtonMethod
    
    @objc private func colorWellValueChanged(_ sender : UIColorWell) {
        // TODO: - HexColor 다뤄야함.
        let selectedColor = sender.selectedColor ?? .clear
//        let selectedColorString = selectedColor.hexValue()
        self.setColorDelegate?.selectedColor(color: "selectedColorString") //delegate로 전달.
    }
}

//MARK: - Extension
extension SetColorViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return setColorDataModel.colorArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SetColorCollectionViewCell.identifier, for: indexPath) as! SetColorCollectionViewCell
        
        let color = setColorDataModel.colorArray[indexPath.row]
        
        cell.colorImageView.backgroundColor = UIColor(color)
        
        if setColorDataModel.selectedColor == color {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        }
        
        return cell
    }
    
    //Cell 클릭 이벤트.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        triggerHapticFeedback() //유저에게 리액션을 주기 위한 미세한 진동음.
        
        let selectedColor = setColorDataModel.colorArray[indexPath.row]
        
        self.setColorDelegate?.selectedColor(color: selectedColor) //delegate로 컬러 전달.
        self.setColorDataModel.selectedColor = selectedColor             //컬러 저장.
        self.setColorView.titleLabel.textColor = UIColor(selectedColor)
    }
    
    //Cell Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 5
        
        return CGSize(width: width, height: 70)
    }
}

//MARK: - 유저가 선택한 Color 전달.
protocol SetColorDelegate : AnyObject {
    func selectedColor(color : String)
}
