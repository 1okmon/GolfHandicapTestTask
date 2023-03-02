//
//  ViewController.swift
//  GolfHandicap
//
//  Created by 1okmon on 01.03.2023.
//
import SpreadsheetView
import UIKit

class CourseEditViewController: UIViewController, SpreadsheetViewDataSource, SpreadsheetViewDelegate {
    private let spreadSheetView = SpreadsheetView()
    private var textField = UITextField()
    private var pickedElementIndexPath = IndexPath()
    let storageManager = ServiceLocator.courseStorageManager()
    //var courseID = String()
    var courseFromUserDefaults: Course?
    var courseName = String()
    var gameMode: GameType = .normal
    let infoLabel = UILabel()
    var course: CourseInfo! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCourse()
        addRightButtonToNavigationBar()
        spreadSheetView.gridStyle = .solid(width: 1, color: .black)
        spreadSheetView.register(MySpreadSheetCell.self, forCellWithReuseIdentifier: MySpreadSheetCell.identifier)
        spreadSheetView.delegate = self
        spreadSheetView.dataSource = self
        setup()
        view.addSubview(spreadSheetView)
    }
    
    func loadCourse() {
        guard let courseFromUserDefaults = courseFromUserDefaults  else {
            course = CourseInfo(countOfHoles: gameMode)
            return
        }
        course = CourseInfo(holes: courseFromUserDefaults.holes, PAR: courseFromUserDefaults.PAR, rounds: courseFromUserDefaults.rounds, tableValues: courseFromUserDefaults.tableValues, total: courseFromUserDefaults.total, grossScore: courseFromUserDefaults.diffScore)
        calculateGrossScoreIfTableComplytelyFilled()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        calculateGrossScoreIfTableComplytelyFilled()
        saveCourse()
        courseFromUserDefaults = nil
        course = nil
    }
    
    func saveCourse() {
        let courseId = courseFromUserDefaults?.id ?? UUID().uuidString
        let course = Course(id: courseId, title: courseName, diffScore: self.course.diffScore, gameMode: gameMode, tableValues: self.course.tableValues, holes: self.course.holes, rounds: self.course.rounds, PAR: self.course.PAR, total: self.course.total, date: Date())
        storageManager.saveCourseToUserDefaults(course: course, key: courseId, new: courseFromUserDefaults == nil)
    }
    
    func setup() {
        infoLabel.frame = CGRect(x: 20, y: view.frame.size.height - 100, width: view.frame.size.width - 40, height: 100)
        infoLabel.textAlignment = .center
        
        infoLabel.text = "Youre current score 0.0"
        view.addSubview(infoLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        spreadSheetView.frame = CGRect(x: 0, y: 100, width: view.frame.size.width, height: view.frame.size.height)
    }
    
    func addRightButtonToNavigationBar() {
        let addButton: UIBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(deleteCourse))
        let infoImage = UIImage(systemName: "trash")
        addButton.setBackgroundImage(infoImage, for: .normal, barMetrics: .default)
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func deleteCourse(sender: AnyObject) {
        let alert = UIAlertController(title: "Удалить заметку?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Удалить", style: .default, handler: { action in
            if let courseFromUserDefaults = self.courseFromUserDefaults {
                self.storageManager.removeCourseFromUserDefaults(key: courseFromUserDefaults.id)
            }
            if let navController = self.navigationController {
                navController.popToRootViewController(animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func configurationTextField(textField: UITextField!) {
        self.textField.placeholder = "Some text";
        self.textField.keyboardType = .decimalPad
    }
    
    func calculateGrossScoreIfTableComplytelyFilled() {
        for i in (0..<course.tableValues.count) {
            for j in (0..<course.tableValues[i].count) {
                guard course.tableValues[i][j] != 0 else {
                    return
                }
            }
        }
        
        var sum = 0
        for i in (0..<course.rounds.count) {
            sum += course.total[i]
        }
        let diffScore =  ((Float(sum) / Float(course.rounds.count)) - course.courseRating) * 113 / course.slopeRating
        course.diffScore = diffScore
    }
    
    func openAlertView(currentValue: Int) {
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
            self.course.tableValues[self.pickedElementIndexPath.row - self.course.countOfTitleRows] [self.pickedElementIndexPath.section - self.course.countOfTitleCols + 1] = enteredNumber
            self.course.total[self.pickedElementIndexPath.row - self.course.countOfTitleRows] += enteredNumber - currentValue
            self.spreadSheetView.reloadData();
            self.calculateGrossScoreIfTableComplytelyFilled()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        course.holes.count
    }
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        course.rounds.count + course.countOfTitleRows
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
        if indexPath.row >= course.countOfTitleRows &&
            indexPath.section >= course.countOfTitleCols - 1 &&
            indexPath.section <= course.holes.count - course.countOfTitleCols {
            let cell = spreadsheetView.cellForItem(at: indexPath) as? MySpreadSheetCell
            let previouValue = NumberFormatter().number(from: cell?.label.text ?? "0")
            openAlertView(currentValue: previouValue as! Int)
        }
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: MySpreadSheetCell.className, for: indexPath) as? MySpreadSheetCell
        
        if indexPath.row == 0 {
            cell?.setup(with: course.holes[indexPath.column])
            cell?.backgroundColor = .systemGreen
        } else if indexPath.row == 1 {
            cell?.setup(with: course.PAR[indexPath.column])
            cell?.backgroundColor = .gray
        } else if indexPath.section == 0 {
            cell?.setup(with: course.rounds[indexPath.row - course.countOfTitleRows])
            cell?.backgroundColor = .systemYellow
        } else {
            var col = indexPath.section - course.countOfTitleCols + 1
            if indexPath.section <= course.holes.count - course.countOfTitleCols {
                //print(indexPath.section)
                let value = course.tableValues[indexPath.row - course.countOfTitleRows][col]
                if value > 0 {
                    cell?.setup(with: String(value))
                }
            } else {
                cell?.setup(with: String(course.total[indexPath.row - course.countOfTitleRows]))
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
    let tmpValForEachElement = 6
    //MARK: CR and SR is hardcoded now, but should be taken from database or parsed from Exel file or etc.
    let courseRating: Float = 35.2
    let slopeRating: Float = 140
    
    init(countOfHoles: GameType) {
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

enum GameType: Codable {
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
