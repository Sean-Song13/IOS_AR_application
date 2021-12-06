//
//  SignInViewController.swift
//  AR-Demo
//
//  Created by Guohao Tong on 12/5/21.
//

import UIKit

class SignInViewController: UIViewController  {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
                view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    static var currentUser: TagShareServer.User?

    @IBOutlet weak var UserName: UITextField!
    
    @IBOutlet weak var UserPassword: UITextField!
    
    
    @IBAction func SignInButton(_ sender: Any) {
        
        
        
       // UserName.textColor=UIColor.black
      //  UserPassword.textColor=UIColor.black
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
                SignInViewController.currentUser = user
                self.tabBarController?.tabBar.isHidden = false
                print(user)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)

                let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                    mainTabBarController.modalPresentationStyle = .fullScreen
                self.tabBarController?.tabBar.isHidden = false

                self.present(mainTabBarController, animated: true, completion: nil)
                
            } else {
                print("登陆失败")
                let alert = UIAlertController(title: "Fail!", message: "Check your input or sign up.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
               
                self.UserName.text = ""
                self.UserPassword.text = ""
                
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
