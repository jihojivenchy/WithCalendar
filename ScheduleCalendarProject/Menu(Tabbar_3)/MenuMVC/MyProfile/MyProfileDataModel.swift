//
//  MyProfileDataModel.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct MyProfileDataModel {
    var userName : String
    var userEmail : String
    var userCode : String
    var userUID : String
    
    let code = "abcdefghijklmnopqrstuvwxyz0123456789" //유저의 고유 랜덤코드를 뽑기 위한 소스.
}
