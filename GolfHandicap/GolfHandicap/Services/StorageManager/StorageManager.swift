//
//  StorageManager.swift
//  GolfHandicap
//
//  Created by 1okmon on 01.03.2023.
//
import Foundation
import UIKit
enum StorageManagerKey: String, CaseIterable {
    case notFirstLaunch
}

protocol CourseStorageManager {
    func saveCourseToUserDefaults(course: Course, key: String, new: Bool?)
    func removeCourseFromUserDefaults(key: String)
    func getCourseFromUserDefaults(key: String) -> Course?
    func getAllCoursesFromUserDefaults() -> [Course]
}

protocol FirstLaunchStorageManager {
    func saveBoolToUserDefaults(bool: Bool, key: StorageManagerKey)
    func getBoolFromUserDefaults(key: StorageManagerKey) -> Bool
    func saveCourseToUserDefaults(course: Course, key: String, new: Bool?)
}

extension StorageManager: CourseStorageManager {
    func saveCourseToUserDefaults(course: Course, key: String, new: Bool?) {
        let defaults = UserDefaults.standard
        if new ?? false {
            var ids = defaults.stringArray(forKey: "Courses_ID") ?? [String]()
            ids.insert(key, at: 0)
            
            defaults.set(ids, forKey: "Courses_ID")
        }
        defaults.set(try? PropertyListEncoder().encode(course), forKey:key)
    }
    
    func removeCourseFromUserDefaults(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        var ids = UserDefaults.standard.stringArray(forKey: "Courses_ID") ?? [String]()
        ids = ids.filter { $0 != key}
        UserDefaults.standard.set(ids, forKey: "Courses_ID")
    }
    
    func getCourseFromUserDefaults(key: String) -> Course? {
        if let data = UserDefaults.standard.value(forKey: key) as? Data {
            let course = try? PropertyListDecoder().decode(Course.self, from: data)
            return course
        }
        return nil
    }
    
    func getAllCoursesFromUserDefaults() -> [Course] {
        let defaults = UserDefaults.standard
        let ids = defaults.stringArray(forKey: "Courses_ID") ?? [String]()
        var courses = [Course]()
        for id in ids {
            if let course = getCourseFromUserDefaults(key: id) {
                courses.append(course)
            }
        }
        return courses
    }
}

extension StorageManager: FirstLaunchStorageManager {
    func saveBoolToUserDefaults(bool: Bool, key: StorageManagerKey) {
        UserDefaults.standard.set(bool, forKey: key.rawValue)
    }
    
    func getBoolFromUserDefaults(key: StorageManagerKey) -> Bool {
        UserDefaults.standard.bool(forKey: key.rawValue)
    }
}

class StorageManager {
}
