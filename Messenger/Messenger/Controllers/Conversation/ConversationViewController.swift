//
//  ConversationViewController.swift
//  Messenger
//
//  Created by munira almallki on 21/03/1443 AH.
//

import UIKit
import Firebase
import FirebaseAuth

class ConversationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
               
               do {
                   try FirebaseAuth.Auth.auth().signOut()
               }
               catch {
                   
               }
               DatabaseManger.shared.test() // call test!

        // Do any additional setup after loading the view.
    }
    



}
