//
//  SearchUserDataService.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/05/08.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct SearchUserDataService {
    //MARK: - Properties
    let db = Firestore.firestore()
    
    //MARK: - Methods
    
    //code에 맞는 유저정보를 가져오는 메서드.
    func findUserWithMatchingCode(code: String, completion: @escaping (Result<[UserData], Error>) -> Void) {
        
        db.collection("Users").whereField("code", isEqualTo: code).getDocuments { qs, error in
            if let e = error {
                completion(.failure(e))
            }else{
                var userDataArray : [UserData] = []
                
                guard let snapshotDocuments = qs?.documents else{return}
                
                for doc in snapshotDocuments {
                    let data = doc.data()
                    
                    guard let nameData = data["NickName"] as? String,
                          let emailData = data["email"] as? String,
                          let uidData = data["userUid"] as? String,
                          let codeData = data["code"] as? String else{return}
                    
                    let findData = UserData(NickName: nameData, email: emailData, userUid: uidData, code: codeData)
                    
                    userDataArray.append(findData)
                }
                
                completion(.success(userDataArray))
            }
        }
        
    }
}
    
