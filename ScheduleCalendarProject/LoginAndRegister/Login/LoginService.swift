//
//  LoginService.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/05/08.
//

import Foundation
import FirebaseAuth

struct LoginService {
    //파이어베이스 로그인.
    func firebaseLogin(userEmail: String, userPW: String, completion: @escaping (Result<String, Error>) -> Void){
        
        Auth.auth().signIn(withEmail: userEmail, password: userPW) { authResult, error in
            if let e = error{
                completion(.failure(e))
                
            }else{
                if let userUID = authResult?.user.uid { //로그인에 성공하면 해당 유저의 UID를 전달해줌.
                    completion(.success(userUID))
                }
            }
        }
    }
    
}
