//
//  MyProfileDataService.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/05/08.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct MyProfileDataService {
    let db = Firestore.firestore()
    
    //내 프로필 데이터 가져오기
    func fetchMyProfile(completion: @escaping (Result<MyProfileDataModel, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else{return}
        
        db.collection("Users").document(user.uid).getDocument { qs, error in
            if let e = error {
                completion(.failure(e))
                
            }else{
                guard let data = qs?.data() else {return} //해당 도큐먼트 안에 데이터가 있는지 확인
                
                guard let userEmailData = data["email"] as? String, //유저 이메일
                      let userNameData = data["NickName"] as? String, //유저 닉네임
                      let userCodeData = data["code"] as? String else{return}
                
                let findData = MyProfileDataModel(userName: userNameData, userEmail: userEmailData, userCode: userCodeData, userUID: user.uid)
                
                completion(.success(findData))
            }
        }
    }
    
    //내 프로필 데이터 수정하기
    func updateMyprofile(userName: String, userCode: String, completion: @escaping (Result<String, Error>) -> Void){
        
        guard let user = Auth.auth().currentUser else{return}
        let ref = db.collection("Users").document(user.uid)
        
        ref.updateData(["NickName" : userName,
                        "code" : userCode]) { error in
            if let e = error {
                completion(.failure(e))
            }else{
                completion(.success(userName))
            }
        }
    }
    
    //계정 삭제하기
    //1. 회원삭제
    //2. 유저의 정보 삭제
    //3. 유저의 캘린더 정보 삭제
    //4. 유저의 공유캘린더 정보 삭제
    //5. 유저의 메모데이터 삭제
    func deleteAccount(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else{return}
        
        //유저 계정 삭제 진행
        user.delete { error in
            if let e = error {
                completion(.failure(e))
                
            }else{ //회원삭제 완료 시
                let group = DispatchGroup()

                //유저데이터 삭제
                group.enter()
                deleteUserData(uid: user.uid) { result in
                    if case .failure(let err) = result { //에러가 나왔을 경우
                        completion(.failure(err))
                    }
                    group.leave()
                }

                //캘린더 데이터 삭제
                group.enter()
                deleteCalendarData(uid: user.uid) { result in
                    if case .failure(let err) = result {
                        completion(.failure(err))
                    }
                    group.leave()
                }
                
                //공유캘린더 정보 삭제
                group.enter()
                deleteShareCalendarData(uid: user.uid) { result in
                    if case .failure(let err) = result {
                        completion(.failure(err))
                    }
                    group.leave()
                }
                
                //메모데이터 삭제
                group.enter()
                deleteMemoData(uid: user.uid) { result in
                    if case .failure(let err) = result {
                        completion(.failure(err))
                    }
                    group.leave()
                }

                //모든 작업 완료시.
                group.notify(queue: .main) {
                    completion(.success(()))
                }
            }
        }
    }
    
    //2번 유저정보 삭제
    func deleteUserData(uid: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("Users").document(uid).delete { error in
            if let e = error {
                completion(.failure(e))
            }else{
                completion(.success(()))
            }
        }
    }
    
    //3번 캘린더 정보삭제
    func deleteCalendarData(uid: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let calendarRef = db.collection(uid).document("With Calendar")
        
        calendarRef.collection("달력내용").getDocuments { qs, error in
            if let e = error {
                completion(.failure(e))
                
            }else{
                guard let snapshotDocuments = qs?.documents else{return}
                let group = DispatchGroup()
                
                for doc in snapshotDocuments {
                    group.enter()
                    
                    calendarRef.collection("달력내용").document(doc.documentID).delete { error in
                        if let e = error {
                            group.leave()
                            completion(.failure(e))
                            
                        }else{
                            group.leave()
                        }
                    }
                }
                
                //캘린더안에 있는 데이터를 모두 삭제한 후, 캘린더 자체 데이터도 아예 삭제.
                group.notify(queue: .main) {
                    calendarRef.delete { error in
                        if let e = error {
                            completion(.failure(e))
                        }else{
                            completion(.success(()))
                        }
                    }
                }
            }
        }
    }
    
    //4번 공유캘린더 정보 삭제
    //유저가 참여하고 있는 공유캘린더 정보를 삭제해줌.
    func deleteShareCalendarData(uid: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let ref = db.collection("\(uid).공유")
        
        ref.getDocuments { qs, error in
            if let e = error {
                completion(.failure(e))
                
            }else{
                guard let snapshotDocuments = qs?.documents else{return}
                
                for doc in snapshotDocuments {
                    ref.document(doc.documentID).delete()
                }
                
                completion(.success(()))
            }
        }
    }
    
    //5번 메모데이터 삭제.
    func deleteMemoData(uid: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let ref = db.collection("\(uid).메모")
        
        ref.getDocuments { qs, error in
            if let e = error {
                completion(.failure(e))
                
            }else{
                guard let snapshotDocuments = qs?.documents else{return}
                
                for doc in snapshotDocuments {
                    ref.document(doc.documentID).delete()
                }
                
                completion(.success(()))
            }
        }
    }
}
