//
//  ConversationViewController.swift
//  Messenger
//
//  Created by munira almallki on 21/03/1443 AH.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
class ConversationsViewController: UIViewController {
    // root view controller that gets instantiated when app launches
    // check to see if user is signed in using ... user defaults
    // they are, stay on the screen. If not, show the login screen
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        do {
            try FirebaseAuth.Auth.auth().signOut()
        }
        catch {
            
        }
        DatabaseManger.shared.test() // call test!
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DatabaseManger.shared.test()
        
     // validateAuth()
    }
    private func validateAuth(){
            // current user is set automatically when you log a user in
            if FirebaseAuth.Auth.auth().currentUser == nil {
                // present login view controller
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                present(nav, animated: false)
//                let loginVC = storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
//                navigationController?.pushViewController(loginVC, animated: false)
            }
        }
}
