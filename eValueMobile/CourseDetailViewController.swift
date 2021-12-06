//
//  CourseDetailViewController.swift
//  eValueMobile
//
//  Created by Richard Shum on 12/5/21.
//

import UIKit

class CourseDetailViewController: UIViewController {
    @IBOutlet weak var courseTextField: UITextField!
    @IBOutlet weak var professorTextField: UITextField!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var course: Course!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if course == nil {
            course = Course()
        }
        updateUserInterface()
    }
    
    func updateUserInterface() {
        courseTextField.text = course.courseID
        professorTextField.text = course.professorName
        
    }
    
    func updateFromInterface() {
        course.courseID = courseTextField.text!
        course.professorName = professorTextField.text!
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
    

}
