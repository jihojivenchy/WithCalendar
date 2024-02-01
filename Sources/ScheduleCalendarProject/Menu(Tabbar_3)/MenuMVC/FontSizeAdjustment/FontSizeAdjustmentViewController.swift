//
//  FontSizeAdjustmentViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/05/21.
//

import UIKit
import SnapKit

final class FontSizeAdjustmentViewController: UIViewController {
    //MARK: - Properties
    final let fontSizeAdjustmentView = FontSizeAdjustmentView()
    final let fontSizeAdjustmentDataModel = FontSizeAdjustmentDataModel()
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupSubViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let fontSize = fontSizeAdjustmentView.slider.value
        UserDefaults.standard.set(fontSize, forKey: "fontSize")
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        view.backgroundColor = .customWhiteAndBlackColor
        
        view.addSubview(fontSizeAdjustmentView)
        fontSizeAdjustmentView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        fontSizeAdjustmentView.testLabel.font = UIFont(name: getFontName(), size: getFontSize())
        fontSizeAdjustmentView.sliderValueLabel.text = "\(getFontSize())"
        
        fontSizeAdjustmentView.slider.value = Float(getFontSize())
        fontSizeAdjustmentView.slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
        fontSizeAdjustmentView.fontMenuTableview.register(OptionTableViewCell.self, forCellReuseIdentifier: OptionTableViewCell.identifier)
        fontSizeAdjustmentView.fontMenuTableview.delegate = self
        fontSizeAdjustmentView.fontMenuTableview.dataSource = self
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationItem.title = "폰트 설정"
        navigationController?.navigationBar.tintColor = .blackAndWhiteColor
    }
    
    //MARK: - SliderMethod
    @objc private func sliderValueChanged(_ sender: UISlider) {
        let fontSize = CGFloat(sender.value)
        fontSizeAdjustmentView.testLabel.font = UIFont(name: getFontName(), size: fontSize)
        fontSizeAdjustmentView.sliderValueLabel.text = String(format: "%.1f", sender.value)
    }
}

//MARK: - Extension
extension FontSizeAdjustmentViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fontSizeAdjustmentDataModel.fontListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OptionTableViewCell.identifier, for: indexPath) as! OptionTableViewCell
        
        let fontTitle = fontSizeAdjustmentDataModel.fontListArray[indexPath.row]
        let realFontName = fontSizeAdjustmentDataModel.realFontNameArray[indexPath.row]
        
        cell.titleLabel.text = fontTitle
        cell.titleLabel.font = UIFont(name: realFontName, size: 16)
        cell.tintColor = .signatureColor
        
        if realFontName == getFontName() {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.whiteAndCustomBlackColor
        cell.selectedBackgroundView = backgroundView
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //cell을 클릭했을 때 애니메이션 구현
        triggerHapticFeedback() //유저에게 리액션을 주기 위한 미세한 진동음.
        
        changeFont(at: indexPath.row)
        tableView.reloadData()
    }
}

//MARK: - Notification Request 정보들을 가져오고, 유저가 편하게 볼 수 있도록 가공.
extension FontSizeAdjustmentViewController {
    private func changeFont(at indexRow: Int) {
        let fontName = fontSizeAdjustmentDataModel.realFontNameArray[indexRow]
        UserDefaults.standard.set(fontName, forKey: "fontName")
        fontSizeAdjustmentView.testLabel.font = UIFont(name: getFontName(), size: getFontSize())
    }
    
    private func getFontName() -> String {
        return UserDefaults.standard.string(forKey: "fontName") ?? "Pretendard-SemiBold"
    }
    
    private func getFontSize() -> CGFloat {
        return CGFloat(UserDefaults.standard.float(forKey: "fontSize"))
    }
    
}
