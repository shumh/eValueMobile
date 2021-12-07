//
//  ReviewTableViewController.swift
//  eValueMobile
//


import UIKit
import Firebase

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
        ratingLabel.text = "\(Int(slider.value))"
        updateUserInterface()

    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        ratingLabel.text = "\(Int(slider.value))"
    }
    
    func updateUserInterface() {
        reviewTitleField.text = review.title
        reviewTextView.text = review.text
        slider.value = Float(review.rating)
        ratingLabel.text = "\(Int(slider.value))"
//        reviewDateLabel.text = "posted: \(dateFormatter.string(from: review.date))"
        if review.documentID == "" { // this is a new review
            addBordersToEditableObjects()
        } else {
            if review.reviewUserID == Auth.auth().currentUser?.uid { //posted by current user
                self.navigationItem.leftItemsSupplementBackButton = false
                saveBarButton.title = "Update"
                addBordersToEditableObjects()
                deleteButton.isHidden = false
            } else { // posted by different user
                saveBarButton.hide()
                cancelBarButton.hide()
                self.navigationController!.navigationBar.tintColor = UIColor.white
                reviewTitleField.isEnabled = false
                reviewTitleField.borderStyle = .none
                reviewTextView.isEditable = false
                reviewTitleField.backgroundColor = .white
                reviewTextView.backgroundColor = .white
                slider.backgroundColor = .white
                slider.isEnabled = false
            }
        }
    }
    
    func addBordersToEditableObjects() {
        reviewTitleField.addBorder(width: 0.5, radius: 5.0, color: .black)
        reviewTextView.addBorder(width: 0.5, radius: 5.0, color: .black)
        slider.addBorder(width: 0.5, radius: 5.0, color: .black)
    }
    
    func updateFromUserInterface() {
        review.title = reviewTitleField.text!
        review.text = reviewTextView.text!
        review.rating = Int(slider.value)
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
        // prevent a title of blank spaces from being saved too
        let noSpaces = reviewTitleField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if noSpaces !=  "" {
            saveBarButton.isEnabled = true
        } else {
            saveBarButton.isEnabled = false
        }
    }
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        review.deleteData(course: course) { (success) in
            if success {
                self.leaveViewController()
            } else {
                print("Delete unsuccessful")
            }
        }
    }
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
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
