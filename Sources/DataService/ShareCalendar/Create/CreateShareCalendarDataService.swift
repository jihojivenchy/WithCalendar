//
//  ShareCalendarDataService.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/05/06.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct CreateShareCalendarDataService {
    //MARK: - Properties
    let db = Firestore.firestore()
    
    //MARK: - CreateShareCalendarMethod
    
    //본인의 데이터를 가져오는 메서드.
    func fetchUserDataFromFirestore(completion: @escaping (Result<UserData, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else{return}
        
        db.collection("Users").document(user.uid).getDocument { qs, error in
            if let e = error {
                completion(.failure(e))
            }else{
                guard let data = qs?.data() else {return} //해당 도큐먼트 안에 데이터가 있는지 확인
                
                guard let emailData = data["email"] as? String, //유저 이메일
                      let nameData = data["NickName"] as? String, //유저 닉네임
                      let codeData = data["code"] as? String else{return}
                
                let findData = UserData(NickName: nameData, email: emailData, userUid: user.uid, code: codeData)
                
                completion(.success(findData))
            }
        }
        
    }
    
    //공유캘린더를 만드는 메서드.
    //1. 공유캘린더를 만드는 방장의 uid를 따서 공유캘린더를 만들어줌.
    //2. 만든 공유캘린더의 documentID를 가져와서 공휴일 데이터를 저장해줌.
    //3. 만든 공유캘린더의 정보를 모든 참여자의 공유캘린더 정보에 저장해줌.
    //이 모든 작업이 완료되었을 때, 컴플리션핸들러가 실행된다.
    func createShareCalendar(userDataArray: [UserData], calendarTitle: String, completion: @escaping (Result<Void, CreateShareCalendarError>) -> Void) {
        guard let user = Auth.auth().currentUser else{return}
        let collectionID = "\(user.uid).공유달력"
        
        db.collection(collectionID).addDocument(data: [:]).getDocument { qs, error in
            if let e = error {
                completion(.failure(.failedCreateShareCalendar(e.localizedDescription)))
                
            }else{
                guard let documentID = qs?.documentID else{return}
                let group = DispatchGroup()
                
                //공유달력안에 공휴일 데이터 넣어주기.
                group.enter()
                self.setHolidaysToShareCalendar(collectionID: collectionID, documentID: documentID) { result in
                    if case .failure(let err) = result {
                        completion(.failure(err))
                    }
                    group.leave()
                }
                
                //멤버들에게 공유달력 정보 데이터 넣어주기.
                group.enter()
                self.setShareCalendarDataToListMember(userDataArray: userDataArray, documentID: documentID, calendarTitle: calendarTitle) { result in
                    if case .failure(let err) = result {
                        completion(.failure(err))
                    }
                    group.leave()
                }
                
                group.notify(queue: .main) {
                    completion(.success(()))
                }
            }
        }
    }
    
    //만든 공유캘린더에 공휴일 데이터를 가져와서 저장.
    func setHolidaysToShareCalendar(collectionID: String, documentID: String, completion: @escaping (Result<Void, CreateShareCalendarError>) -> Void) {
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
                    saveHolidaysToShareCalendar(collectionID: collectionID, documentID: documentID, holidayData: holiday) { result in
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
                completion(.failure(err))
            }
        }
    }
    
    //공유캘린더에 공휴일 데이터 저장.
    func saveHolidaysToShareCalendar(collectionID: String, documentID: String, holidayData: HolidayData, completion: @escaping (Result<Void, CreateShareCalendarError>) -> Void) {
        
        let calendarData = CalendarData(titleText: holidayData.holidayTitle,
                                        startDate: holidayData.holidayDate, endDate: holidayData.holidayDate,
                                        queryDate: holidayData.queryDate,
                                        detailMemo: "",
                                        count: 0, controlIndex: 0,
                                        selectedColor: "#CC3636FF", labelColor: "#CC3636FF",
                                        backGrondColor: "#00000000", notification: "")
        
        do {
            try db.collection(collectionID).document(documentID).collection("달력내용").addDocument(from: calendarData, completion: { error in
                
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
    
    //멤버들의 공유캘린더 정보에 새로 생성한 공유캘린더 데이터를 저장.
    func setShareCalendarDataToListMember(userDataArray: [UserData], documentID: String, calendarTitle: String, completion: @escaping (Result<Void, CreateShareCalendarError>) -> Void) {
        
        //1. 캘린더 이름
        //2. 캘린더 생성시각
        //3. 캘린더 참가자 명단
        //4. 캘린더 참가자 UID
        //5. 생성된 공유달력 컬렉션ID
        let data = ShareCalendarData(calendarName: calendarTitle,
                                     date: Date().timeIntervalSince1970,
                                     member: setMemberNameUidArray(userDataArray: userDataArray, returnName: true),
                                     memberUid: setMemberNameUidArray(userDataArray: userDataArray, returnName: false),
                                     ownerUid: "\(userDataArray[0].userUid).공유달력")
    
        let group = DispatchGroup()
        
        for userData in userDataArray { //참가자 리스트에서 한 명씩 뽑아 저장함.
            group.enter()
            
            let collectionID = "\(userData.userUid).공유" //참가자의 공유캘린더 데이터 컬렉션 아이디.
            
            //저장작업.
            saveShareCaledarDataToListMember(collectionID: collectionID, documentID: documentID, data: data) { result in
                if case .failure(let err) = result {
                    completion(.failure(err))
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(.success(()))
        }
    }
    
    //멤버들의 공유캘린더 정보에 공유캘린더 데이터를 저장.
    func saveShareCaledarDataToListMember(collectionID: String, documentID: String, data: ShareCalendarData, completion: @escaping (Result<Void, CreateShareCalendarError>) -> Void) {
        
        do {
            try db.collection(collectionID).document(documentID).setData(from: data, completion: { error in
                if let e = error {
                    completion(.failure(.failedSaveShareCalendarData(e.localizedDescription)))
                }else{
                    completion(.success(()))
                }
            })
            
        }catch let error {
            completion(.failure(.failedSaveShareCalendarData(error.localizedDescription)))
        }
        
    }
    
    //멤버들의 이름이나 uid를 따로 배열로 만들어줌. returnName이 true면 이름 배열을, 아니라면 uid 배열을 만들어줌.
    func setMemberNameUidArray(userDataArray: [UserData], returnName: Bool) -> [String] {
        var array : [String] = []
        
        for i in userDataArray {
            
            if returnName {
                array.append(i.NickName)
            }else{
                array.append(i.userUid)
            }
        }
        
        return array
    }
    
    
}

