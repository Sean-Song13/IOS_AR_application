//
//  TagShareServer.swift
//  AR-Demo
//
//  Created by Mark Lu on 12/4/21.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import UIKit

class TagShareServer {
    
    var currentUser: User?
    
    public struct ArtSet: Codable {
        var artName: String
        var posture: String //Editable
        var geoInfo: String //Editable
    }

    public struct User: Codable {
        var userId: String
        var username: String
        var password: String
        var artSets: [ArtSet]
      
    }
    
    public struct Post: Codable {
        //TBC
      
    }

    public func test() {
        
    }

    public func config() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
    }

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

    
    public func addOneRecord(user: User, artSet: ArtSet, data: Data,  _ completion: @escaping (_ success: User?) -> Void){
        let db = Firestore.firestore()
        var newUser = user
        newUser.artSets.append(artSet)
        do {
            try db.collection("Users").document(newUser.userId).setData(from: newUser)
            uploadFile(user: newUser, artName: artSet.artName, data: data)
            completion(newUser)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
    }

    private func uploadFile(user: User, artName: String, data: Data) {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let folderPathArray = [user.userId, artName]
        let riversRef = storageRef.child("/" + folderPathArray.joined(separator: "/"))
        riversRef.putData(data, metadata: nil)
        saveDatatoLocal(image: data, userId: user.userId, name: artName)
            
    }

    public func downloadAllFile(user: User) {
        let storage = Storage.storage()
        let storageReference = storage.reference().child("/" + user.userId)
        storageReference.listAll { (result, error) in
            if error != nil {
                return
            }
            for item in result.items {
                item.getData(maxSize: 1 * 5000 * 5000) { data, error in
                    if error != nil {
                        //error
                    } else {
                        
                     if let data = data {
                        //let image = UIImage(data: data)
                        self.saveDatatoLocal(image: data, userId: user.userId, name: item.name)
                     }
                        
                    }
                }
            }
        }
    }
    
    private func saveDatatoLocal(image: Data, userId: String, name: String) {
        do {
            if let folderPath = getLoaclFolderPath(userId: userId) {
                if !FileManager.default.fileExists(atPath: folderPath.path) {
                    do {
                        try FileManager.default.createDirectory(atPath: folderPath.path, withIntermediateDirectories: true, attributes: nil)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }

            if let filePath = getLocalFilePath(userId: userId, name: name) {
                try image.write(to: filePath)
            }
            
            
        } catch {
            return
        }
    }
        
    public func readAllLocalData(user: User) -> [Data]? {
        
        var dataSet: [Data] = []
        
        if let folderPath = getLoaclFolderPath(userId: user.userId) {
            if FileManager.default.fileExists(atPath: folderPath.path) {
                do {
                    let directoryContents = try FileManager.default.contentsOfDirectory(at: folderPath, includingPropertiesForKeys: nil, options: [])
                    for url in directoryContents {
                        let data = FileManager.default.contents(atPath: url.path)
                        dataSet.append(data!)
                    }
                    //dataSet.remove(at: 0)
                    return dataSet
                }
                catch {
                    print(error.localizedDescription)
                    return nil
                }
            }
        }
        else{
            return nil
        }
        return dataSet
    }
    
    public func getLoaclFolderPath(userId: String) -> URL? {
        let dirPathNoScheme = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let dirPath = "file://\(dirPathNoScheme)"
        let folderPathArray = [dirPath, userId]
        if let folderPath = URL(string: folderPathArray.joined(separator: "/")) {
            return folderPath
        } else {
            return nil
        }
    }
    public func getLocalFilePath(userId: String, name: String) -> URL? {
        let dirPathNoScheme = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let dirPath = "file://\(dirPathNoScheme)"
        let pathArray = [dirPath, userId, name]
        if let path = URL(string: pathArray.joined(separator: "/")) {
            return path
        } else {
            return nil
        }
    }
    
    private func hash(str: String) -> Int {
        var h = 0
        for i in str {
            h = 31 * h + Int(i.asciiValue!)
        }
        return h
    }

}
