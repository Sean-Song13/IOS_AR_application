//
//  TagShareServerTestViewController.swift
//  AR-Demo
//
//  Created by Mark Lu on 12/4/21.
//

import UIKit

class TagShareServerTestViewController: UIViewController {

    //static var currentUser: TagShareServer.User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
        
        let tagShareServer = TagShareServer()
        tagShareServer.config()
        
        //tagShareServer.test()
        //123123
        
        
        //请先等待SignIn确保currentUser != nil
    }
    
    
    
    
//    @IBAction func newPost(_ sender: Any) {
//        let tagShareServer = TagShareServer()
//        // 添加artSet
//        // 测试上传所用的Data，实际操作时直接从相册中上传单个data即可
//        let testUpSet = testHelper()
//
//
//        if let currentUser = TagShareServerTestViewController.currentUser {
//
//            let newpost = TagShareServer.Post(userId: currentUser.userId, username: currentUser.username, text: "chuancan", like: 5, artName: "NoNeedToWrite", comment: ["chuancan","11"], postId: "NoNeedToWrite")
//
//            //上传
//            tagShareServer.addOnePost(user: currentUser, post: newpost, data: testUpSet![0]) { (success) in
//                if success {
//                    print("上传Post成功")
//
//
//                } else {
//                    print("上传Post失败")
//                }
//            }
//        }
//
//        if let currentUser = TagShareServerTestViewController.currentUser {
//            let newpost = TagShareServer.Post(userId: currentUser.userId, username: currentUser.username, text: "666123", like: 5, artName: "NoNeedToWrite", comment: ["66666","11"], postId: "NoNeedToWrite")
//            tagShareServer.addOnePost(user: currentUser, post: newpost, data: testUpSet![1]) { (success) in
//                if success {
//                    print("上传Post成功")
//
//
//                } else {
//                    print("上传Post失败")
//                }
//            }
//        }
//    }
//
//
//
//    @IBAction func getAllPost(_ sender: Any) {
//        let tagShareServer = TagShareServer()
//
//        tagShareServer.downloadAllPostFile()
//
//        tagShareServer.downLoadAllPosts() { (postSet) in
//            if let postSet = postSet {
//                print("获取成功")
//                print(postSet)
//
//                for post in postSet {
//                    if let data = tagShareServer.readPostDataUsingArtName(artName: post.artName){
//                        let image = UIImage(data: data)
//                        //print(image)
//                        self.testview.image = image
//                    }
//                    print(post.comment)
//
//                }
//
//
//            } else {
//                print("获取失败")
//            }
//        }
//    }
//
//
//    @IBAction func getTotalOnMap(_ sender: Any) {
//
//        let tagShareServer = TagShareServer()
//
//        tagShareServer.downloadTotalFile()
//
//
//        tagShareServer.downLoadAllUsers() { (userSet) in
//            if let userSet = userSet {
//                print("获取成功")
//                print(userSet)
//                for user in userSet {
//                    for art in user.artSets {
//                        print(art.artName)
//
//
//                        if let data = tagShareServer.readTotalDataUsingArtName(artName: art.artName){
//                            let image = UIImage(data: data)
//                            //print(image)
//                            self.testview.image = image
//                                //
//                            }
//                            print(post.comment)
//                        }
//
//                    }
//                }
//            } else {
//                print("获取失败")
//            }
//        }
//    }
//
//
//
//
//    @IBAction func getAllUser(_ sender: Any) {
//
//        let tagShareServer = TagShareServer()
//        tagShareServer.downLoadAllUsers() { (userSet) in
//            if let userSet = userSet {
//                print("获取成功")
//                print(userSet)
//            } else {
//                print("获取失败")
//            }
//        }
//    }
//
//    func getLocalTestDataGif(fileName: String) -> Data? {
//        guard let bundleURL = Bundle.main
//            .url(forResource: fileName, withExtension: "gif") else {
//                print("错误错误错误This image named  does not exist!")
//                return nil
//        }
//        guard let imageData = try? Data(contentsOf: bundleURL) else {
//            print("错误错误错误Cannot turn image named  into NSData")
//            return nil
//        }
//        return imageData
//    }
//    func getLocalTestDataJpg(fileName: String) -> Data? {
//        guard let bundleURL = Bundle.main
//            .url(forResource: fileName, withExtension: "jpeg") else {
//                print("错误错误错误This image named  does not exist!")
//                return nil
//        }
//        guard let imageData = try? Data(contentsOf: bundleURL) else {
//            print("错误错误错误Cannot turn image named  into NSData")
//            return nil
//        }
//        return imageData
//    }
//
//    @IBAction func uploadExample(_ sender: Any) {
//        let tagShareServer = TagShareServer()
//
//
//        if let ex1 = getLocalTestDataJpg(fileName: "1"){
//            let currentUser = TagShareServer.User(userId: "example", username: "", password: "", artSets: [])
//            tagShareServer.uploadFile(user: currentUser, artName: "1", data: ex1)
//        }
//        if let ex2 = getLocalTestDataGif(fileName: "RickandMorty-0") {
//            let currentUser = TagShareServer.User(userId: "example", username: "", password: "", artSets: [])
//            tagShareServer.uploadFile(user: currentUser, artName: "RickandMorty-0", data: ex2)
//        }
//
//
//    }
//    @IBOutlet weak var testview: UIImageView!
//    @IBAction func signUpButton(_ sender: Any) {
//        waitForSignUp(username: "JackLi", password: "JackLi")
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
//    }
//    @IBAction func signInButton(_ sender: Any) {
//        waitForSignIn(username: "JackLi", password: "JackLi")
//    }
//    func waitForSignIn(username: String, password: String){
//        let tagShareServer = TagShareServer()
//        tagShareServer.signIn(username: username, password: password) { (user) in
//            if let user = user {
//                print("登陆成功")
//                TagShareServerTestViewController.currentUser = user
//                print(user)
//
//
//            } else {
//                print("登陆失败")
//            }
//        }
//    }
//
//    @IBAction func upload(_ sender: Any) {
//        let tagShareServer = TagShareServer()
//        // 添加artSet
//        let NewartSet1 = TagShareServer.ArtSet(artName: "2.jpg", mapUrl: URL(fileURLWithPath: "1"), lotitude: "1", langtitude: "1")
//        let NewartSet2 = TagShareServer.ArtSet(artName: "1.jpg", mapUrl: URL(fileURLWithPath: "1"), lotitude: "1", langtitude: "1")
//
//        // 测试上传所用的Data，实际操作时直接从相册中上传单个data即可
//        let testUpSet = testHelper()
//
//
//        if let currentUser = TagShareServerTestViewController.currentUser {
//            //上传
//            tagShareServer.addOneRecord(user: currentUser, artSet: NewartSet1, data: testUpSet![0]) { (user) in
//                if let newUser = user {
//                    print("上传成功")
//                    TagShareServerTestViewController.currentUser = newUser
//
//                } else {
//                    print("上传失败")
//                }
//            }
//        }
//
//        if let currentUser = TagShareServerTestViewController.currentUser {
//            tagShareServer.addOneRecord(user: currentUser, artSet: NewartSet2, data: testUpSet![1]) { (user) in
//                if let newUser = user {
//                    print("上传成功")
//                    TagShareServerTestViewController.currentUser = newUser
//                } else {
//                    print("上传失败")
//                }
//            }
//        }
//
//
//    }
//
//    @IBAction func download(_ sender: Any) {
//        let tagShareServer = TagShareServer()
//        if let currentUser = TagShareServerTestViewController.currentUser {
//                    //可以进行读取
//            if let dataSet = tagShareServer.readAllLocalData(user: currentUser){
//                print("该用户所有的Data结果 \(String(describing: dataSet))")
//
////                let image = UIImage(data: dataSet[0])
////                //print(image)
////                testview.image = image
//            }
//        }
//
//    }
//
//    func testHelper() -> [Data]? {
//        let tagShareServer = TagShareServer()
//        var dataSet: [Data] = []
//        let user = TagShareServer.User(userId: "example", username: "", password: "", artSets: [])
//
//        if let folderPath = tagShareServer.getLoaclFolderPath(userId: user.userId) {
//            if FileManager.default.fileExists(atPath: folderPath.path) {
//                do {
//                    let directoryContents = try FileManager.default.contentsOfDirectory(at: folderPath, includingPropertiesForKeys: [], options: [])
//                    for url in directoryContents {
//                        let data = FileManager.default.contents(atPath: url.path)
//                        dataSet.append(data!)
//                    }
//                    //BUGGGGGGGG fixed
//                    //dataSet.remove(at: 0)
//                    return dataSet
//                }
//                catch {
//                    print(error.localizedDescription)
//                    return nil
//                }
//            }
//        }
//        else{
//            return nil
//        }
//        return dataSet
//
//
//
//
//    }
//
//    func waitForSignUp(username: String, password: String){
//        let tagShareServer = TagShareServer()
//        tagShareServer.signUp(username: username, password: password) { (success) in
//            if let success = success {
//                if success{
//                    print("注册成功")
//
//                } else {
//                    print("注册失败")
//                }
//            } else {
//                print("异常错误")
//            }
//        }
//    }
//
//
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


