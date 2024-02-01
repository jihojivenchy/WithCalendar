//
//  AddMemoDataService.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/05/09.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct AddMemoDataService {
    let db = Firestore.firestore()
    
    //메모 데이터 저장.
    func setMemoData(data: MemoData, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else{return}
        
        db.collection("\(user.uid).메모").addDocument(data: ["memo" : data.memo,
                                                           "date" : data.date,
                                                           "fix" : data.fix,
                                                           "fixColor" : data.fixColor]) { error in
            if let e = error {
                completion(.failure(e))
            }else{
                completion(.success(()))
            }
        }
    }
}
