//
//  HolidayAPI.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/05/04.
//

import Foundation

struct HolidayData {
    let holidayTitle : String
    let holidayDate : String
    let queryDate : String
}

//공휴일 데이터를 가져옴.
struct HolidayAPI {
    func fetchHolidayData(years: [String], completion: @escaping (Result<[HolidayData], CreateShareCalendarError>) -> Void) {
        let group = DispatchGroup() //모든 작업의 종료시간을 추적하기 위해서.
        var allHolidays: [HolidayData] = []
        
        for year in years {
            group.enter()
            
            guard let url = URL(string: "https://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/getRestDeInfo?solYear=\(year)&ServiceKey=\(APIKeys.holidayAPIKey)") else{
                
                completion(.failure(.failedURLRequest("URL 오류")))
                return
            }
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, _, error in
                
                if let e = error {
                    completion(.failure(.failedURLRequest(e.localizedDescription)))
                    
                }else{
                    guard let safeData = data else{
                        completion(.failure(.invalidateDataError))
                        return
                    }
                    
                    let holidays = self.parseJSON(data: safeData)
                    allHolidays.append(contentsOf: holidays)
                    
                    group.leave()
                }
            }
            
            task.resume()
        }
        
        //그룹화한 비동기 작업들이 모두 완료되면 알림을 받아와서 클로저 내부를 실행. 이 때 매개변수 queue는 클로저 내부 실행문이 어떤 큐에서 실행되어야 하는지를 결정.
        //completion으로 실행되는 작업이 firestore에 저장하는 비동기작업인데 메인 큐에서 작업을 돌리는게 문제가 생기지는 않는지? 이것은 문제가 생기지 않음. 이유는 firestore의 데이터 저장 작업은 메인스레드에서 비동기식으로 작업을 수행하기 때문에. UI관련 문제가 발생하지 않는다.
        group.notify(queue: .main) {
            completion(.success(allHolidays))
        }
    }
    
    //JSON 데이터를 디코딩하고, 내가 원하는 데이터로 가공하여 리턴해줌.
    private func parseJSON(data: Data) -> [HolidayData] {
        let decoder = JSONDecoder()
        var holidays: [HolidayData] = []
        
        do {
            let decodedData = try decoder.decode(HolidayAPIResponse.self, from: data)
            
            for data in decodedData.response.body.items.item {
                
                let stringDate = String(data.locdate) //날짜 정보를 String 타입으로 변경.
                
                //1. 공휴일 String 타입의 데이터를 Date 타입으로 변경.
                let convertHolidayDate = stringDate.convertStringToDate(format: "yyyyMMdd")
                
                //2. 공휴일 Date 타입을 원하는 String 타입으로 다시 변경.
                let resultDate = convertHolidayDate.convertDateToString(format: "yyyy년 MM월 dd일")
                
                //3. 변경한 공휴일 String 타입을 query버전으로도 변경.
                let queryDate = String(resultDate.prefix(9)) //9자리 글자까지만 가져오기. "2023년 05월"
                
                let holidayData = HolidayData(holidayTitle: data.dateName, holidayDate: resultDate, queryDate: queryDate)
                
                holidays.append(holidayData)
            }
        }catch {
            print("Error decoding")
        }
        
        return holidays
    }
}
