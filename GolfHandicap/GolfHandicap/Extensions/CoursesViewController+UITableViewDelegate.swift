//
//  CoursesViewController+UITableViewDelegate.swift
//  GolfHandicap
//
//  Created by 1okmon on 02.03.2023.
//

import Foundation
import UIKit
extension CoursesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoTableViewCell.className) as? UserInfoTableViewCell else {
            return UITableViewCell()
        }
        cell.nameOfInfoLable.text = infoTitles[indexPath.row]
        if infoValues[indexPath.row] < 0 {
            cell.infoLable.text = "Not enouth information"
        } else {
            cell.infoLable.text = String(infoValues[indexPath.row])
        }
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
