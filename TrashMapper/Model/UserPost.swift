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
    let longitude: CLLocationCoordinate2D
    let latitude: CLLocationCoordinate2D
}

