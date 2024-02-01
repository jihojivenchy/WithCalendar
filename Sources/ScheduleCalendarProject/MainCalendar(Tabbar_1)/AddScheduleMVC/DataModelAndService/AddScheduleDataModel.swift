//
//  AddScheduleDataModel.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import Foundation

struct AddScheduleData {
    var title : String
    var startDate : String
    var endDate : String
    var mode : EventDateAndTimeOption
    var color : String
    var option : String
    var memo : String
}

struct AddScheduleDataModel {
    //MARK: - Contents
    var eventTitle = String() //유저의 이벤트 제목.
    var selectedColor = "#00925BFF" //유저의 이벤트 컬러.
    
    var controlMode : EventDateAndTimeOption = .date //하루종일모드인지 시간설정모드인지.
    
    //AddSchedule에 관련된 데이터들로 유저가 일정을 등록할 때 옵션들을 나타낸다.
    let actionImageArray : [String] = ["clock", "clock", "alarm", "pencil.tip", "pencil"]
    let titleArray : [String] = ["시작", "종료", "알림", "컬러", "메모"]
    var subTitleArray : [String] = ["", "", "알림 없음", "", ""]
    
    
    //MARK: - Methods
    
    //시간설정 모드나 하루종일 모드로 변경했을 때, 이벤트의 옵션 정보를 모드에 맞게 변경.
    mutating func changeSubTitleArray() {
        switch controlMode {
            
        case .date:
            subTitleArray[0] = subTitleArray[0].getPrefix(13) //"2023년 05월 01일" 까지만 가져옴.
            subTitleArray[1] = subTitleArray[1].getPrefix(13) //"2023년 05월 01일" 까지만 가져옴.
            subTitleArray[2] = "알림 없음"
            
        case .time:
            subTitleArray[0] = "\(subTitleArray[0]) 00시 00분"
            subTitleArray[1] = "\(subTitleArray[1]) 00시 00분"
            subTitleArray[2] = "알림 없음"
        }
    }
    
    
    //유저가 작성한 모든 데이터를 하나로 모음.
    func setAddScheduleData() -> AddScheduleData {
        return AddScheduleData(title: eventTitle,
                               startDate: subTitleArray[0], endDate: subTitleArray[1],
                               mode: controlMode,
                               color: selectedColor,
                               option: subTitleArray[2],
                               memo: subTitleArray[4])
    }
}
