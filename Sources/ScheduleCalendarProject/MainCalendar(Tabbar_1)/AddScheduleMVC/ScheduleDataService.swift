//
//  AddScheduleDataService.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ScheduleDataService {
    let db = Firestore.firestore()
    
    //캘린더데이터 저장하기.
    func saveCalendarDataToFirestore(calendarData: CalendarData, completion: @escaping (Result<Void, Error>) -> Void) {
        let collectionID = setCollectionID()
        let documentID = setDocumentID()
        
        let ref = db.collection(collectionID).document(documentID).collection("달력내용")
        
        do {
            try ref.addDocument(from: calendarData, completion: { error in
                
                if let e = error {
                    completion(.failure(e))
                }else{
                    completion(.success(()))
                }
            })
            
        }catch let error {
            completion(.failure(error))
        }
    }
    
    //유저가 작성한 데이터를 토대로 Firestore에 저장용 캘린더 데이터로 가공해줌.
    func setCalendarData(data: AddScheduleData) -> CalendarData {
        
        let queryDate = String(data.startDate.prefix(9))        //query용 데이터. 해당 달에 맞는 데이터를 가져올 때 사용 "2023년 05월"
        let controlIndex = modeToControlIndex(mode: data.mode)  //하루종일 모드인지 시간설정 모드인지를 숫자로 변형. 0과 1
        let selectedColor = data.color              //라벨이든 뷰든 선택한 컬러.
        
        let scheduleType = checkScheduleType(startDate: data.startDate, endDate: data.endDate) //당일 스케줄인지 장기 스케줄인지.
        
        let count = scheduleType ? 0 : daysBetweenDates(startDate: data.startDate, endDate: data.endDate, mode: data.mode)
        let labelColor = scheduleType ? data.color : "#00000000"
        let backGroundColor = scheduleType ? "#00000000" : data.color
        
        return CalendarData(titleText: data.title,
                            startDate: data.startDate, endDate: data.endDate,
                            queryDate: queryDate,
                            detailMemo: data.memo,
                            count: count,
                            controlIndex: controlIndex,
                            selectedColor: selectedColor,
                            labelColor: labelColor,
                            backGrondColor: backGroundColor,
                            notification: data.option)
    }
    
    //당일 스케줄일 경우 true, 장기 스케줄일 경우 false 리턴
    func checkScheduleType(startDate: String, endDate: String) -> Bool {
        if startDate == endDate {
            return true
        }else{
            return false
        }
    }
    
    //시작날짜와 종료날짜가 다를 때, 두 날짜의 차이가 몇일인지.
    func daysBetweenDates(startDate: String, endDate: String, mode: EventDateAndTimeOption) -> Int {
        var date1 = Date()
        var date2 = Date()
        
        switch mode {
        case .date:
            date1 = startDate.convertStringToDate(format: "yyyy년 MM월 dd일")
            date2 = endDate.convertStringToDate(format: "yyyy년 MM월 dd일")
            
        case .time:
            date1 = startDate.convertStringToDate(format: "yyyy년 MM월 dd일 HH시 mm분")
            date2 = endDate.convertStringToDate(format: "yyyy년 MM월 dd일 HH시 mm분")
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        return abs(components.day ?? 0) //abs란 절대값으로 만들어주는 메서드로 date1과 date2의 차이가 -값이 나와도 절대값으로 양수로 만들어줌
    }
    
    //하루종일 모드면 0, 시간설정 모드면 1
    func modeToControlIndex(mode: EventDateAndTimeOption) -> Int {
        switch mode {
        case .date:
            return 0
            
        case .time:
            return 1
        }
    }
    
    //CollectionID 지정.
    func setCollectionID() -> String {
        guard let user = Auth.auth().currentUser else{return String()}
        
        //저장된 컬렉션ID가 존재한다면 그대로, 존재하지 않는다면 유저의 기본 캘린더 컬렉션ID로.
        if let collectionID = UserDefaults.standard.string(forKey: "CalendarColletionID") {
            return collectionID
        }else{
            return user.uid //기본적인 유저의 캘린더 CollectionID
        }
    }
    
    //DocumentID 지정.
    func setDocumentID() -> String {
        //저장된 DocumentID가 존재한다면 그대로, 존재하지 않는다면 유저의 기본 캘린더 DocumentID로.
        if let documentID = UserDefaults.standard.string(forKey: "CalendarDocumentID") {
            return documentID
        }else{
            return "With Calendar" //기본적인 유저의 캘린더 DocumentID
        }
    }
    
    
    //MARK: - EditSchedule
    
    //캘린더데이터 수정하기.
    func updateCalendarDataToFirestore(dataDocumentID: String, calendarData: CalendarData, completion: @escaping (Result<Void, Error>) -> Void) {
        let collectionID = setCollectionID()
        let documentID = setDocumentID()
        
        let ref = db.collection(collectionID).document(documentID).collection("달력내용").document(dataDocumentID)
        
        do {
            try ref.setData(from: calendarData, completion: { error in
                
                if let e = error {
                    completion(.failure(e))
                }else{
                    completion(.success(()))
                }
            })
            
        }catch let error {
            completion(.failure(error))
        }
    }
    
    
    func deleteCalendarData(dataDocumentID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let collectionID = setCollectionID()
        let documentID = setDocumentID()
        
        let ref = db.collection(collectionID).document(documentID).collection("달력내용").document(dataDocumentID)
        
        ref.delete { error in
            if let e = error {
                completion(.failure(e))
                
            }else{
                completion(.success(()))
            }
        }
        
    }
}
