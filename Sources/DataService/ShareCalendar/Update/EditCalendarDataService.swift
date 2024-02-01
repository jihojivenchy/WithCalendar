//
//  EditCalendarDataService.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/05/08.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

//1. 캘린더 수정작업 - 유저가 캘린더의 이름을 변경한다거나, 캘린더 참가자 리스트에서 누군가를 제외시키거나, 추가하거나 했을 경우 수정작업을 함.
//유저가 캘린더를 만든 방장이라면 참가자 리스트에서 누군가를 제외시킬 수 있음.
//누군가를 제외했을 경우 수정작업은 1) 제외한 사람에게 저장되어 있는 공유캘린더 데이터를 삭제함. 2) 나머지 멤버들에게 수정한 리스트에 대한 정보를 업데이트.

//2. 캘린더 삭제작업 - 유저가 캘린더를 만든 방장이라면 캘린더를 삭제할 수 있음.
//삭제작업은 1) 공유캘린더 안에 저장되어 있는 데이터를 모두 삭제함. 2) 참가자들에게 저장되어 있는 공유캘린더에 대한 정보를 차례대로 삭제함.

//3. 캘린더에서 나가기작업 - 유저가 캘린더를 만든 방장이 아니라면, 공유캘린더에서 나가고 싶을 때 나갈 수 있음.
//나가기 작업은 누군가를 제외했을 경우의 수정작업과 동일함.
//1) 나가고 싶은 유저에게 저장되어 있는 공유캘린더 데이터를 삭제함.
//2) 나간 유저를 리스트에서 삭제하고, 이 리스트에 대한 정보를 나머지 멤버들에게 업데이트시켜줌.

struct EditCalendarDataService {
    //MARK: - Properties
    let db = Firestore.firestore()
    
    //MARK: - Methods
    //캘린더의 주인이 나인지 아닌지 판단.
    func checkCalendarOwner(ownerUID: String) -> Bool {
        guard let user = Auth.auth().currentUser else{return false}
        
        if user.uid == ownerUID {
            return true
        }else{
            return false
        }
    }
    
    //MARK: - 공유캘린더 수정작업.
    //공유캘린더 수정.
    func saveEditCalendarData(data: ShareCalendarCategoryData, completion: @escaping (Result<Void, Error>) -> Void) {
        let group = DispatchGroup()
        
        for userUID in data.memberUidArray { //참가자들 돌아가면서 캘린더 정보 수정.
            group.enter()
            
            let collectionID = "\(userUID).공유"
            
            db.collection(collectionID).document(data.documentID).setData([
                "calendarName" : data.calendarName,
                "date" : data.date,
                "member" : data.memberNameArray,
                "memberUid" : data.memberUidArray,
                "ownerUid" : data.ownerUid]) { error in
                    
                    if let e = error {
                        completion(.failure(e))
                    }
                    
                    group.leave()
                }
        }
        
        group.notify(queue: .main) {
            completion(.success(()))
        }
    }
    
    //제외한 유저가 존재할 경우의 공유캘린더 수정
    func saveEditCalendarDataWithRemoveUserData(data: ShareCalendarCategoryData, removeUserList: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        let group = DispatchGroup()
        
        //제외유저 명단에 있는 유저들의 공유캘린더 데이터를 삭제.
        group.enter()
        deleteShareCalendarDataToRemoveUser(documentID: data.documentID, removeUserList: removeUserList) { result in
            if case .failure(let err) = result {
                completion(.failure(err))
            }
            
            group.leave()
        }
        
        //참가자들의 공유캘린더 데이터에서 수정한 데이터를 업데이트
        group.enter()
        saveEditCalendarData(data: data) { result in
            if case .failure(let err) = result {
                completion(.failure(err))
            }
            
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion(.success(()))
        }
    }
    
    //나가려는 유저의 공유캘린더 정보 삭제.
    func deleteShareCalendarDataToRemoveUser(documentID: String, removeUserList: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        let group = DispatchGroup()
        
        for user in removeUserList {
            group.enter()
            
            let removeUserCollectionID = "\(user).공유"
            
            db.collection(removeUserCollectionID).document(documentID).delete { error in
                if let e = error {
                    completion(.failure(e))
                }
                
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(.success(()))
        }
    }
    
    //MARK: - 공유캘린더 삭제작업.
    
    //캘린더 정보와 공유캘린더 내부에 저장된 데이터 모두 삭제완료했을 경우.
    func deleteAllShareCalendarDataAndContent(data: ShareCalendarCategoryData, completion: @escaping (Result<String, Error>) -> Void) {
        let group = DispatchGroup()

        //공유캘린더 정보를 모든 참가자에게서 삭제.
        group.enter()
        deleteSharedCalendarDataForAllMembers(data: data) { result in
            if case .failure(let err) = result { //에러가 나왔을 경우
                completion(.failure(err))
            }
            group.leave()
        }

        //공유캘린더 내부에 저장된 데이터 삭제.
        group.enter()
        deleteAllShareCalendarContent(data: data) { result in
            if case .failure(let err) = result {
                completion(.failure(err))
            }
            group.leave()
        }

        //모든 작업 완료시.
        group.notify(queue: .main) {
            completion(.success(data.memberUidArray[0])) //삭제작업을 주관하는 캘린더 방장의 UID를 전달해줌 == 본인 UID
        }
    }
    
    //캘린더 멤버 모두 공유캘린더 정보삭제
    func deleteSharedCalendarDataForAllMembers(data: ShareCalendarCategoryData, completion: @escaping (Result<Void, Error>) -> Void) {
        let group = DispatchGroup()
        
        for userUID in data.memberUidArray { //참가자들 돌아가면서 캘린더 정보 삭제.
            group.enter()
            
            let collectionID = "\(userUID).공유"
            
            db.collection(collectionID).document(data.documentID).delete { error in
                if let e = error {
                    completion(.failure(e))
                }else{
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            completion(.success(()))
        }
    }
    
    //공유캘린더에 저장되어 있는 모든 데이터 삭제.
    func deleteAllShareCalendarContent(data: ShareCalendarCategoryData, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let calendarRef = db.collection(data.ownerUid).document(data.documentID)
        
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
                
                //Firestore의 대부분 메서드들은 이미 기본적으로 비동기식으로 백그라운드 큐에서 실행된다. 따라서 main큐로 놓아두어도 상관없음.
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
    
    //MARK: - 공유캘린더 나가기작업.
    //공유캘린더 참가자가 나갔을 때, 데이터 수정의 작업.
    func leaveShareCalendar(data: ShareCalendarCategoryData, completion: @escaping (Result<String, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else{return}
        let leaveUserCollectionID = "\(user.uid).공유" //나가려는 유저의 컬렉션ID
        let leaveUserName = findLeaveUserNameToList(data: data, uid: user.uid) //나가려는 유저의 이름을 찾기.
        let resultData = removeLeaveUserDataToList(data: data, leaveUserUID: user.uid, leaveUserName: leaveUserName) //나가려는 유저의 데이터를 배열에서 삭제한 최종 데이터.
        
        let group = DispatchGroup()
        
        //나가려는 유저의 공유캘린더 정보 삭제.
        group.enter()
        db.collection(leaveUserCollectionID).document(data.documentID).delete { error in
            if let e = error {
                completion(.failure(e))
            }
            
            group.leave()
        }
        
        //나가려는 유저정보를 참가자 명단에서 제외한 데이터를 업데이트.
        group.enter()
        saveEditCalendarData(data: resultData) { result in
            if case .failure(let err) = result {
                completion(.failure(err))
            }
            
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion(.success(user.uid))
        }
    }
    
    //나가려는 참가자의 데이터만 리스트에서 삭제하는 작업.
    func removeLeaveUserDataToList(data: ShareCalendarCategoryData, leaveUserUID: String, leaveUserName: String) -> ShareCalendarCategoryData{
        var uidArray = data.memberUidArray
        var nameArray = data.memberNameArray
        
        uidArray.removeAll(where: {$0 == leaveUserUID})
        nameArray.removeAll(where: {$0 == leaveUserName})
        
        let resultData = ShareCalendarCategoryData(calendarName: data.calendarName, date: data.date,
                                                   memberNameArray: nameArray, memberUidArray: uidArray,
                                                   ownerUid: data.ownerUid, documentID: data.documentID)
        
        return resultData
    }
    
    //나가려는 참가자의 이름을 찾기.
    func findLeaveUserNameToList(data: ShareCalendarCategoryData, uid: String) -> String {
        var resultName = String()
        
        if let findIndex = data.memberUidArray.firstIndex(of: uid) {
            resultName = data.memberNameArray[findIndex]
        }
        
        return resultName
    }
}
