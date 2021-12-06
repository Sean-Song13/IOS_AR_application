//
//  CommentView.swift
//  AR-Demo
//
//  Created by Chongtian Zhang on 12/5/21.
//

import UIKit

class CommentView: UIViewController,UITextFieldDelegate {
    
    var commentSenderName:String!
    
    var theUserId:String!
    var theUserName:String!
    var theUserText:String!
    var theUserLike:Int!
    var theUserartName:String!
    var theUserComment:[String]!
    var theUserpostID:String!
    var theUserImage:UIImage!
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userText: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    var Liked:Bool = false
    
    @IBAction func Like(_ sender: Any) {
        Liked = !Liked
    }
    
    @IBOutlet weak var newCommentText: UITextField!
    
    @IBAction func submitComment(_ sender: Any) {
        let tagShareServer = TagShareServer()
        let check=newCommentText.text?.replacingOccurrences(of: " ", with: "")
        if check != ""{
            if let currentUser=SignInViewController.currentUser{
                let commentSenderName=currentUser.username
                let newComment=commentSenderName+": "+newCommentText.text!
                theUserComment.append(newComment)
            }
        }
        
        if Liked {
            theUserLike=theUserLike+1
        }
        
        let updatedPost=TagShareServer.Post(userId: theUserId, username: theUserName, text: theUserText, like: theUserLike, artName: theUserartName, comment: theUserComment, postId: theUserpostID)
        
        tagShareServer.updatePost(post: updatedPost){ (success) in
            if success {
                print("上传Post成功")
            } else {
                print("上传Post失败")
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        userName.text=theUserName
        userText.text=theUserText
        userImage.image=theUserImage
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

extension UIViewController{
    
    
}
