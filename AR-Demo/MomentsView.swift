//
//  MomentsView.swift
//  AR-Demo
//
//  Created by Chongtian Zhang on 11/25/21.
//

import UIKit

class theMomentCell:UITableViewCell{
    @IBOutlet weak var Texts: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var User: UILabel!
    
}

class MomentsView: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var Moment: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell", for: IndexPath) as! theMomentCell
        cell.Texts.text=""
        cell.Texts.image=""
    }
    
    func setupMoments(){
        Moment.dataSource = self
        Moment.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
