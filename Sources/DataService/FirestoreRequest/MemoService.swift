//
//  MemoService.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 3/11/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

struct MemoService {
    private let db = Firestore.firestore()
    
    func fetchMemoList() async throws -> [MemoData] {
        // 유저 정보 가져오기
        guard let user = Auth.auth().currentUser else {
            throw NetworkError.authenticationRequired
        }
        
        let collectionReference = db.collection("\(user.uid).메모")
        let querySnapshot = try await collectionReference.order(by: "date", descending: true).getDocuments()
        
        // 도큐먼트 리스트를 순회하며, 데이터 조회 -> 가공 -> 리스트에 추가
        var memoList: [MemoData] = []
        querySnapshot.documents.forEach { document in
            let data = document.data()
            
            guard let memoData = data["memo"] as? String,
                  let dateData = data["date"] as? String,
                  let fixData = data["fix"] as? Int,
                  let fixColorData = data["fixColor"] as? String else { return }
            
            memoList.append(MemoData(
                memo: memoData,
                date: dateData,
                fix: fixData,
                fixColor: fixColorData,
                documentID: document.documentID
            ))
        }
        
        // 중요 메모를 앞으로 정렬
        memoList.sort { $0.fix > $1.fix }
        return memoList
    }
}