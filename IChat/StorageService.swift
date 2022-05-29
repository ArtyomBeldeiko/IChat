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
    
    
    
    
}