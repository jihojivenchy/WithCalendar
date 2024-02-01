//
//  KoreaHolidayData.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/11/27.
//

import Foundation

struct JSONResponse : Codable {
    let response : Response
}

struct Response : Codable {
    let body : Body
}

struct Body : Codable {
    let items : Items
}

struct Items : Codable {
    let item : [Item]
}

struct Item : Codable{
    let locdate : Int
    let dateName : String
}

