//
//  Reviews.swift
//  eValueMobile
//
//  Created by Richard Shum on 12/6/21.
//

import Foundation
import Firebase

class Reviews {
    var reviewArray:  [Review] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
        
    }
    
//    func loadData(spot:Spot, completed: @escaping () -> ()) {
//        guard spot.documentID != "" else {
//            return
//            
//        }
//        db.collection("spots").document(spot.documentID).collection("reviews").addSnapshotListener { (QuerySnapshot, error) in
//            guard error == nil else {
//                print("ERROR: adding the snapshot listener \(error!.localizedDescription)")
//                return completed()
//            }
//            self.reviewArray = []
//            for document in QuerySnapshot!.documents {
//                let review = Review(dictionary: document.data())
//                review.documentID = document.documentID
//                self.reviewArray.append(review)
//            }
//            completed()
//        }
//    }
}
