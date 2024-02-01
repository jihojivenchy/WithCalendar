//
//  SetNotificationDataModel.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/05/11.
//

import Foundation


struct SetNotificationDataModel {
    //MARK: - Properties
    var notificationOptionArray : [String] = []
    
    var controlMode : EventDateAndTimeOption = .date
    var selectedOption = String()      //유저가 선택한 옵션.
    var selectedColor = String()       //유저가 선택한 컬러.
    var startDate = String()           //유저가 설정한 시작날짜.
    
    var optionIndex = Int()            //유저가 선택한 옵션의 인덱스
    
    //MARK: - Methods
    
    //시간설정 모드나 하루종일 모드로 변경했을 때, 이벤트의 노티피케이션 옵션을 모드에 맞게 변경.
    func changeOptionTitleArray() -> [String] {
        switch controlMode {
            
        case .time:
            return ["시작", "10분 전", "30분 전", "1시간 전", "설정", "알림 없음"]
            
        case .date:
            return ["당일", "1일 전", "3일 전", "1주일 전", "설정", "알림 없음"]
        }
    }
    
    //유저가 선택한 옵션이 몇 번째 index인지 찾아줌. checkmark를 위해.
    func setSelectedOptionIndex() -> Int {
        print(selectedOption)
        
        switch selectedOption {
           
        case "당일", "시작":
            return 0
            
        case "1일 전", "10분 전":
            return 1
            
        case "3일 전", "30분 전":
            return 2
            
        case "1주일 전", "1시간 전":
            return 3
            
        case "알림 없음":
            return 5
            
        default:
            return 4
        }
    }
}

