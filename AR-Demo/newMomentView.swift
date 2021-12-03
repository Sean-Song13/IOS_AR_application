//
//  newMomentView.swift
//  AR-Demo
//
//  Created by Chongtian Zhang on 12/1/21.
//

import UIKit

class newMomentView: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var newText: UITextField!
    @IBOutlet weak var newImage: UIImageView!
    
    @IBAction func sub_new_Moment(_ sender: Any) {
        submitNew()
    }
    
    @IBAction func pickImage(_ sender: Any) {
        self.getImage(sourceType: .photoLibrary)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        newImage.image=image
    }
    
    func submitNew(){
        //text is newText.text(String)
        //picture is newImage.image(UIImage)
        
        //If success
        navigationController?.popViewController(animated: true)

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
