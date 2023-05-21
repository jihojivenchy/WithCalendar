//
//  FindPassWordService.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/05/08.
//

import Foundation
import FirebaseAuth

struct FindPassWordService {
    //비밀번호를 찾고자하는 유저의 메일에 메세지 보내주기.
    func firebaseFindPW(userID: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: userID) { error in
            if let e = error {
                completion(.failure(e))
                
            }else{
                completion(.success(userID))
            }
        }
        
    }
}
