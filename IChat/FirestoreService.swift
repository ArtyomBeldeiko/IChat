//
//  FirestoreService.swift
//  IChat
//
//  Created by Artyom Beldeiko on 25.05.22.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirestoreService {
    
    static let shared = FirestoreService()
    
    let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        
        return db.collection("users")
    }
    
    func getUserData(user: User, completion: @escaping (Result<MUSer, Error>) -> Void) {
        
        let docRef = usersRef.document(user.uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let muser = MUSer(document: document) else {
                completion(.failure(UserError.cannotUnwrapToMuser))
                    return 
                }
                completion(.success(muser))
            } else {
                completion(.failure(UserError.userInfoIsNotAvailable))
            }
        }
        
        
    }
    
    func saveProfileWith(id: String, email: String, username: String?, avatarImageString: String?, description: String?, sex: String?, completion: @escaping (Result<MUSer, Error>) -> Void) {
        
        guard Validators.isFilled(username: username, description: description, sex: sex) else {
            completion(.failure(UserError.notFilled))
            return
        }
        
        let muser = MUSer(username: username!,
                          email: email,
                          avatarStringURL: "Not available",
                          description: description!,
                          sex: sex!,
                          id: id)
        
        self.usersRef.document(muser.id).setData(muser.representation) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(muser))
            }
        }
        
    }
        
}
