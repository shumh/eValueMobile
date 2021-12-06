//
//  course.swift
//  eValueMobile
//
//  Created by Richard Shum on 12/5/21.
//

import Foundation
import Firebase

class Course {
    var courseID: String
    var courseName: String
    var professorName: String
    var averageRating: Double
    var numberOfReviews: Int
    var postingUserID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["courseID": courseID, "courseName": courseName, "professorName":professorName, "averageRating":averageRating, "numberOfReviews": numberOfReviews, "postingUserID": postingUserID, "documentID": documentID]
    }
    
    init(courseID: String, courseName: String, professorName: String, averageRating: Double, numberOfReviews: Int, postingUserID: String, documentID: String) {
        self.courseID = courseID
        self.courseName = courseName
        self.professorName = professorName
        self.averageRating = averageRating
        self.numberOfReviews = numberOfReviews
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience init() {
        self.init(courseID: "Course ID", courseName: "Course Name", professorName: "Professor Name", averageRating: 0.0, numberOfReviews: 0, postingUserID: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]){
        let courseID = dictionary["courseID"] as! String? ?? ""
        let courseName = dictionary["courseName"] as! String? ?? ""
        let professorName = dictionary["professorName"] as! String? ?? ""
        let averageRating = dictionary["averageRating"] as! Double? ?? 0.0
        let numberOfReviews = dictionary["numberOfReviews"] as! Int? ?? 0
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        self.init(courseID: courseID, courseName: courseName, professorName: professorName, averageRating: averageRating, numberOfReviews: numberOfReviews, postingUserID: postingUserID, documentID: "")
    }
    
    func saveData(completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        // Grab the user ID
        guard let postingUserID = Auth.auth().currentUser?.uid else {
            print("ERROR: Could not save data because we don't have a valid postingUserID.")
            return completion(false)
        }
        self.postingUserID = postingUserID
        // Create the dictionary representing data we want to save
        let dataToSave: [String: Any] = self.dictionary
        // If we HAVE saved a record, we will have an ID. Otherwise, .addDocument will create one.
        if self.documentID == "" {
            var ref: DocumentReference? = nil
            ref = db.collection("courses").addDocument(data: dataToSave) { (error) in
                guard error == nil else {
                    print("ERROR: adding document \(error!.localizedDescription)")
                    return completion(false)
                }
                self.documentID = ref!.documentID
                print("Added document: \(self.documentID)") // It worked!
                completion(true)
            }
        } else {
            let ref = db.collection("courses").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                guard error == nil else {
                    print("ERROR: updating document \(error!.localizedDescription)")
                    return completion(false)
                }
                self.documentID = ref.documentID
                print("Updated document: \(self.documentID)") // It worked!
                completion(true)
            }
        }
    }
}




//
//func updateAverageRating(completed: @escaping() -> ()) {
//    let db = Firestore.firestore()
//    let reviewsRef = db.collection("courses").document(documentID).collection("reviews")
//    reviewsRef.getDocuments { querySnapshot, error in
//        guard error == nil else {
//            print("ERROR")
//            return completed()
//        }
//        var ratingTotal = 0.0
//        for document in querySnapshot!.documents {
//            let reviewDictionary = document.data()
//            let rating = reviewDictionary["rating "] as! Int? ?? 0
//            ratingTotal = ratingTotal + Double(rating)
//        }
//        self.averageRating = ratingTotal/Double(querySnapshot!.count)
//        self.numberOfReviews = querySnapshot!.count
//        let dataToSave = self.dictionary
//        let courseRef = db.collection("courses ").document(self.documentID)
//        courseRef.setData(dataToSave) {(error) in
//            if let error = error {
//                print("😡 ERROR: updating document \(self.documentID) in course after changing averageReview & numberOfReviews info \(error.localizedDescription)")
//                completed()
//            } else {
//                print("New Average \(self.averageRating)")
//                completed()
//            }
//        }
//
//    }
//}
//}
//
