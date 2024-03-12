//
//  FirestoreRequest.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 3/11/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

protocol FirestoreRequest where Response: Codable {
    associatedtype Response
    
    var parentCollectionPath: String { get }
    var collectionPath: String { get }
}

extension FirestoreRequest {
    var db: Firestore { Firestore.firestore() }
}

// MARK: - Collection
extension FirestoreRequest {
    /// Firestore collection에 대한 참조
    var collectionReference: CollectionReference { db.collection(collectionPath) }
    
    /// Firestore document에 대한 참조
    func documentReference(_ documentID: String) -> DocumentReference {
        return collectionReference.document(documentID)
    }
}

// MARK: - Subcollection
extension FirestoreRequest {
    /// Subcollection에 접근하기 위한  parent collection path
    var parentCollectionPath: String { "" }
    
    var parentCollectionReference: CollectionReference { db.collection(parentCollectionPath) }
    
    /// Firestore Subcollection에 대한 참조
    func subcollectionReference(_ parentDocumentID: String) -> CollectionReference {
        return parentCollectionReference.document(parentDocumentID).collection(collectionPath)
    }
    
    /// Firestore Subcollection의 document에 대한 참조
    func subdocumentReference(_ parentDocumentID: String, _ childDocumentID: String) -> DocumentReference {
        return subcollectionReference(parentDocumentID).document(childDocumentID)
    }
}

extension FirestoreRequest {
    /// 모든 도큐먼트 fetch
    func fetch() async throws -> [Response] {
        let querySnapshot = try await collectionReference.getDocuments()
        let responses = try querySnapshot.documents.map { try $0.data(as: Response.self) }
        return responses
    }
    
    /// 도큐먼트 id로 특정 도큐먼트 fetch
    func fetch(with documentID: String) async throws -> Response {
        return try await documentReference(documentID).getDocument(as: Response.self)
    }
}
