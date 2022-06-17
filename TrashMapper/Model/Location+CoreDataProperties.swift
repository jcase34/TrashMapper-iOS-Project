//
//  Location+CoreDataProperties.swift
//  
//
//  Created by Jacob Case on 6/14/22.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var date: Date
    @NSManaged public var locationDescription: String

}

//adding identifiable extension allows usage of attributes in other parts of app
//without it, cannot create Location object in CreatePostViewController
extension Location : Identifiable {
    
}
