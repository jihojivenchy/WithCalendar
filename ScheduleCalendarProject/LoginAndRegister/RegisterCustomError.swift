//
//  RegisterCustomError.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/05/08.
//

import Foundation

enum RegisterCustomError : Error {
    case failedRegister(String)               //회원가입 도중 생긴 에러
    case failedSaveUserData(String)           //유저데이터를 저장하는데 생긴 에러
    case failedURLRequest(String)             //공휴일 데이터를 요청하는데 생긴 에러
    case failedSaveHolidayData(String)        //공휴일 데이터를 저장하는데 생긴 에러
}
