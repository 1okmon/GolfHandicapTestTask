//
//  ServiceLocator.swift
//  GolfHandicap
//
//  Created by 1okmon on 02.03.2023.
//
import Foundation
struct ServiceLocator {
    static func courseStorageManager () ->
    CourseStorageManager {
        StorageManager()
    }
    
    static func firstAppLaunch () ->
    FirstLaunchStorageManager {
        StorageManager()
    }
}
