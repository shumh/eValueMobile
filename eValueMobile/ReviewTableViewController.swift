//
//  ReviewTableViewController.swift
//  eValueMobile
//
//  Created by Richard Shum on 12/6/21.
//

import UIKit

class ReviewTableViewController: UITableViewController {
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewTitleField: UITextField!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var review: Review!
    var course: Course!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard course != nil else {
            print("ERROR: No course passed")
            return
        }
        if review == nil {
             review = Review()
        }
        updateUserInterface()

    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        ratingLabel.text = "\(currentValue)"
    }
    
    func updateUserInterface() {
        reviewTitleField.text = review.title
        reviewTextView.text = review.text
//        rating = review.rating
//        reviewDateLabel.text = "posted: \(dateFormatter.string(from: review.date))"
//        if review.documentID == "" { // this is a new review
//            addBordersToEditableObjects()
//        } else {
//            if review.reviewUserID == Auth.auth().currentUser?.uid { //posted by current user
//                self.navigationItem.leftItemsSupplementBackButton = false
//                saveBarButton.title = "Update"
//                addBordersToEditableObjects()
//                deleteButton.isHidden = false
//            } else { // posted by different user
//                saveBarButton.hide()
//                cancelBarButton.hide()
//                postedByLabel.text = "Posted by: \(review.reviewUserEmail)"
//                for starButton in starButtonCollection {
//                    starButton.backgroundColor = .white
//                    starButton.isEnabled = false
//                }
//                reviewTitleField.isEnabled = false
//                reviewTitleField.borderStyle = .none
//                reviewTextView.isEditable = false
//                reviewTitleField.backgroundColor = .white
//                reviewTextView.backgroundColor = .white
//            }
//        }
    }
    
    func updateFromUserInterface() {
        review.title = reviewTitleField.text!
        review.text = reviewTextView.text!
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func reviewTitleChanged(_ sender: UITextField) {
    }
    @IBAction func reviewTitleDonePressed(_ sender: UITextField) {
    }
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
    }
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
    }
    @IBAction func saveButtonPressed(_ sender: Any) {
        updateFromUserInterface()
        review.saveData(course: course) { (success) in
            if success {
                self.leaveViewController()
            } else {
                print("Can't unwind from segue")
            }
        }

    }
    
}
