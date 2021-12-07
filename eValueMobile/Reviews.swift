//
//  Reviews.swift
//  eValueMobile
//


import Foundation
import Firebase

class Reviews {
    var reviewArray:  [Review] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
        
    }
    
    func loadData(course: Course, completed: @escaping () -> ()) {
        guard course.documentID != "" else {
            return
        }
        db.collection("courses").document(course.documentID).collection("reviews").addSnapshotListener { (QuerySnapshot, error) in
            guard error == nil else {
                print("ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.reviewArray = []
            for document in QuerySnapshot!.documents {
                let review = Review(dictionary: document.data())
                review.documentID = document.documentID
                self.reviewArray.append(review)
            }
            completed()
        }
    }
}
