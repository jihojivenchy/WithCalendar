//
//  RegisterDataService.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/05/08.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct RegisterDataService {
    let db = Firestore.firestore()
    
    //파이어베이스 회원가입
    func firebaseRegister(data: RegisterUserData, completion: @escaping (Result<String, RegisterCustomError>) -> Void) {
        
        Auth.auth().createUser(withEmail: data.userEmail, password: data.userPW) { result, error in
            if let e = error {
                completion(.failure(.failedRegister(e.localizedDescription)))
                
            }else{
                guard let userUID = result?.user.uid else{return}
                let group = DispatchGroup()
                
                //유저데이터 저장하기.
                group.enter()
                saveUserData(userUID: userUID, data: data) { result in
                    if case .failure(let err) = result {
                        completion(.failure(err))
                    }
                    group.leave()
                }
                
                //공휴일 데이터를 기본 캘린더에 넣어주기.
                group.enter()
                fetchHolidayDataAndSaveCalendar(userUID: userUID) { result in
                    if case .failure(let err) = result {
                        completion(.failure(err))
                    }
                    
                    group.leave()
                }
                
                group.notify(queue: .main) {
                    completion(.success(userUID)) //회원가입에 성공한 유저의UID를 보내줌.
                }
            }
        }
    }
    
    //유저의 데이터를 저장.
    func saveUserData(userUID: String, data: RegisterUserData, completion: @escaping (Result<Void, RegisterCustomError>) -> Void) {
        
        self.db.collection("Users").document(userUID).setData(["NickName" : data.userName,
                                                               "code" : data.userCode,
                                                               "email" : data.userEmail,
                                                               "userUid" : userUID]) { error in
            if let e = error {
                completion(.failure(.failedSaveUserData(e.localizedDescription)))
            }else{
                completion(.success(()))
            }
        }
    }
    
    //공휴일 데이터를 가져와서. 회원의 기본 캘린더에 넣어주기.
    func fetchHolidayDataAndSaveCalendar(userUID: String, completion: @escaping (Result<Void, RegisterCustomError>) -> Void) {
        let holidayAPI = HolidayAPI()
        let years = ["2023", "2024"]
        
        //공휴일 데이터를 가져오는데 성공하면 캘린더에 데이터들을 저장.
        //공휴일 데이터를 가져오는데 실패하면 Error를 리턴.
        holidayAPI.fetchHolidayData(years: years) { result in
            switch result {
                
            case .success(let holidayDataArray): //공휴일데이터를 가져오는데 성공했을 경우
                let group = DispatchGroup() //공휴일데이터 작업 반복문의 끝을 추적하기 위해서.
                
                for holiday in holidayDataArray { //공휴일 데이터를 하나씩 가공하여 캘린더에 넣어주기.
                    group.enter()
                    
                    //캘린더에 데이터 저장.
                    saveHolidaysToWithCalendar(userUID: userUID, holidayData: holiday) { result in
                        if case .failure(let err) = result {
                            completion(.failure(err))
                        }
                        
                        group.leave() //작업 완료.
                    }
                }
                
                group.notify(queue: .main) {
                    completion(.success(()))
                }
                
            case .failure(let err): //공휴일데이터를 가져오는데 실패했을 경우
                completion(.failure(.failedURLRequest(err.localizedDescription)))
            }
        }
    }
    
    //받아온 공휴일 데이터를 Firestore에 저장할 캘린더 데이터로 가공 후 데이터 저장.
    func saveHolidaysToWithCalendar(userUID: String, holidayData: HolidayData, completion: @escaping (Result<Void, RegisterCustomError>) -> Void) {
        let calendarData = CalendarData(titleText: holidayData.holidayTitle,
                                        startDate: holidayData.holidayDate, endDate: holidayData.holidayDate,
                                        queryDate: holidayData.queryDate,
                                        detailMemo: "",
                                        count: 0, controlIndex: 0,
                                        selectedColor: "#CC3636FF", labelColor: "#CC3636FF",
                                        backGrondColor: "#00000000", notification: "")
        
        do {
            try db.collection(userUID).document("With Calendar").collection("달력내용").addDocument(from: calendarData, completion: { error in
                
                if let e = error {
                    completion(.failure(.failedSaveHolidayData(e.localizedDescription)))
                }else{
                    completion(.success(()))
                }
            })
            
        }catch let error {
            completion(.failure(.failedSaveHolidayData(error.localizedDescription)))
        }
    }
    
}
