//
//  MemoDataService.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/05/09.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct MemoDataService {
    let db = Firestore.firestore()
    
    //메모 데이터 가져오기.
    func getUserMemoData(completion: @escaping (Result<([MemoData], [MemoData]), Error>) -> Void) {
        guard let user = Auth.auth().currentUser else{
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "로그인 필요"]) //에러 생성.
            completion(.failure(error))
            return
        }
        
        db.collection("\(user.uid).메모").order(by: "date", descending: true).addSnapshotListener{ qs, error in
            if let e = error {
                completion(.failure(e))
                
            }else{
                var unFixMemoDataArray : [MemoData] = []
                var fixMemoDataArray : [MemoData] = []
                
                guard let snapshotDocuments = qs?.documents else{return}
                
                for doc in snapshotDocuments {
                    let data = doc.data()
                    
                    guard let memoData = data["memo"] as? String,
                          let dateData = data["date"] as? String,
                          let fixData = data["fix"] as? Int,
                          let fixColorData = data["fixColor"] as? String else{return}
                    
                    
                    let findData = MemoData(memo: memoData, date: dateData, fix: fixData, fixColor: fixColorData, documentID: doc.documentID)
                    
                    //만약 클립을 설정한 메모라면 fixMemoArray로 추가하고, 클립을 설정하지 않았다면 memoarray에 추가.
                    if fixData == 0 {
                        unFixMemoDataArray.append(findData)
                    }else{
                        fixMemoDataArray.append(findData)
                    }
                }
                
                //두가지 배열 모두 보내줌.
                completion(.success((unFixMemoDataArray, fixMemoDataArray)))
            }
        }
    }
}

