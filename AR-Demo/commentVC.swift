//
//  commentVC.swift
//  AR-Demo
//
//  Created by Chongtian Zhang on 12/4/21.
//

import UIKit

class commentVC: UIViewController {

    @IBOutlet weak var UserName: UILabel!
    
    @IBOutlet weak var userText: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBAction func Like(_ sender: Any) {
        
    }
    
    @IBOutlet weak var newComment: UITextField!
    
    @IBAction func sendComment(_ sender: Any) {
        let check=newComment.text?.replacingOccurrences(of: " ", with: "")
        if check != ""{
            let newCommentText=newComment.text
            //send to server
        }
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
