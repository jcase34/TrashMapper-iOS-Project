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
import CoreLocation


class FirebaseDataManager {
    

    
    static func createInitialEmptyUserDocument() {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        db.collection(K.users).document(user!.email!).setData([
            "loginCount" : 0,
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
    
    static func updateUserDocumentLoginEntries() {
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
    
    static func updateUserDocumentPostsEntries(_ docRef: DocumentReference) {
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
    
    static func updateUserDocumentEntriesFromPostCreation(_ docRef: DocumentReference) {
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
    
    
    static func generateNewPostReferenceID() -> DocumentReference {
        let db = Firestore.firestore()
        return db.collection(K.posts).document()
    }
    
    static func createNewPostInCloud(_ dateToAdd: String, _ descriptionText: String, _ location: CLLocationCoordinate2D, _ newDocumentRef: DocumentReference) {
        let user = Auth.auth().currentUser
        newDocumentRef.setData([
            "date" : dateToAdd,
            "latitude" : location.latitude,
            "longitude" : location.longitude,
            "description" : descriptionText,
            "author" : user!.email!,
            "image" : "some image reference point"
            ]) { error in
                if let error = error {
                    print("error occurred writing new post \(error)")
                } else {
                    print("saved post to cloud OK")
                }
        }
    }
    
    static func pullPostsFromCloud(_ newPostsHandler: @escaping ([TaggedLocationAnnotation]) -> Void) {
        let db = Firestore.firestore()
        var posts = [TaggedLocationAnnotation]()
        let docRef = db.collection("posts")
        
        //asynch operation
        docRef.getDocuments { (QuerySnapshot, error) in
            if let error = error {
                print("error retrieving data from cloud \(error)")
            } else {
                print("pulling data from cloud")
                for document in QuerySnapshot!.documents {
                    let newPost = TaggedLocationAnnotation(
                        coordinate: CLLocationCoordinate2D(
                            latitude: document.data()["latitude"] as! CLLocationDegrees,
                            longitude: document.data()["longitude"] as! CLLocationDegrees),
                        title: document.data()["date"] as! String,
                        subtitle: document.data()["description"] as! String
                        )
                    posts.append(newPost)
                }
            }
            newPostsHandler(posts)
        }
    }
}
