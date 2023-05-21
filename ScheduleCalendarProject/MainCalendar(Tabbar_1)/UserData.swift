//
//  UserData.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/27.
//

import Foundation

//Equtable을 준수하는 이유는 ShareCalendar 생성 때, 유저 리스트 배열에서 유저가 추가되어 있는지 확인해야 하기 때문.
struct UserData : Equatable {
    var NickName: String
    var email: String
    var userUid: String
    var code: String
}
