//
//  DashedBorderView.swift
//  TrashMapper
//
//  Created by Jacob Case on 6/2/22.
//

import Foundation
import UIKit

extension UIView {
    func addDashedBorder() {
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.bounds.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = self.bounds
        shapeLayer.position = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [10,5]
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 2).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
}
