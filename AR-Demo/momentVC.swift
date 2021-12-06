//
//  momentVC.swift
//  AR-Demo
//
//  Created by Chongtian Zhang on 12/5/21.
//

import UIKit
class theMomentCell:UICollectionViewCell,UITableViewDelegate,UITableViewDataSource    {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userText: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var totalLikes: UILabel!
    @IBOutlet weak var commentTable: UITableView!
    
    var allComments: [String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "comment",for: indexPath)
        cell.textLabel?.text=allComments[indexPath.row]
        return cell
    }
    
    func loadComment(){
        commentTable.delegate=self
        commentTable.dataSource=self
        commentTable.reloadData()
    }
}

class momentVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var theMomentTable: UICollectionView!
    
    @IBAction func refresh(_ sender: Any) {
        setupMoments()
    }
    
    var currentUser: TagShareServer.User?
    var postCache: [TagShareServer.Post] = []
    var imageCache: [UIImage] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postCache.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! theMomentCell
        cell.userName.text = postCache[indexPath.row].username+"'s Post"
        cell.userText.text = postCache[indexPath.row].text
        cell.totalLikes.text = String(postCache[indexPath.row].like)
        cell.userImage.image = imageCache[indexPath.row]
        cell.allComments=postCache[indexPath.row].comment
        cell.loadComment()
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let commentVC=storyboard?.instantiateViewController(withIdentifier:"commentVC") as! CommentView
        commentVC.theUserId=postCache[indexPath.row].userId
        commentVC.theUserpostID=postCache[indexPath.row].postId
        commentVC.theUserComment=postCache[indexPath.row].comment
        commentVC.theUserartName=postCache[indexPath.row].artName
        commentVC.theUserLike=postCache[indexPath.row].like
        commentVC.theUserImage=imageCache[indexPath.row]
        commentVC.theUserName=postCache[indexPath.row].username
        commentVC.theUserText=postCache[indexPath.row].text
        navigationController?.pushViewController(commentVC, animated: true)
    }
    
    
    func setupMoments(){
        theMomentTable.dataSource=self
        theMomentTable.reloadData()
    }
    
    func loadMoments(){

        let tagShareServer = TagShareServer()
            tagShareServer.downloadAllPostFile()
            tagShareServer.downLoadAllPosts() { (postSet) in
                if let postSet = postSet {
                    print("获取成功")
                    print(postSet)
                    self.postCache=postSet
                    var tempImageCache:[UIImage]=[]
                    for post in postSet {
                        if let data = tagShareServer.readPostDataUsingArtName(artName: post.artName){
                            let image = UIImage(data: data)
                            tempImageCache.append(image!)
                            self.imageCache=tempImageCache
                            print("---")
                            print(self.postCache.count)
                            print(self.imageCache.count)
                            }
                        }
                    
                    } else {
                        print("获取失败")
                    }
                }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        theMomentTable.delegate=self
        loadMoments()
        setupMoments()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
