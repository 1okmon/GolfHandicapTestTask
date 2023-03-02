//
//  CourseCollectionViewCell.swift
//  GolfHandicap
//
//  Created by 1okmon on 01.03.2023.
//
import UIKit
class CourseCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var BodyLabel: UILabel!
    @IBOutlet weak var BodyTextView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        let radius = CGFloat(10)
        contentView.layer.masksToBounds = false
        BodyTextView.layer.cornerRadius = radius
        BodyTextView.layer.masksToBounds = true
        BodyTextView.layer.shadowColor = UIColor.black.cgColor
        BodyTextView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        BodyTextView.layer.shadowRadius = 2.0
        BodyTextView.layer.shadowOpacity = 0.4
        BodyTextView.layer.masksToBounds = false
        BodyTextView.layer.cornerRadius = radius
    }
}
