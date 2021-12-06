//
//  CourseDetailViewController.swift
//  eValueMobile
//
//  Created by Richard Shum on 12/5/21.
//

import UIKit

class CourseDetailViewController: UIViewController {
    @IBOutlet weak var courseIDTextField: UITextField!
    @IBOutlet weak var courseNameTextField: UITextField!
    @IBOutlet weak var professorTextField: UITextField!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    var course: Course!
    var reviews: Reviews!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        if course == nil {
            course = Course()
        } else {
            disableTextEditing()
            saveBarButton.hide()
        }
        reviews = Reviews()
        updateUserInterface()
    }
    
    func disableTextEditing(){
        courseIDTextField.isEnabled = false
        courseNameTextField.isEnabled = false
        professorTextField.isEnabled = false
        ratingLabel.isEnabled = false
//        ratingLabel.backgroundColor = .clear
        courseIDTextField.borderStyle = .none
        courseNameTextField.borderStyle = .none
        professorTextField.borderStyle = .none
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reviews.loadData(course: course) {
            self.tableView.reloadData()
            if self.reviews.reviewArray.count == 0 {
                self.ratingLabel.text = "_._"
            } else {
                let sum = self.reviews.reviewArray.reduce(0) {$0 + ($1.rating)}
                var avgRating = Double(sum)/Double(self.reviews.reviewArray.count)
                avgRating = ((avgRating * 10).rounded())/10
                self.ratingLabel.text = "\(avgRating)"
            }
        }
    }
    
    func updateUserInterface() {
        courseIDTextField.text = course.courseID
        courseNameTextField.text = course.courseName
        professorTextField.text = course.professorName
        
    }
    
    func updateFromInterface() {
        course.courseID = courseIDTextField.text!
        course.courseName = courseNameTextField.text!
        course.professorName = professorTextField.text!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        updateFromInterface()
        switch segue.identifier ?? ""{
        case "AddReview":
            let navigationControler = segue.destination as! UINavigationController
            let destination = navigationControler.viewControllers.first as! ReviewTableViewController
            destination.course = course
            
        case "ShowReview":
            let destination = segue.destination as! ReviewTableViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.review = reviews.reviewArray[selectedIndexPath.row]
            destination.course = course
        default:
            print("Couldn't find a case for segue identifier \(segue.identifier!). This should not have happened!")
            
        }
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func saveCancelAlert(title: String, message: String, segueIdentifier: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle:  .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            self.course.saveData { (success) in
                self.performSegue(withIdentifier: segueIdentifier, sender: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        updateFromInterface()
        course.saveData { (success) in
            if success {
                self.leaveViewController()
            } else {
                self.oneButtonAlert(title: "Save failed", message: "For some reason, the data would not save to the cloud")
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func reviewButtonPressed(_ sender: UIButton) {
        if course.documentID == "" {
            saveCancelAlert(title: "This Course Has Not Been Saved", message: "You must save this course before you can review it", segueIdentifier: "AddReview")
        } else {
            performSegue(withIdentifier: "AddReview", sender: nil)
        }
    }
    
}

extension CourseDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.reviewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! CourseReviewTableViewCell
        cell.review = reviews.reviewArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}
