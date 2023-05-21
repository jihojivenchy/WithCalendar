//
//  ShareCalendarDataModel.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import Foundation

struct ShareCalendarData : Codable {
    let calendarName : String
    let date : Double
    let member : [String]
    let memberUid : [String]
    let ownerUid : String
}

struct ShareCalendarCategoryData {
    var calendarName : String
    let date : Double
    var memberNameArray : [String]
    var memberUidArray : [String]
    var ownerUid : String
    let documentID : String
}

struct ShareCalendarDataModel {
    //MARK: - SearchUser에서 사용.
    //공유 캘린더에 참여할 대상을 검색할 때, 사용.
    var userDataArray : [UserData] = []
    
    //MARK: - CalendarCategory에서 사용.
    //나의 공유 캘린더 정보 리스트.
    var shareCalendarCategoryArray : [ShareCalendarCategoryData] = []
    
    //MARK: - EditCalendar에서 사용.
    //현재 캘린더의 주인이 나인지 아닌지 판단.
    var ownerCheckType : Bool = false
    
    //제외시킨 유저의 데이터를 넣기 위해.
    var removeUserList : [String] = []
}

