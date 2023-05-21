//
//  CalendarData.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/05/08.
//

import Foundation

struct CalendarData : Codable {
    var titleText : String
    var startDate : String
    var endDate : String
    var queryDate : String
    var detailMemo : String
    var count : Int
    var controlIndex : Int
    var selectedColor : String
    var labelColor : String
    var backGrondColor : String //backGroundColor... 초기에 데이터 모델 만들 때 오타만들었음..
    var notification : String
}
