//
//  FeedBackDataService.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/19.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct FeedBackDataService {
    let db = Firestore.firestore()
    
    func sendFeedBackMessage(contents: String, completion: @escaping (Result<String, Error>) -> Void) {
        db.collection("FeedBack").addDocument(data: ["contents" : contents]) { error in
            if let e = error {
                completion(.failure(e))
            }else{
                completion(.success(contents))
            }
        }
    }
}
