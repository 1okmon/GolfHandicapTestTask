//
//  CourcesViewController.swift
//  GolfHandicap
//
//  Created by 1okmon on 02.03.2023.
//

import UIKit

class CoursesViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var courses = [Course]()
    var storageManager = ServiceLocator.courseStorageManager()
    var gameType: GameType = .min
    var infoView = UIView()
    let infoTitles = ["Average Diff Score", "Handicap",]
    var infoValues: [Float] = [1.2, 1.7]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: CourseCollectionViewCell.className, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: CourseCollectionViewCell.className)
        collectionView.collectionViewLayout = layout()
        addRightButtonToNavigationBar()
        addLeftButtonToNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCourses()
        collectionView.reloadData()
        calculateInfoForTableViewData()
    }
    
    func calculateInfoForTableViewData() {
        var numOfCountedGrossScores = 0
        var sumDiffScore:Float = 0
        for course in courses {
            for val in course.total {
                numOfCountedGrossScores += 1
                sumDiffScore += (Float (val) - course.courseRating) * 113 / course.slopeRating
                if numOfCountedGrossScores == 20 {
                    break
                }
            }
            if numOfCountedGrossScores == 20 {
                break
            }
            print(course.title)
        }
        
        let avgDiffScore = sumDiffScore / Float(numOfCountedGrossScores)
        infoValues[0] = avgDiffScore
        if numOfCountedGrossScores > 5 {
            let handicapIndex = avgDiffScore * 0.96
            infoValues[1] = handicapIndex
        } else {
            infoValues[1] = -1
        }
    }
    
    
    func layout() -> UICollectionViewLayout {
        return
            UICollectionViewCompositionalLayout(sectionProvider: provider())
    }
    
    func provider() -> UICollectionViewCompositionalLayoutSectionProvider {
        return { int, inviroment in
            return self.generateSection(horizontal: false)
        }
    }
    
    func addRightButtonToNavigationBar() {
        let icon = UIImage(systemName: "plus")
        let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: (icon?.size.width ?? 5) * 1.5 , height: (icon?.size.height ?? 5) * 1.5))
        let iconButton = UIButton(frame: iconSize)
        iconButton.setBackgroundImage(icon, for: .normal)
        iconButton.addTarget(self, action: #selector(createNewCourse), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: iconButton)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func configureInfoView() {
        infoView.frame = CGRect.init(x: 30, y: 100, width: self.view.frame.width - 100, height: 300)
        infoView.backgroundColor = .white
        infoView.dropShadow(radius: CGFloat(10))
        let tableView: UITableView = UITableView(frame: CGRect(x: 20, y: 20, width: infoView.frame.width - 40, height: infoView.frame.height - 40))
        let nibInfoCell = UINib(nibName: UserInfoTableViewCell.className, bundle: nil)
        tableView.register(nibInfoCell, forCellReuseIdentifier: UserInfoTableViewCell.className)
        tableView.dataSource = self
        tableView.delegate = self
        
        infoView.addSubview(tableView)
        infoView.isHidden = true
        view.addSubview(infoView)
    }
    
    func addLeftButtonToNavigationBar() {
        configureInfoView()
        let icon = UIImage(systemName: "info.circle")
        let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: (icon?.size.width ?? 5) * 1.5 , height: (icon?.size.height ?? 5) * 1.5))
        let iconButton = UIButton(frame: iconSize)
        iconButton.setBackgroundImage(icon, for: .normal)
        iconButton.addTarget(self, action: #selector(openSizePicker), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: iconButton)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @IBAction func openSizePicker(_ sender: Any) {
        if  let table = infoView.subviews.first as? UITableView {
            table.reloadData()
        }
        infoView.isHidden = !infoView.isHidden
        infoView.dropShadow(radius: CGFloat(10))
    }
    
    @objc func createNewCourse(sender: AnyObject) {
        var enteredText = String()
        
        let alert = UIAlertController(title: "Input name of course", message: "Course type:" + gameType.representedValue, preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler:{ (UIAlertAction) in
            enteredText = alert.textFields?.first?.text ?? ""
            
            if let targetVC = MainNavigator.getVCFromMain(withIdentifier: CourseEditViewController.className) as? CourseEditViewController {
                targetVC.courseName = enteredText
                targetVC.courseFromUserDefaults = nil
                targetVC.gameMode = .min
                self.navigationController?.show(targetVC, sender: nil)
            }
        }))
        
        //MARK: will be realized
//        alert.addAction(UIAlertAction(title: "Change course mode", style: .default, handler:{ (UIAlertAction) in
//            switch self.gameType {
//            case .min:
//                self.gameType = .normal
//            case .normal:
//                self.gameType = .min
//            }
//            self.present(alert, animated: false, completion: nil)
//        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func generateSection(horizontal: Bool) -> NSCollectionLayoutSection {
        let spacing: CGFloat = 10
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalWidth(0.75)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(spacing)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: spacing,
            leading: spacing,
            bottom: spacing,
            trailing: spacing
        )
        section.interGroupSpacing = spacing
        if horizontal {
            section.orthogonalScrollingBehavior = .continuous
        }
        return section
    }
    
    func loadCourses() {
        courses = storageManager.getAllCoursesFromUserDefaults()
    }
}

extension CoursesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let targetVC = MainNavigator.getVCFromMain(withIdentifier: CourseEditViewController.className) as? CourseEditViewController {
            let course = courses[indexPath.row]
            targetVC.courseFromUserDefaults = course
            navigationController?.show(targetVC, sender: nil)
        }
    }
}

extension CoursesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        courses.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseCollectionViewCell.className, for: indexPath) as? CourseCollectionViewCell {
            let course = courses[indexPath.row]
            cell.TitleLabel.text = course.title
            
            if course.diffScore < 0 {
                cell.BodyLabel.text = "Differential score can't be counted (please check your table)"
            } else {
                cell.BodyLabel.textAlignment = .center
                cell.BodyLabel.text = "Diff Score: " + String(course.diffScore)
            }
            let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = .medium
            cell.DateLabel.text = "\(course.date.get(.day)).\(course.date.get(.month)).\(course.date.get(.year))"
            return cell
        }
        return UICollectionViewCell()
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

extension UIView {
    func dropShadow(scale: Bool = true, radius: CGFloat) {
        layer.masksToBounds = false
        layer.cornerRadius = radius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
      }
}


extension CoursesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoTableViewCell.className) as? UserInfoTableViewCell else {
            return UITableViewCell()
        }
        //cell.setupProperties()
        cell.nameOfInfoLable.text = infoTitles[indexPath.row]
        cell.infoLable.text = String(infoValues[indexPath.row])
        cell.isUserInteractionEnabled = false
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        infoTitles.count
    }

}
