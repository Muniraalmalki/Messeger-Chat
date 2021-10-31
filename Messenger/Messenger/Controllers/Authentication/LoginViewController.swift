//
//  ViewController.swift
//  Messenger
//
//  Created by munira almallki on 21/03/1443 AH.
//

import UIKit
import Firebase
import FirebaseAuth
class LoginViewController: UIViewController {
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    
   
    
    
    
    @IBAction func loginInButton(_ sender: UIButton) {
        loginUser()
    }
      
    func loginUser(){
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { authResult, error in
            guard let result = authResult, error == nil else {
                print("Failed to log in user with email \(self.emailTextField)")
                    return
                }
                let user = result.user
                print("logged in user: \(user)")
        
//            if  let error = error {
//                print("Error Status : \(error.localizedDescription)")
//                self.showAlter(message: error.localizedDescription)
//            } else {
//                self.showAlter(message: "Please enter a vaild email")
//            }
        }
    }
    
//    func showAlter(message : String){
//        let alterVC = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
//        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
//        alterVC.addAction(action)
//        self.present(alterVC, animated: true, completion: nil)
//    }
    
    @IBAction func containueFacebookButton(_ sender: UIButton) {
    }
    
    @IBAction func signInGoogleButton(_ sender: UIButton) {
    }
    @IBAction func registerButton(_ sender: UIButton) {
        let registerVC = storyboard?.instantiateViewController(withIdentifier: "registerVC") as! RegisterViewController
        navigationController?.pushViewController(registerVC, animated: true)
        
       
    }
    
}

