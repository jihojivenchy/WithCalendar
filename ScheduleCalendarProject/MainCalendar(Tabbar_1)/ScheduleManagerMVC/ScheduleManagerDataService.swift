//
//  ScheduleDataService.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/05/16.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct ScheduleManagerDataService {
    
    func deleteCalendarData(dataDocumentID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        
        guard let collectionID = UserDefaults.standard.string(forKey: "CalendarColletionID"),
              let documentID = UserDefaults.standard.string(forKey: "CalendarDocumentID") else{ return }
        
        
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
