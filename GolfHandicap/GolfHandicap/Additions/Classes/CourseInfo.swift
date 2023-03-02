//
//  CourseInfo.swift
//  GolfHandicap
//
//  Created by 1okmon on 02.03.2023.
//

import Foundation
class CourseInfo {
    let holes: [String]!
    let PAR: [String]!
    
    //MARK: diffScore is now counting with Average gross score, but should use Adjusted gross score
    var diffScore = Float()
    
    var rounds = ["Round 1", "Round 2", "Round 3", "Round 4", "Round 5"]
    var tableValues = [[Int]]()
    var total = [Int]()
    let countOfTitleRows: Int = 2
    let countOfTitleCols: Int = 2
    
    //MARK: tmp for fast fill
    let tmpValForEachElement = 0
    //MARK: CR and SR is hardcoded now, but should be taken from database or parsed from Exel file or etc.
    let courseRating: Float = 35.2
    let slopeRating: Float = 140
    
    init(countOfHoles: CourseType) {
        diffScore = -1.0
        switch countOfHoles {
        case .min:
            holes = ["Hole", "#1", "#2", "#3", "#4", "#5", "#6", "#7", "#8", "#9" , "Total"]
            PAR = ["PAR", "4", "4", "5", "4", "3", "4", "3" , "4", "4", "35"]
        case .normal:
            holes = ["Hole", "#1", "#2", "#3", "#4", "#5", "#6", "#7", "#8", "#9", "#10", "#11", "#12", "#13", "#14", "#15", "#16", "#17", "#18", "Total"]
            PAR = ["PAR", "4", "4", "5", "4", "3", "4", "3" , "4", "4",
                       "3", "4", "3" , "4", "4", "4", "4", "5", "4", "70"]
        }
        tableValues = [[Int]](repeating: [Int](repeating: tmpValForEachElement, count: holes.count - countOfTitleCols), count: rounds.count)
        total = [Int](repeating: tmpValForEachElement  * (holes.count - countOfTitleCols), count: rounds.count)
    }
    
    init(holes: [String], PAR: [String], rounds: [String], tableValues: [[Int]], total: [Int], grossScore: Float) {
        self.holes = holes
        self.PAR = PAR
        self.rounds = rounds
        self.tableValues = tableValues
        self.total = total
        self.diffScore = grossScore
    }
}
