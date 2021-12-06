//
//  SignInViewController.swift
//  AR-Demo
//
//  Created by Guohao Tong on 12/5/21.
//

import UIKit

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var currentUser: TagShareServer.User?

    @IBOutlet weak var UserName: UITextField!
    @IBOutlet weak var UserPassword: UITextField!
    
    
    @IBAction func SignInButton(_ sender: Any) {
        UserName.textColor=UIColor.black
        UserPassword.textColor=UIColor.black
        waitForSignIn(username: UserName.text!, password: UserPassword.text!)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController")
        present(newController, animated: true, completion: nil)
    }
    
    func waitForSignIn(username: String, password: String){
        let tagShareServer = TagShareServer()
        tagShareServer.signIn(username: username, password: password) { (user) in
            if let user = user {
                print("登陆成功")
                self.currentUser = user
                print(user)

                
            } else {
                print("登陆失败")
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
