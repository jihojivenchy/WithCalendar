//
//  CalendarCategoryDataService.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/05/08.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct CalendarCategoryDataService {
    //MARK: - Properties
    let db = Firestore.firestore()
    
    //MARK: - Method
    func getShareCalendarDataForCategory(completion: @escaping (Result<[ShareCalendarCategoryData], Error>) -> Void) {
        guard let user = Auth.auth().currentUser else{return}
        let collectionID = "\(user.uid).공유"
        
        db.collection(collectionID).order(by: "date", descending: false).addSnapshotListener { qs, error in
            if let e = error {
                completion(.failure(e))
                
            }else{
                guard let snapShotDocuments = qs?.documents else{return}
                var shareCalendarCategoryArray : [ShareCalendarCategoryData] = []
                
                for doc in snapShotDocuments {
                    
                    let data = doc.data()
                    
                    guard let calendarNameData = data["calendarName"] as? String,
                          let dateData = data["date"] as? Double,
                          let memberNameArray = data["member"] as? [String],
                          let memberUidArray = data["memberUid"] as? [String],
                          let ownerUidData = data["ownerUid"] as? String else{return}
                    
                    
                    let findData = ShareCalendarCategoryData(calendarName: calendarNameData, date: dateData, memberNameArray: memberNameArray, memberUidArray: memberUidArray, ownerUid: ownerUidData, documentID: doc.documentID)
                    
                    shareCalendarCategoryArray.append(findData)
                }
                
                completion(.success(shareCalendarCategoryArray))
            }
        }
    }
    
    //개인 캘린더로 전환하기
    func changeToPrivateCalendar() {
        guard let user = Auth.auth().currentUser else{return}
        
        UserDefaults.standard.set(user.uid, forKey: "CalendarColletionID")
        UserDefaults.standard.set("With Calendar", forKey: "CalendarDocumentID")
        UserDefaults.standard.set("With Calendar", forKey: "CurrentSelectedCalendarName")
        
    }
    
    //공유 캘린더로 전환하기
    func changeToShareCalendar(collectionID: String, documentID: String, calendarName: String) {
        UserDefaults.standard.set(collectionID, forKey: "CalendarColletionID")
        UserDefaults.standard.set(documentID, forKey: "CalendarDocumentID")
        UserDefaults.standard.set(calendarName, forKey: "CurrentSelectedCalendarName")
    }
}
