//
//  FontSizeAdjustmentView.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/05/21.
//

import UIKit
import SnapKit

final class FontSizeAdjustmentView: UIView {
    //MARK: - Properties
    
    final let testLabel = UILabel()
    final let sliderValueLabel = UILabel()
    final let slider = UISlider()
    final let fontMenuTableview = UITableView(frame: .zero, style: .insetGrouped)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        self.backgroundColor = .clear
        
        addSubview(testLabel)
        testLabel.text = "With Calendar"
        testLabel.textColor = .blackAndWhiteColor!
        testLabel.backgroundColor = .whiteAndCustomBlackColor
        testLabel.textAlignment = .center
        testLabel.clipsToBounds = true
        testLabel.layer.cornerRadius = 7
        testLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(30)
            make.height.equalTo(60)
        }
        
        
        addSubview(sliderValueLabel)
        sliderValueLabel.lineBreakMode = .byCharWrapping
        sliderValueLabel.configure(textColor: .blackAndWhiteColor!, backgroundColor: .clear, fontSize: 13, alignment: .center)
        sliderValueLabel.snp.makeConstraints { make in
            make.top.equalTo(testLabel.snp_bottomMargin).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(15)
        }
        
        let height = UIScreen.main.bounds.size.height
        
        addSubview(slider)
        slider.minimumValue = 8
        slider.maximumValue = height > 850 ? 17 : 14
        slider.tintColor = .signatureColor
        slider.snp.makeConstraints { make in
            make.top.equalTo(sliderValueLabel.snp_bottomMargin).offset(50)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(30)
        }
        
        addSubview(fontMenuTableview)
        fontMenuTableview.rowHeight = 75
        fontMenuTableview.backgroundColor = .clear
        fontMenuTableview.separatorStyle = .none
        fontMenuTableview.showsVerticalScrollIndicator = false
        fontMenuTableview.snp.makeConstraints { make in
            make.top.equalTo(slider.snp_bottomMargin).offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }

    }
}
