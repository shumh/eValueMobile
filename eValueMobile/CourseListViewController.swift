//
//  CourseListViewController.swift
//  eValueMobile
//
//  Created by Richard Shum on 12/5/21.
//

import UIKit

class CourseListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    
    var courses: Courses!
    var status = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        courses = Courses()
        tableView.delegate = self
        tableView.dataSource = self
        configureSegmentedControl()
    }
    
    func configureSegmentedControl() {
        let primaryFontColor = [NSAttributedString.Key.foregroundColor : UIColor(named: "PrimaryColor") ?? UIColor.red]
        let whiteFontColor = [NSAttributedString.Key.foregroundColor : UIColor.white]
        sortSegmentedControl.setTitleTextAttributes(primaryFontColor, for: .selected)
        sortSegmentedControl.setTitleTextAttributes(whiteFontColor, for: .normal)

        sortSegmentedControl.layer.borderColor = UIColor.white.cgColor
        sortSegmentedControl.layer.borderWidth = 1.0
        
    }
    
    @IBAction func sortSegmentPressed(_ sender: UISegmentedControl) {
        self.sortBasedOnSegmentPressed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        courses.loadData {
            self.sortBasedOnSegmentPressed()
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    func sortBasedOnSegmentPressed(){
        switch sortSegmentedControl.selectedSegmentIndex {
        case 0: // A-Z
            courses.courseArray.sort(by: {$0.courseID < $1.courseID})
            status = true
        case 1: // closest
            courses.courseArray.sort(by: {$0.courseName < $1.courseName})
            status = false
        default:
            print("HEY! You shouldn't have gotten here. Check out the segmented control for an error!")
        }
        tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! CourseDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.course = courses.courseArray[selectedIndexPath.row]
        }
    }
}

extension CourseListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.courseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CourseTableViewCell
        if status == true {
            cell.courseIDLabel?.text = courses.courseArray[indexPath.row].courseID
        } else {
            cell.courseIDLabel?.text = courses.courseArray[indexPath.row].courseName
        }
        cell.professorNameLabel?.text = courses.courseArray[indexPath.row].professorName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
