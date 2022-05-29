//
//  StorageService.swift
//  IChat
//
//  Created by Artyom Beldeiko on 26.05.22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase
import FirebaseStorage

class StorageService {
    
    static let shared = StorageService()
    
    let storageRef = Storage.storage().reference()
    
    private var avatarsRef: StorageReference {
        
        return storageRef.child("avatars")
    }
    
    private var chatsRef: StorageReference {
        
        return storageRef.child("chats")
    }
    
    private var currentUserId: String {
        Auth.auth().currentUser!.uid
    }
    
    func upload(photo: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        
        guard let scaledImage = photo.scaledToSafeUploadSize, let imageData = scaledImage.jpegData(compressionQuality: 0.4) else { return }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        avatarsRef.child(currentUserId).putData(imageData, metadata: metaData) { (metaData, error) in
            
            guard let _ = metaData else {
                completion(.failure(error!))
                return
            }
            
            self.avatarsRef.child(self.currentUserId).downloadURL { (url, error) in
                guard let downloadedUrl = url else {
                    completion(.failure(error!))
                    return
                }
                
                completion(.success(downloadedUrl))
                
            }
            
        }
        
    }
    
    func uploadImageMessage(photo: UIImage, to chat: MChat, completion: @escaping (Result<URL, Error>) -> Void) {
        
        guard let scaledImage = photo.scaledToSafeUploadSize, let imageData = scaledImage.jpegData(compressionQuality: 0.4) else { return }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let image = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        let uid: String = Auth.auth().currentUser!.uid
        let chatName = [chat.friendUsername, uid].joined()
        self.chatsRef.child(chatName).child(image).putData(imageData, metadata: metaData) { (metaData, error) in
            
            guard let _ = metaData else {
                completion(.failure(error!))
                return
            }
            
            self.chatsRef.child(chatName).child(image).downloadURL { (url, error) in
                guard let downloadURL = url else {
                    completion(.failure(error!))
                    return
                }
                
                completion(.success(downloadURL))
            }
        }
    }
    
    func downloadImage(url: URL, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        let megaByte = Int64(1 * 1024 * 1024)
        
        ref.getData(maxSize: megaByte) { (data, error) in
            guard let imageData = data else {
                completion(.failure(error!))
                return
            }
            
            completion(.success(UIImage(data: imageData)))
        }
        
    }
    
}
