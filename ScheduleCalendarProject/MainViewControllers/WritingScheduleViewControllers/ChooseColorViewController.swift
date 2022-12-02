//
//  ChooseColorViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/11/02.
//

import UIKit
import SnapKit
import UIColor_Hex_Swift

final class ChooseColorViewController: UIViewController {
//MARK: - Properties
    
    var dataDelegate : sendSelectedDataDelegate?
    
    private let colorView = UIView()
    private let colorLabel = UILabel()
    private let colorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
      
    private let colorArray : [UIColor] = [UIColor.customLightPuple ?? UIColor(), UIColor.customLacoste ?? UIColor(), UIColor.customAhbocado ?? UIColor(), UIColor.customPastelPink ?? UIColor(), UIColor.customSoda ?? UIColor(), UIColor.customMint ?? UIColor(), UIColor.customPink ?? UIColor(), UIColor.customBaige ?? UIColor(), UIColor.customYellow ?? UIColor(), UIColor.customOrange ?? UIColor(), UIColor.customChocolet ?? UIColor(), UIColor.customHotPink ?? UIColor(), UIColor.customPastelBlue ?? UIColor(), UIColor.customPastelGreen ?? UIColor()]
    
    private var indexNumber : Int?
    
//MARK: - LifeCycle
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        
        colorCollectionView.register(ChooseColorCollectionViewCell.self, forCellWithReuseIdentifier: ChooseColorCollectionViewCell.identifier)
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
    }
    
//MARK: - ViewMethod
    
    private func addSubViews() {
        guard let selectedColor = UserDefaults.standard.string(forKey: "selectedColor") else{return}
        
        view.backgroundColor = .clear
        
        view.addSubview(colorView)
        colorView.backgroundColor = .white
        colorView.clipsToBounds = true
        colorView.layer.cornerRadius = 10
        colorView.layer.masksToBounds = false
        colorView.layer.shadowColor = UIColor.black.cgColor
        colorView.layer.shadowOffset = CGSize(width: 0, height: 0)
        colorView.layer.shadowRadius = 10
        colorView.layer.shadowOpacity = 0.5
        colorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.right.left.equalToSuperview()
            make.height.equalTo(320)
        }
        
        colorView.addSubview(colorCollectionView)
        colorCollectionView.backgroundColor = .white
        colorCollectionView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(250)
        }
        
        colorView.addSubview(colorLabel)
        colorLabel.text = "Color"
        colorLabel.textAlignment = .center
        colorLabel.font = .boldSystemFont(ofSize: 23)
        colorLabel.sizeToFit()
        colorLabel.textColor = UIColor(selectedColor)
        colorLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.dismiss(animated: true)
    }
}

//MARK: - Extension
extension ChooseColorViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colorArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChooseColorCollectionViewCell.identifier, for: indexPath) as! ChooseColorCollectionViewCell
        
        cell.colorImage.backgroundColor = self.colorArray[indexPath.row]
        cell.tintColor = .white
        
        
        if let selectedIndex = UserDefaults.standard.string(forKey: "selectedIndex"){
            //만약 저장된 컬러 index가 있다면 인덱스에 맞는 컬러 선택되서 나오도록
            
            if indexPath.row == Int(selectedIndex){
                cell.colorImage.image = UIImage(systemName: "checkmark.circle")

            }else {
                cell.colorImage.image = .none
                
            }
        }
        
        
        
        return cell
    }
    
    
}

extension ChooseColorViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedItem = collectionView.cellForItem(at: indexPath) as? ChooseColorCollectionViewCell else{return}
        
        self.colorLabel.textColor = selectedItem.colorImage.backgroundColor
        
        UserDefaults.standard.set("\(colorArray[indexPath.row].hexString())", forKey: "selectedColor")
        UserDefaults.standard.set("\(indexPath.row)", forKey: "selectedIndex")
        
        
        dataDelegate?.sendData(data: colorArray[indexPath.row].hexString())
        
        self.indexNumber = indexPath.row
        
        collectionView.reloadData()
    }
    
}

extension ChooseColorViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 5
        
        return CGSize(width: width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return .zero
    }
}


protocol sendSelectedDataDelegate {
    
    func sendData(data : String)
}
