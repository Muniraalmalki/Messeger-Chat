//
//  ViewController.swift
//  Messenger
//
//  Created by munira almallki on 21/03/1443 AH.
//

import UIKit
import Firebase
import FirebaseAuth
import FacebookCore
import FacebookLogin
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
//        }
            // User is logged in, do work such as go to next view controller.
            
            
            // Extend the code sample from 6a. Add Facebook Login to Your Code
            // Add to your viewDidLoad method:
        // facebookButton.permissions = ["public_profile", "email"]
        
            
        }
    
    
   

    @IBAction func loginInButton(_ sender: UIButton) {
        guard  let email = emailTextField.text, let password = passwordTextField.text,!email.isEmpty , !password.isEmpty,password.count >= 6 else {
            self.showAlter(message: "Please enter all information")
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
            
            let user = result.user
            print("Created User: \(user)")
            
            UserDefaults.standard.set(email,forKey: "email")
            
            let safeEmail = DatabaseManger.safeEmail(emailAddress: email)
            DatabaseManger.shared.getDataFor(path: safeEmail) { result in
                switch result{
                case .success(let data):
                    guard let userData = data as? [String: Any],
                          let firstName = userData["first_name"] as? String,
                          let lastName = userData["last_name"] as? String else{
                              return
                          }
                    UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            
//            let conversationVC = self?.storyboard?.instantiateViewController(withIdentifier: "ConversationsViewController") as! ConversationsViewController
            self?.navigationController?.dismiss( animated: true)
        }
       // loginUser()
    }

    
    
   

    func showAlter(message : String){
        let alterVC = UIAlertController(title: "Woops", message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alterVC.addAction(action)
        self.present(alterVC, animated: true, completion: nil)
    }
    
    @IBAction func containueFacebookButton(_ sender: UIButton) {
        
//        guard  let email = emailTextField.text, let password = passwordTextField.text,!email.isEmpty , !password.isEmpty,password.count >= 6 else {
//            self.showAlter(message: "enter all ")
//            return
//        }
//        guard let token = result?.token?.tokenString else{
//            print("user Failed to login with facebook ")
//            return
//        }
//        
//        let credential = FacebookAuthProvider.credential(withAccessToken: token)
//        FirebaseAuth.Auth.auth().signIn(with: credential, completion: {[weak self] authResult, error  in
//            guard let strongSelf = self else {
//                return
//            }
//            let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: token, version: nil, httpMethod: .get)
//            facebookRequest.start(completionHandler:{_, result , error in
//                guard let result = result as? [String:Any] , error == nil else {
//                    print("Failed to make facebook graph request")
//                }
//                print("\(result)")
//                let credential = FacebookAuthProvider.credential(withAccessToken: token)
//                FirebaseAuth.Auth.auth().signIn(with: credential, completion: {[weak self] authResult, error  in
//                    guard let strongSelf = self else {
//                        return
//                    }
//                
//                    guard   authResult != nil, error == nil else {
//                        if let error = error {
//                        print("Facebook credential login failed\(error) ")
//                        }
//                        return
//                    }
//                    print("Successfully logged user in ")
//                    strongSelf.navigationController?.dismiss(animated: true)
//                })
//
//            })
//            
//        })
          
    }
    
    @IBAction func signInGoogleButton(_ sender: UIButton) {
    }
    @IBAction func registerButton(_ sender: UIButton) {
        let registerVC = storyboard?.instantiateViewController(withIdentifier: "registerVC") as! RegisterViewController
        navigationController?.pushViewController(registerVC, animated: true)


    }
}



