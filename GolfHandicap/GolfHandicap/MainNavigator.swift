//
//  MainNavigator.swift
//  GolfHandicap
//
//  Created by 1okmon on 02.03.2023.
//

import Foundation
import UIKit
struct MainNavigator {
    static func getVCFromMain(withIdentifier: String) -> UIViewController {
        let storyBoard = UIStoryboard(
            name: "Main",
            bundle: nil)
        let targetVC = storyBoard.instantiateViewController(withIdentifier: withIdentifier)
        return targetVC
    }
}
