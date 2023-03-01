//
//  NSObject+ClassName.swift
//  Note
//
//  Created by 1okmon on 01.02.2023.
//
import Foundation
extension NSObject {
    static var className: String {
        String(describing: Self.self)
    }
}
