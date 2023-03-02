//
//  CourseType.swift
//  GolfHandicap
//
//  Created by 1okmon on 02.03.2023.
//

import Foundation
enum CourseType: Codable {
    case min
    case normal
    
    var representedValue: String {
        switch self {
        case .min:
            return "min"
        case .normal:
            return "normal"
        }
    }
}
