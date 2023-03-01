//
//  ViewController.swift
//  GolfHandicap
//
//  Created by 1okmon on 01.03.2023.
//
import SpreadsheetView
import UIKit

class ViewController: UIViewController, SpreadsheetViewDataSource, SpreadsheetViewDelegate {
    private let spreadSheetView = SpreadsheetView()
    private var textField = UITextField()
    private var pickedElementIndexPath = IndexPath()
    var grossScope = Float()
    let courceRating = Float()
    let slopeRating = Float()
    var total = [Int]()
    let holes = ["Hole", "#1", "#2", "#3", "#4", "#5", "#6", "#7", "#8", "#9" , "OUT"]
    let PAR = ["PAR", "4", "4", "5", "4", "3", "4", "3" , "4", "4", "35"]
    let rounds = ["Round 1", "Round 2", "Round 3", "Round 4", "Round 5"]
    let countOfTitleRows: Int = 2
    let countOfTitleCols: Int = 2
    var tableValues = [[Int]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableValues = [[Int]](repeating: [Int](repeating: 0, count: holes.count - countOfTitleRows), count: rounds.count)
        total = [Int](repeating: 0, count: rounds.count)
        spreadSheetView.gridStyle = .solid(width: 1, color: .black)
        spreadSheetView.register(MySpreadSheetCell.self, forCellWithReuseIdentifier: MySpreadSheetCell.identifier)
        spreadSheetView.delegate = self
        spreadSheetView.dataSource = self
        view.addSubview(spreadSheetView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        spreadSheetView.frame = CGRect(x: 0, y: 100, width: view.frame.size.width, height: view.frame.size.height)
    }
    
    func configurationTextField(textField: UITextField!) {
        self.textField.placeholder = "Some text";
        self.textField.keyboardType = .decimalPad
    }
    
    func calculateGrossScoreIfTableComplytelyFilled() {
        for i in (0..<tableValues.count) {
            for j in (0..<tableValues[i].count) {
                guard tableValues[i][j] != 0 else {
                    return
                }
            }
        }
        
        var sum = 0
        for i in (0..<rounds.count) {
            sum += total[i]
        }
        grossScope = Float(sum) / Float(rounds.count)
        print(grossScope)
    }
    
    func openAlertView() {
        let alert = UIAlertController(title: "Введите количество ударов", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { (textField) in
            textField.keyboardType = .numberPad
            textField.placeholder = "Количество"
        }
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler:{ (UIAlertAction) in
            guard let text = alert.textFields?.first?.text else {
                return
            }
            guard let enteredNumber = NumberFormatter().number(from: text) as? Int else {
                return
            }
            self.tableValues[self.pickedElementIndexPath.row - self.countOfTitleRows] [self.pickedElementIndexPath.section - self.countOfTitleCols + 1] = enteredNumber
            self.total[self.pickedElementIndexPath.row - self.countOfTitleRows] = enteredNumber
            self.spreadSheetView.reloadData();
            self.calculateGrossScoreIfTableComplytelyFilled()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        holes.count
    }
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        rounds.count + countOfTitleRows
    }
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        100
    }
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        60
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        pickedElementIndexPath = indexPath
        if indexPath.row >= countOfTitleRows &&
            indexPath.section >= countOfTitleCols - 1 &&
            indexPath.section <= holes.count - countOfTitleCols {
            openAlertView()
        }
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: MySpreadSheetCell.className, for: indexPath) as? MySpreadSheetCell
        
        if indexPath.row == 0 {
            cell?.setup(with: holes[indexPath.column])
            cell?.backgroundColor = .systemGreen
        } else if indexPath.row == 1 {
            cell?.setup(with: PAR[indexPath.column])
            cell?.backgroundColor = .gray
        } else if indexPath.section == 0 {
            cell?.setup(with: rounds[indexPath.row - countOfTitleRows])
            cell?.backgroundColor = .systemYellow
        } else {
            var col = indexPath.section - countOfTitleCols + 1
            if indexPath.section <= holes.count - countOfTitleCols {
                //print(indexPath.section)
                let value = tableValues[indexPath.row - countOfTitleRows][col]
                if value > 0 {
                    cell?.setup(with: String(value))
                }
            } else {
                cell?.setup(with: String(total[indexPath.row - countOfTitleRows]))
            }
        }
        return cell
    }
}

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

