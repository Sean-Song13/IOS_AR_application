//
//  MomentVC.swift
//  AR-Demo
//
//  Created by Chongtian Zhang on 12/4/21.
//

import UIKit

class theMomentCell:UICollectionViewCell,UITableViewDelegate,UITableViewDataSource    {
    
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var theText: UILabel!
    @IBOutlet weak var theImage: UIImageView!
    @IBOutlet weak var total_Likes: UILabel!
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

class MomentVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var momentTable: UICollectionView!
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! theMomentCell
        cell.UserName.text = "SampleUser12345"
        cell.theText.text = "HelloWorld!"
        cell.theImage.image = UIImage(named:"large")
        cell.loadComment()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let commentVC=storyboard?.instantiateViewController(withIdentifier:"commentVC") as! commentVC
        navigationController?.pushViewController(commentVC, animated: true)
    }
    
    func setupMoments(){
        momentTable.dataSource=self
        momentTable.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        momentTable.delegate=self
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
