//
//  Courses.swift
//  eValueMobile
//
//  Created by Richard Shum on 12/5/21.
//

import Foundation
import Firebase

class Courses {
    var courseArray: [Course] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("courses").addSnapshotListener { (QuerySnapshot, error) in
            guard error == nil else {
                print("ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.courseArray = []
            for document in QuerySnapshot!.documents {
                let course = Course(dictionary: document.data())
                course.documentID = document.documentID
                self.courseArray.append(course)
            }
            completed()
        }
    }
}
