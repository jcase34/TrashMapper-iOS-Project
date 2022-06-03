//
//  UserPost.swift
//  TrashMapper
//
//  Created by Jacob Case on 5/27/22.
//

import Foundation
import CoreLocation

struct UserPost {
    //let imageURL: URL
    let date: Date
    let locationDescription: String
    let userID: String
    let longitude: Double
    let latitude: Double
    
    init(date date: Date, locationDescription locationDescription: String, userID userID: String, longitude longitude: Double, latitude latitude: Double) {
        self.date = date
        self.locationDescription = locationDescription
        self.userID = userID
        self.longitude = longitude
        self.latitude = latitude
    }
    
}

