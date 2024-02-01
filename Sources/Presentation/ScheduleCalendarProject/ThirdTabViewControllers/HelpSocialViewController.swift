//
//  HelpSocialViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/12/28.
//

import UIKit
import SnapKit

final class HelpSocialViewController: UIViewController {
//MARK: - Properties
    private lazy var helpCollectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        let colView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        colView.delegate = self
        colView.dataSource = self
        colView.backgroundColor = .clear
        colView.isPagingEnabled = true
        
        return colView
    }()
    
    
    private lazy var pageControl : UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = imageArray.count
        pc.currentPage = 0
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = .customSignatureColor
        
        return pc
    }()

    private let imageArray = [UIImage(named: "helpImage1"), UIImage(named: "helpImage2"), UIImage(named: "helpImage3"), UIImage(named: "helpImage4"), UIImage(named: "helpImage5")]
    
    
//MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .black
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        helpCollectionView.register(HelpSocialCollectionViewCell.self, forCellWithReuseIdentifier: HelpSocialCollectionViewCell.cellIdentifier)
        helpCollectionView.showsHorizontalScrollIndicator = false
    }
    
    
    //MARK: - ViewMethod
    private func addSubViews() {
        view.backgroundColor = .displayModeColor1
        
        view.addSubview(helpCollectionView)
        helpCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.left.right.equalToSuperview()
        }
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(helpCollectionView.snp_bottomMargin).offset(20)
            make.centerX.equalTo(helpCollectionView)
            make.width.equalTo(200)
            make.height.equalTo(10)
        }
        
    }
    
}

//MARK: - Extension
extension HelpSocialViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HelpSocialCollectionViewCell.cellIdentifier, for: indexPath) as! HelpSocialCollectionViewCell
        
        cell.helpImageView.image = imageArray[indexPath.row]
        cell.helpImageView.backgroundColor = .clear
        
        return cell
    }
}

extension HelpSocialViewController : UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let page = Int(targetContentOffset.pointee.x / helpCollectionView.frame.width)
        self.pageControl.currentPage = page
        
    }
}

extension HelpSocialViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    //section 사이의 공간을 제거
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        
        return size
    }
}

