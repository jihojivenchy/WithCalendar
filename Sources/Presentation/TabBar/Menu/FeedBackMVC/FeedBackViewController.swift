//
//  FeedBackViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit

final class FeedBackViewController: UIViewController {
    //MARK: - Properties
    final let feedBackDataService = FeedBackDataService()
    final let feedBackView = FeedBackView() //View
    
    private let textViewHolder = "더 나은 서비스를 위한 글을 자유롭게 작성해주세요."
    private let loadingView = WCLoadingView()
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        setupNavigationBar()
        
    }
    
    //MARK: - ViewMethod
    private func addSubViews() {
        view.backgroundColor = .customWhiteAndBlackColor
        
        view.addSubview(feedBackView)
        feedBackView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        feedBackView.feedBackTextView.text = textViewHolder
        feedBackView.feedBackTextView.delegate = self
        
        feedBackView.sendButton.addTarget(self, action: #selector(sendButtonPressed(_:)), for: .touchUpInside)
        feedBackView.goToCenterButton.addTarget(self, action: #selector(goCenterButtonPressed(_:)), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationItem.title = "피드백"
        navigationController?.navigationBar.tintColor = .blackAndWhiteColor
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){ //화면 터치 시 키보드내려감
        self.view.endEditing(true)
        
    }
    
    //MARK: - ButtonMethod
    
    @objc private func sendButtonPressed(_ sender : UIButton){
        self.view.endEditing(true)
        
        guard let text = feedBackView.feedBackTextView.text else{return}
        
        if text == textViewHolder {
            showAlert(title: "내용 작성", message: "내용을 작성해주세요")
            
        }else{
            handleFeedBack(contents: text)
        }
    }
    
    @objc private func goCenterButtonPressed(_ sender : UIButton){
        let centerURL = "https://open.kakao.com/o/sSz7qoRe"
        let kakaoTalkURL = NSURL(string: centerURL)

        if UIApplication.shared.canOpenURL(kakaoTalkURL! as URL){
            UIApplication.shared.open(kakaoTalkURL! as URL)
        }else{
            showAlert(title: "접속 오류", message: "현재 접속이 불가능합니다.")
        }
    }
    
}

//MARK: - Extension
extension FeedBackViewController : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewHolder {
            textView.text = nil
            textView.textColor = .blackAndWhiteColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewHolder
            textView.textColor = .lightGray
        }
    }
}

extension FeedBackViewController {
    private func handleFeedBack(contents: String) {
        feedBackDataService.sendFeedBackMessage(contents: contents) { [weak self] result in
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(_):
                    self?.loadingView.stopLoading()
                    self?.showAlert(title: "제출완료", message: "감사합니다.")
                    self?.feedBackView.feedBackTextView.text = self?.textViewHolder
                    self?.feedBackView.feedBackTextView.textColor = .lightGray
                    
                case .failure(let err):
                    print("Error 피드백 전송 실패   : \(err.localizedDescription)")
                    self?.loadingView.stopLoading()
                    self?.showAlert(title: "전송 실패", message: "")
                    
                }
            }
        }
    }
}
