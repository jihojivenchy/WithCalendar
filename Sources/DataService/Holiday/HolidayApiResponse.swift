//
//  HolidayApiResponse.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/27.
//

import Foundation

struct HolidayAPIResponse: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let body: Body
}

// MARK: - Body
struct Body: Codable {
    let items: Items
}

// MARK: - Items
struct Items: Codable {
    let item: [Item]
}

// MARK: - Item
struct Item: Codable {
    let dateName: String
    let locdate: Int
}
