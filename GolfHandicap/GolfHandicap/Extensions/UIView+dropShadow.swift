//
//  UIView+dropShadow.swift
//  GolfHandicap
//
//  Created by 1okmon on 02.03.2023.
//

import Foundation
import UIKit
extension UIView {
    func dropShadow(scale: Bool = true, radius: CGFloat) {
        layer.masksToBounds = false
        layer.cornerRadius = radius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
      }
}
