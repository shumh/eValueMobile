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
    @IBOutlet weak var tableView: UITableView!
    
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
        }
        reviews = Reviews()
        updateUserInterface()
    }
    
    func updateUserInterface() {
        courseIDTextField.text = course.courseID
        courseNameTextField.text = course.courseName
        professorTextField.text = "Professor \(course.professorName)"
        
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
        // check if spot was saved. if not saved, save it and segue if save was successful. Otherwise, if it was saved successfully, segue as below:
        performSegue(withIdentifier: "AddReview", sender: nil)
    }
    
}

extension CourseDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.reviewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath)
        // update custom tableviewcell ehre
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}
