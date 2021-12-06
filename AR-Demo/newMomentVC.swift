//
//  newMomentVC.swift
//  AR-Demo
//
//  Created by Chongtian Zhang on 12/5/21.
//

import UIKit

class newMomentVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var newText: UITextField!
    @IBOutlet weak var newImage: UIImageView!
    @IBAction func pickImage(_ sender: Any) {
        self.getImage(sourceType: .photoLibrary)
    }
    var theImage:UIImage?=nil
    var imageData: Data!
    @IBAction func sub_New_Moment(_ sender: Any) {
        submitNew()
    }
    
    func getImage(sourceType: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true)
        guard let image=info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        newImage.image = image
        theImage = image
        imageData = theImage!.pngData()!
        //image is an UIImage object
    }
    
    func submitNew(){
        let tagShareServer = TagShareServer()
        // 添加artSet
        // 测试上传所用的Data，实际操作时直接从相册中上传单个data即可

        if let currentUser = SignInViewController.currentUser {
            
            if theImage != nil{
                let newpost = TagShareServer.Post(userId: currentUser.userId, username: currentUser.username, text: newText.text!, like: 0, artName: "NoNeedToWrite", comment: [], postId: "NoNeedToWrite")
                
                //上传
                tagShareServer.addOnePost(user: currentUser, post: newpost, data: imageData) { (success) in
                    if success {
                        print("上传Post成功")
                    } else {
                        print("上传Post失败")
                    }
                }
            }
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
