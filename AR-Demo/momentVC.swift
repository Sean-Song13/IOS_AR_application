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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "comment",for: indexPath)
        cell.textLabel?.text="comment"//load comment here
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
    var currentUser: TagShareServer.User?
    
    let tagShareServer = TagShareServer()
    
    //tagShareServer.downLoadAllPosts()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func loadData(){
     //   var posts=[Post]=[]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! theMomentCell
        cell.userName.text = "SampleUser12345"
        cell.userText.text = "HelloWorld!"
        cell.userImage.image = UIImage(named:"large")
        cell.loadComment()
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let commentVC=storyboard?.instantiateViewController(withIdentifier:"commentVC") as! CommentView
        //commentVC.userImage=
        //commentVC.userName=
        //commentVC.userText=
        navigationController?.pushViewController(commentVC, animated: true)
    }
    
    
    func setupMoments(){
        theMomentTable.dataSource=self
        theMomentTable.reloadData()
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        theMomentTable.delegate=self
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
