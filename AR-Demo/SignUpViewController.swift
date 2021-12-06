//
//  SignUpViewController.swift
//  AR-Demo
//
//  Created by Guohao Tong on 12/5/21.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameSignUp: UITextField!
    
    @IBOutlet weak var userPasswordSignUp: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func creatAccount(_ sender: UIButton) {
        waitForSignUp(username: userNameSignUp.text!, password: userPasswordSignUp.text!)
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
    }
    
    func waitForSignUp(username: String, password: String){
        let tagShareServer = TagShareServer()
        tagShareServer.signUp(username: userNameSignUp.text!, password: userPasswordSignUp.text!) { (success) in
            if let success = success {
                if success{
                    print("注册成功")
                } else {
                    print("注册失败")
                }
            } else {
                print("异常错误")
            }
        }
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
