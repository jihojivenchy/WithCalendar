//
//  StringExtension.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import Foundation

extension String {
    func randomString(length : Int) -> String {
        let randomString = (0 ..< length).map { _ in
            self.randomElement()!
        }
        
        return String(randomString)
    }
    
    func convertStringToDate(format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.date(from: self) ?? Date()
    }
    
    //문자열의 끝에서부터 지정한 개수의 문자를 가져옴.
    func getSuffix(_ count: Int) -> String {
        return String(self.suffix(count))
    }
    
    //문자열의 시작부터 지정한 개수의 문자를 가져옴.
    func getPrefix(_ count: Int) -> String {
        return String(self.prefix(count))
    }
    
    //"2023년 05월 12일" 과 같은 데이터에서 "2023", "05", "12" 부분만 떼어내고 리턴해줌.
    func splitDateComponents() -> (year: String, month: String, day: String) {
        let components = self.components(separatedBy: " ")
        
        let year = components[0].replacingOccurrences(of: "년", with: "")
        let month = components[1].replacingOccurrences(of: "월", with: "")
        let day = components[2].replacingOccurrences(of: "일", with: "")
        
        return (year: year, month: month, day: day)
    }
}

