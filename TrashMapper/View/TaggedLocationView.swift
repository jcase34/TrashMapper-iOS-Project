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
            let newImage: UIImage = {
                var image = UIImage()
                image = image.resizeImage(image: UIImage(named: "trash_image")!, targetSize: CGSize(width: 100, height: 100))!
               return image
            }()
            
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            detailCalloutAccessoryView = UIImageView(image: newImage)
            
            
            image = taggedLocation.image
        }
    }
}
