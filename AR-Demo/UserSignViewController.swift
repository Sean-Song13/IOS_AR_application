//
//  UserSignViewController.swift
//  AR-Demo
//
//  Created by Guohao Tong on 12/4/21.
//

import Foundation
class UserSignViewController : UIViewController{
    
    
    public func signIn(username: String, password: String, _ completion: @escaping (_ success: User?) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("Users").document(String(hash(str: username)))

        docRef.getDocument { (document, error) in
            let result = Result {
              try document?.data(as: User.self)
            }
            switch result {
            case .success(let item):
                if let item = item {
                    if(item.password == password) {
                        self.downloadAllFile(user: item)
                        completion(item)
                    } else {
                        completion(nil)
                    }
                } else {
                    print("Document does not exist")
                    completion(nil)
                }
            case .failure(let error):
                print("Error decoding city: \(error)")
                completion(nil)
            }
        }

        
    }
    
    public func signUp(username: String, password: String, _ completion: @escaping (_ success: Bool?) -> Void) {
        let user = User(userId: String(hash(str: username)), username: username, password: password, artSets: [])
        let db = Firestore.firestore()
        let docRef = db.collection("Users").document(String(hash(str: username)))
        docRef.getDocument { (document, error) in
            let result = Result {
              try document?.data(as: User.self)
            }
            switch result {
            case .success(let item):
                if item != nil {
                   completion(false)
                    
                } else {
                    do {
                        try db.collection("Users").document(user.userId).setData(from: user)
                    } catch let error {
                        print("Error writing city to Firestore: \(error)")
                    }
                    completion(true)
                }
            case .failure(let error):
                completion(nil)
                print("Error decoding city: \(error)")

            }
        }

    }
}
