//
//  NetworkError.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 3/7/24.
//

import Foundation

enum NetworkError: Error {
    case authenticationRequired
    case unknown(_ description: String?)
}
