//
//  TaggedLocationAnnotation.swift
//  TrashMapper
//
//  Created by Jacob Case on 6/6/22.
//

import MapKit


class TaggedLocationAnnotation: NSObject, MKAnnotation {
    
    // This property must be key-value observable, which the `@objc dynamic` attributes provide.
    @objc dynamic var coordinate = CLLocationCoordinate2D(latitude: 37.795_316, longitude: -122.393_760)
    
    var title: String? = NSLocalizedString("This Title", comment: "test")
    var subtitle: String? = NSLocalizedString("This Subtitle", comment: "test")
    
}
