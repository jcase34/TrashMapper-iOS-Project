//
//  TaggedLocationView.swift
//  TrashMapper
//
//  Created by Jacob Case on 10/21/22.
//

import Foundation
import MapKit

class TaggedLocationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let taggedLocation = newValue as? TaggedLocationAnnotation else {
                //new value above is of type MKAnnotation...
                return
            }
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            image = taggedLocation.image
        }
    }
}
