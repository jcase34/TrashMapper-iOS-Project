//
//  PostDataManager.swift
//  TrashMapper
//
//  Created by Jacob Case on 6/3/22.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift
import CoreLocation
import UIKit
import SDWebImage


class FirebaseDataManager {
    
    static let shared = FirebaseDataManager()
    
    private init() {}
    
    func createInitialEmptyUserDocument() {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        db.collection(K.users).document(user!.email!).setData([
            "loginCount" : 1,
            "postCount" : 0,
            "posts" : []
        ]) { error in
            if let error = error {
                print("error creating user doc entry \(error)")
            } else {
                print("created user doc entry OK")
            }
        }
    }
    
    func updateUserDocumentLoginEntries() {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        db.collection(K.users).document(user!.email!).updateData([
            "loginCount" : FieldValue.increment(Int64(1))
        ]) { error in
            if let error = error {
                print("error updating user doc data \(error)")
            } else {
                print("successfully update user doc data")
            }

        }
    }
    
    func updateUserDocumentPostsEntries(_ docRef: DocumentReference) {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        db.collection(K.users).document(user!.email!).updateData([
            "postCount" : FieldValue.increment(Int64(1)),
            "posts" : FieldValue.arrayUnion([docRef])
        ]) { error in
            if let error = error {
                print("error updating user doc data \(error)")
            } else {
                print("successfully update user doc data")
            }
        }
    }
    
    func updateUserDocumentEntriesFromPostCreation(_ docRef: DocumentReference) {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        db.collection(K.users).document(user!.email!).updateData([
            "postCount" : FieldValue.increment(Int64(1)),
            "posts" : FieldValue.arrayUnion([docRef])
            
        ]) { error in
            if let error = error {
                print("error updating user doc data \(error)")
            } else {
                print("successfully update user doc data")
            }
        }
    }
    
    func generateNewPostReferenceID() -> DocumentReference {
        let db = Firestore.firestore()
        return db.collection(K.posts).document()
    }
    
    func createNewPostInCloud(_ dateToAdd: String, _ descriptionText: String, _ location: CLLocationCoordinate2D, imagePath: String, _ newDocumentRef: DocumentReference) {
        let user = Auth.auth().currentUser
        newDocumentRef.setData([
            "date" : dateToAdd,
            "latitude" : location.latitude,
            "longitude" : location.longitude,
            "description" : descriptionText,
            "author" : user!.email!,
            "imageUrl" : imagePath
            ]) { error in
                if let error = error {
                    print("error occurred writing new post \(error)")
                } else {
                    print("saved post to cloud OK")
                }
        }
    }
    
    func pullPostsFromCloud(_ newPostsHandler: @escaping ([Post]) -> Void) {

        let db = Firestore.firestore()
        var posts = [Post]()
        let docRef = db.collection(K.posts)
        //var filePaths: [String] = []
        
        //asynch operation
        docRef.addSnapshotListener { QuerySnapshot, Error in
            if let err = Error {
                print("Error fetching data from FB \(err.localizedDescription)")
            } else {
                for document in QuerySnapshot!.documents {
                    do {
                        let newPost = try document.data(as: Post.self)
                        posts.append(newPost)
                    } catch {
                        print("error")
                    }
                }
            }
            newPostsHandler(posts)
        }
        
    }
    
    func uploadPhoto(image: UIImage, imagePath: String) {
        //create storage reference from storage framework
        let storageRef = Storage.storage().reference()
        
        //store image data as compressed jpeg
        let imageData = image.jpegData(compressionQuality: 0.8)
        
        //verify that image isn't nil
        guard imageData != nil else {return}
        
        //specify filepath, unique ID assignment to the image being uploaded
        let fileRef =  storageRef.child(imagePath)
        
        //upload the data w/ closure
        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            
            //check for errors
            if error == nil && metadata != nil {
                //save ref to firestore database
                
            } else {
                print("Error saving picture to storage \(String(describing: error))")
                print("Metadata \(String(describing: metadata))")
            }
        }
        
        //save reference to database linking user email
    }
    
    func downloadImage(_ path: String, _ newPostsHandler: @escaping (UIImage) -> Void) {
        var newImage = UIImage()
        let imageRef = Storage.storage().reference().child(path)
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error occurred during image download \(error)")
            } else {
                newImage = UIImage(data: data!)!
            }
            newPostsHandler(newImage)
        }
    }
    
}
