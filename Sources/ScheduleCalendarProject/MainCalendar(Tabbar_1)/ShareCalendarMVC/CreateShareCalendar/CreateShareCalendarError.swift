//
//  CustomError.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/05/04.
//

import Foundation

enum CreateShareCalendarError : Error {
    case failedCreateShareCalendar(String)     //공유달력 자체를 생성하는데 생긴 에러
    case failedURLRequest(String)              //URLSession을 통해 리퀘스트한 작업 도중 생긴 에러
    case failedSaveShareCalendarData(String)   //공유달력에 대한 정보를 저장하는데 생긴 에러
    case invalidateDataError                   //요청한 데이터가 없음.
    case failedSaveHolidayData(String)         //공유달력에 공휴일 데이터를 저장하는 작업에서 생긴 에러
}
