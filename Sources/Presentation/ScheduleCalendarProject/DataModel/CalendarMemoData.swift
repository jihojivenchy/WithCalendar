//
//  MemoDataModel.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/11/08.
//

import Foundation

struct MemoData {
    
    var titleMemo : String
    var color : String
    var date : String
}

struct CalendarMemoData {
    var titleMemo : String
    var labelColor : String
    var startDate : String
    var backGroundColor : String
    var check : String
    var selectedColor : String
}

struct SearchUserData {
    
    var nickName : String
    var email : String
    var uid : String
}

struct ShareRequestData {
    
    var sender : String
    var senderUid : String
    var title : String
    var date : String
    var documnetID : String
}

struct SimpleMemoData {
    
    var memo : String
    var date : String
}


