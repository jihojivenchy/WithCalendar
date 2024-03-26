//
//  ProfileService.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 3/27/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

struct ProfileService {
    private let db = Firestore.firestore()
    
    /// 프로필 정보 조회
    func fetchProfile() async throws -> User {
        // 유저 정보 가져오기
        guard let user = Auth.auth().currentUser else {
            throw NetworkError.authenticationRequired
        }
        
        let documentReference = db.collection("Users").document(user.uid)
        let document = try await documentReference.getDocument()
        let data = document.data()
        
        guard let email = data?["email"] as? String, //유저 이메일
              let name = data?["NickName"] as? String, //유저 닉네임
              let code = data?["code"] as? String else { throw NetworkError.unknown("데이터를 찾을 수 없습니다.") }
        
        return User(uid: user.uid, name: name, code: code, email: email)
    }
}
