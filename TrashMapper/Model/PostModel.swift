//
//  UserPost.swift
//  TrashMapper
//
//  Created by Jacob Case on 5/27/22.
//

import Foundation


class PostModel {
    var photoURL: String
    let date: Date
    let locationDescription: String
    let userID: String
    let longitude: Double
    let latitude: Double
    
    
    init(photoURL: String, date: Date, locationDescription: String, userID: String, longitude: Double, latitude: Double) {
        self.photoURL = photoURL
        self.date = date
        self.locationDescription = locationDescription
        self.userID = userID
        self.longitude = longitude
        self.latitude = latitude
    }
    
}



