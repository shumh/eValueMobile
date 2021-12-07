//
//  CourseReviewTableViewCell.swift
//  eValueMobile
//


import UIKit

class CourseReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewTitleLabel: UILabel!
    @IBOutlet weak var reviewTextLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var review: Review! {
        didSet{
            reviewTitleLabel.text = review.title
            reviewTextLabel.text = review.text
            ratingLabel.text = "\(review.rating)"
            
        }
    }
}
