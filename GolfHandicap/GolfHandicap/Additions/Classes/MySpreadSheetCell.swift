//
//  MySpreadSheetCell.swift
//  GolfHandicap
//
//  Created by 1okmon on 02.03.2023.
//

import Foundation
import UIKit
import SpreadsheetView
class MySpreadSheetCell: Cell {
    
    static let identifier = "MySpreadSheetCell"
    public let label = UILabel()
    
    public func setup(with text: String) {
        label.text = text
        label.textAlignment = .center
        contentView.addSubview(label)
    }
    
    override func prepareForReuse() -> Void {
        label.text = nil
        self.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = contentView.bounds
    }
}
