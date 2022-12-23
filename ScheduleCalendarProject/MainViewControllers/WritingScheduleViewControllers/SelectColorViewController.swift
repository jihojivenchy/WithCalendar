//
//  TestColorViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/12/22.
//

import UIKit
import SnapKit
import UIColor_Hex_Swift

final class SelectColorViewController: UIViewController {
//MARK: - Properties
    private let colorView = UIView()
    
    var colorDelegate : ColorCellDataDelegate?
    var colorName : String = ""{
        didSet{
            setSrollIndex()
        }
    }
    private var scrollIndex = Int()
    
    private lazy var colorCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.isPagingEnabled = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    private let greenColorSet : [String] = ["#009556FF", "#65C18CFF", "#3A6351FF", "#519259FF", "#6ECCAFFF", "#4FA095FF", "#CEEDC7FF", "#C6D57EFF"]
    
    private let pinkColorSet : [String] = ["#FCD1D1FF", "#F56EB3FF", "#C9485BFF", "#FAD9E6FF", "#E8A0BFFF", "#FDCFDFFF", "#FC9D9DFF", "#FF8787FF"]
    
    private let blueColorSet : [String] = ["#A6B1E1FF", "#ABD9FFFF", "#91D8E4FF", "#8D9EFFFF", "#5F9DF7FF", "#47B5FFFF", "#277BC0FF", "#4B56D2FF"]
    
    private lazy var pageControl : UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = 3
        pc.currentPage = scrollIndex
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = .displayModeColor2
        
        return pc
    }()
    
    //MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        
        colorCollectionView.register(ColorSetCollectionViewCell.self, forCellWithReuseIdentifier: ColorSetCollectionViewCell.identifier)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToIndex()
    }
    
    //MARK: - ViewMethod
    
    private func addSubViews() {
        view.backgroundColor = .clear
        
        view.addSubview(colorView)
        colorView.backgroundColor = .displayModeColor3
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
            make.height.equalTo(300)
        }
        
        colorView.addSubview(colorCollectionView)
        colorCollectionView.showsHorizontalScrollIndicator = false
        colorCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(240)
        }
        
        colorView.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.dismiss(animated: true)
    }
    
    private func scrollToIndex() {
        colorCollectionView.scrollToItem(at: IndexPath(item: scrollIndex, section: 0), at: .centeredHorizontally, animated: true)
        colorCollectionView.isPagingEnabled = true
    }
    
    private func setSrollIndex() {
        if greenColorSet.contains(self.colorName) {
            scrollIndex = 0
        }else if pinkColorSet.contains(self.colorName){
            scrollIndex = 1
        }else{
            scrollIndex = 2
        }
    }
}

//MARK: - Extension
extension SelectColorViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorSetCollectionViewCell.identifier, for: indexPath) as! ColorSetCollectionViewCell
        
        if indexPath.row == 0 {
            cell.titleLabel.textColor = .customSignatureColor
            cell.titleLabel.text = "Green Set"
            cell.colorArray = self.greenColorSet
            
        }else if indexPath.row == 1 {
            cell.titleLabel.textColor = .customPink1
            cell.titleLabel.text = "Pink Set"
            cell.colorArray = self.pinkColorSet
            
        }else{
            cell.titleLabel.textColor = .customBlue6
            cell.titleLabel.text = "Blue Set"
            cell.colorArray = self.blueColorSet
        }
        
        cell.colorDelegate = self
        cell.colorName = self.colorName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let page = Int(targetContentOffset.pointee.x / colorCollectionView.frame.width)
        self.pageControl.currentPage = page
        
    }
}

extension SelectColorViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension SelectColorViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        
        return CGSize(width: width, height: height)
    }
}

extension SelectColorViewController : ColorCellDataDelegate {
    func sendColorData(_ colorData: String) {
        self.colorDelegate?.sendColorData(colorData)
        self.dismiss(animated: true)
    }
}
