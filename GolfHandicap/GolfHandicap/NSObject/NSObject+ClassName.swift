//
//  NSObject+ClassName.swift
//  GolfHandicap
//
//  Created by 1okmon on 01.03.2023.
//
import Foundation
extension NSObject {
    static var className: String {
        String(describing: Self.self)
    }
}
