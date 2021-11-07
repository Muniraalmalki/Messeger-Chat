//
//  ViewController.swift
//  Messenger
//
//  Created by munira almallki on 21/03/1443 AH.
//

import UIKit
import Firebase
import FirebaseAuth
//import FirebaseFirestore
import FirebaseStorage
import JGProgressHUD
class LoginViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        if let token = AccessToken.current,
//            !token.isExpired {
//            let token = token.tokenString
//
            // User is logged in, do work such as go to next view controller.
            
            
            // Extend the code sample from 6a. Add Facebook Login to Your Code
            // Add to your viewDidLoad method:
        //    facebookButton.permissions = ["public_profile", "email"]
            
        }
    
    
   

    @IBAction func loginInButton(_ sender: UIButton) {
        guard  let email = emailTextField.text, let password = passwordTextField.text,!email.isEmpty , !password.isEmpty,password.count >= 6 else {
            self.showAlter(message: "enter all ")
            return
        }
        spinner.show(in: view)
        Auth.auth().signIn(withEmail: email, password:password ){[weak self] authResult , error  in
            guard let strongSelf = self else{
                return
            }
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            guard let result = authResult else {
                print(authResult?.user.email)
                return
            }
            UserDefaults.standard.set(email,forKey: email)
            let user = result.user
            print("Created User: \(user)")
            let conversationVC = self?.storyboard?.instantiateViewController(withIdentifier: "ConversationsViewController") as! ConversationsViewController
            self?.navigationController?.pushViewController(conversationVC, animated: true)
        }
       // loginUser()
    }

    
    
   
//    func loginUser(){
//        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion:{ authResult, error in
//
//            guard let result = authResult, error == nil else {
//                print("Failed to log in user with email \(self.emailTextField.text)")
//                    return
//                }
//
//                let user = result.user
//            print("logged in user: \(user)")
//            let conversationVC = self.storyboard?.instantiateViewController(withIdentifier: "ConversationsViewController") as! ConversationsViewController
//            self.navigationController?.pushViewController(conversationVC, animated: true)
//
//
//
////            if  let error = error {
////                print("Error Status : \(error.localizedDescription)")
////                self.showAlter(message: error.localizedDescription)
////            } else {
////                self.showAlter(message: "Please enter a vaild email")
////            }
//        })
//
//    }
    func showAlter(message : String){
        let alterVC = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alterVC.addAction(action)
        self.present(alterVC, animated: true, completion: nil)
    }
    
    @IBAction func containueFacebookButton(_ sender: UIButton) {
     
          
    }
    
    @IBAction func signInGoogleButton(_ sender: UIButton) {
    }
    @IBAction func registerButton(_ sender: UIButton) {
        let registerVC = storyboard?.instantiateViewController(withIdentifier: "registerVC") as! RegisterViewController
        navigationController?.pushViewController(registerVC, animated: true)


    }
}



