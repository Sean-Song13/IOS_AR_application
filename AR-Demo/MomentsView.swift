//
//  MomentsView.swift
//  AR-Demo
//
//  Created by Chongtian Zhang on 11/25/21.
//

import UIKit

class theMomentCell:UICollectionViewCell{
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userText: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    
}

class MomentsView: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var theMomentTable: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return number of total moments
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        //get UserName
        cell.userName.text="sample"
        
        //get Text
        cell.userText.text="123123123"
        
        //get Image
        cell.userImage=UIImage()
        return cell
    }

    func setupMoments(){
        theMomentTable.dataSource = self
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
