//
//  AuthService.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 3/26/24.
//

import Foundation
import FirebaseAuth

struct AuthService {
    /// 로그아웃
    func signOut(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            completion(.failure(NetworkError.unknown(error.localizedDescription)))
        }
        
    }
}

