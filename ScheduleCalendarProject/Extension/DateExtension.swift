//
//  DateExtension.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/20.
//

import Foundation

extension Date {
    func convertDateToString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    func calculateMaximumDate() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        
        guard let day = components.day else{return Date()} //현재 날짜 부분에서 day 부분만 떼어오기.
        
        let lastDay = calendar.range(of: .day, in: .month, for: self)?.count ?? Int() //현재 날짜에 해당하는 달의 마지막 날이 몇일인지
        
        let daysToAdd = lastDay - day //마지막 날에서 현재 day부분을 빼줌.
        
        let maximumDate = calendar.date(byAdding: .day, value: daysToAdd, to: self) //현재 날짜에서 차감한 값을 더해준 값이 maximumDate가 된다.
        
        return maximumDate ?? Date()
    }
    
    func calculateMaximumTimeDate() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        
        guard let day = components.day else{return Date()} //현재 날짜 부분에서 day 부분만 떼어오기.
        
        let lastDay = calendar.range(of: .day, in: .month, for: self)?.count ?? Int() //현재 날짜에 해당하는 달의 마지막 날이 몇일인지
        let daysToAdd = lastDay - day //마지막 날에서 현재 day부분을 빼줌.
        
        let maxDateWithAddedDays = calendar.date(byAdding: .day, value: daysToAdd, to: self) ?? Date() //현재 날짜에서 차감한 값을 더해준 값이 maxDateWithAddedDays가 된다.
        
        var maximumComponents = calendar.dateComponents([.year, .month, .day], from: maxDateWithAddedDays)
        
        maximumComponents.hour = 23
        maximumComponents.minute = 59
        
        let maximumDate = calendar.date(from: maximumComponents) ?? self
        
        return maximumDate
    }
}
