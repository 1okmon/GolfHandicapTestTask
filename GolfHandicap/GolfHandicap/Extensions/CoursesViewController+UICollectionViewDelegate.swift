//
//  CoursesViewController+UICollectionViewDelegate.swift
//  GolfHandicap
//
//  Created by 1okmon on 02.03.2023.
//

import Foundation
import UIKit
extension CoursesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let targetVC = MainNavigator.getVCFromMain(withIdentifier: CourseEditViewController.className) as? CourseEditViewController {
            let course = courses[indexPath.row]
            targetVC.courseFromUserDefaults = course
            navigationController?.show(targetVC, sender: nil)
        }
    }

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
