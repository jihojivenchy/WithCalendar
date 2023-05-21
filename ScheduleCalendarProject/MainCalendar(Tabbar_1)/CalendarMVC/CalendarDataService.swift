//
//  CalendarDataService.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/05/14.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct CalendarDataService {
    
    func getCalendarMemoData(queryData: String, completion: @escaping (Result<[CustomCalendarData], Error>) -> Void) {guard let user = Auth.auth().currentUser else{return}
        let db = Firestore.firestore()
        let collectionID = setCollectionID(uid: user.uid)
        let documentID = setDocumentID()
        
        let ref = db.collection(collectionID).document(documentID).collection("달력내용")
        
        ref.whereField("queryDate", isEqualTo: queryData)  //해당 년, 월에 일치하는 데이터가져오기.
            .order(by: "startDate", descending: false)     //가장 빠른 일자의 데이터부터
            .order(by: "count", descending: true)          //가장 장기스케줄 데이터부터 가져오기.
            .addSnapshotListener { qs, error in
                
            if let e = error {
                completion(.failure(e))
                
            }else{
                var findDataArray : [CustomCalendarData] = []
                
                guard let snapshotDocuments = qs?.documents else{ return }
                
                for doc in snapshotDocuments{
                    
                    guard let findData = dataFromDocument(doc) else {return}
                    findDataArray.append(findData)
                }
                
                completion(.success(findDataArray))
            }
        }
    }
    
    //CollectionID 지정.
    private func setCollectionID(uid: String) -> String {
        //저장된 컬렉션ID가 존재한다면 그대로, 존재하지 않는다면 유저의 기본 캘린더 컬렉션ID로.
        if let collectionID = UserDefaults.standard.string(forKey: "CalendarColletionID") {
            return collectionID
        }else{
            return uid //기본적인 유저의 캘린더 CollectionID
        }
    }
    
    //DocumentID 지정.
    private func setDocumentID() -> String {
        //저장된 DocumentID가 존재한다면 그대로, 존재하지 않는다면 유저의 기본 캘린더 DocumentID로.
        if let documentID = UserDefaults.standard.string(forKey: "CalendarDocumentID") {
            return documentID
        }else{
            return "With Calendar" //기본적인 유저의 캘린더 DocumentID
        }
    }
    
    //도큐먼트에 있는 데이터 가져오기.
    private func dataFromDocument(_ doc: QueryDocumentSnapshot) -> CustomCalendarData? {
        let data = doc.data()
        
        guard let titleTextData = data["titleText"] as? String,
              let startDateData = data["startDate"] as? String,
              let endDateData = data["endDate"] as? String,
              let detailMemoData = data["detailMemo"] as? String,
              let selectedColorData = data["selectedColor"] as? String,
              let labelColorData = data["labelColor"] as? String,
              let backgroundColorData = data["backGrondColor"] as? String,
              let notificationData = data["notification"] as? String,
              let countData = data["count"] as? Int,
              let controlIndexData = data["controlIndex"] as? Int else{return nil}
        
        
        let findData = CustomCalendarData(titleText: titleTextData,
                                          startDate: startDateData, endDate: endDateData,
                                          detailMemo: detailMemoData,
                                          count: countData, controlIndex: controlIndexData,
                                          selectedColor: selectedColorData, labelColor: labelColorData,
                                          backGrondColor: backgroundColorData,
                                          notification: notificationData,
                                          documentID: doc.documentID,
                                          sequence: "")
        
        return findData
    }
}
