//
//  ListenerService.swift
//  IChat
//
//  Created by Artyom Beldeiko on 27.05.22.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseAuth
import UIKit


class ListenerService {
    
    static let shared = ListenerService()
    
    private let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    private var currentUserId: String {
        return Auth.auth().currentUser!.uid
    }
    
    func usersObserve(users: [MUSer], completion: @escaping (Result<[MUSer], Error>) -> Void) -> ListenerRegistration? {
        
        var users = users
        
        let usersListener = usersRef.addSnapshotListener { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            
            querySnapshot.documentChanges.forEach { (diff) in
                guard let muser = MUSer(document: diff.document) else { return }
                
                switch diff.type {
                case .added:
                    guard !users.contains(muser) else { return }
                    guard muser.id != self.currentUserId else { return }
                    users.append(muser)
                case .modified:
                    guard let index = users.firstIndex(of: muser) else { return }
                    users[index] = muser
                case .removed:
                    guard let index = users.firstIndex(of: muser) else { return }
                    users.remove(at: index)
                }
            }
            
            completion(.success(users))
            
        }
        
        return usersListener
        
    }
    
}
