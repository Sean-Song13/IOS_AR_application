//
//  CommentView.swift
//  AR-Demo
//
//  Created by Chongtian Zhang on 12/5/21.
//

import UIKit

class CommentView: UIViewController {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userText: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBAction func Like(_ sender: Any) {
        
    }
    
    @IBOutlet weak var newCommentText: UITextField!
    
    @IBAction func submitComment(_ sender: Any) {
        let check=newCommentText.text?.replacingOccurrences(of: " ", with: "")
        if check != ""{
            let newComment=newCommentText.text
            //send to server..
            //kkkkk
            
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
