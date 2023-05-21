//
//  MenuDataService.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/05/19.
//

import Foundation
import FirebaseAuth

struct MenuDataService {
    //파이어베이스 로그아웃.
    func firebaseLogout(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
            
        } catch let signOutError {
            completion(.failure(signOutError))
        }
    }
}
