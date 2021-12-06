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
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
                view.addGestureRecognizer(tap)
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
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)

                    let mainTabBarController = storyboard.instantiateViewController(identifier: "SignInBarController")
                        mainTabBarController.modalPresentationStyle = .fullScreen
                           
                    self.present(mainTabBarController, animated: true, completion: nil)
                } else {
                    print("注册失败")
                    let alert = UIAlertController(title: "Fail!", message: "Change your user name.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)

                }
            } else {
                print("异常错误")
                let alert = UIAlertController(title: "Connect Error!", message: "Check your input or sign up.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                
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
