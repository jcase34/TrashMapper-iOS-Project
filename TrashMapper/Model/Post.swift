//
//  LocationModel.swift
//  TrashMapper
//
//  Created by Jacob Case on 12/2/22.
//

import Foundation
import CoreLocation
import FirebaseFirestoreSwift


struct Post: Codable {
    var latitude: Double
    var longitude: Double
    var date: String
    var description: String
    var imageUrl: String
}

