//
//  Course.swift
//  GolfHandicap
//
//  Created by 1okmon on 02.03.2023.
//

import Foundation
struct Course: Codable {
    var id: String
    var title: String
    var diffScore: Float
    var gameMode: GameType
    var tableValues: [[Int]]
    var holes: [String]
    var rounds: [String]
    var PAR: [String]
    var total: [Int]
    var date: Date
}
