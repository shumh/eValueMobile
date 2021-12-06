//
//  CourseListViewController.swift
//  eValueMobile
//
//  Created by Richard Shum on 12/5/21.
//

import UIKit

class CourseListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var courses: Courses!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        courses = Courses()
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        courses.loadData {
            self.tableView.reloadData()
        }
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
        cell.courseIDLabel?.text = courses.courseArray[indexPath.row].courseID
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
