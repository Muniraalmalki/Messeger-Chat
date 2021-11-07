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
import FirebaseStorage
import JGProgressHUD

struct Conversation{
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage:LatestMessage
}
struct LatestMessage{
    let date:String
    let text: String
    let isRead:Bool
}
class ConversationsViewController: UIViewController {

    private let spinner = JGProgressHUD(style: .dark)
       public var conversations = [Conversation]()
//    @IBOutlet weak var tableView: UITableView!
           private let tableView: UITableView = {
           let table = UITableView()
           table.isHidden = true // first fetch the conversations, if none (don't show empty convos)

               table.register(ConversationTableViewCell.self, forCellReuseIdentifier: ConversationTableViewCell.identifier)
           return table
       }()

       private let noConversationsLabel: UILabel = {
           let label = UILabel()
           label.text = "No conversations"
           label.textAlignment = .center
           label.textColor = .gray
           label.font = .systemFont(ofSize: 21, weight: .medium)
           return label
       }()

       override func viewDidLoad() {
           super.viewDidLoad()
           navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapComposeButton))
           view.addSubview(tableView)
           view.addSubview(noConversationsLabel)
           //setupTableView()
           tableView.delegate = self
           tableView.dataSource = self
           //fetchConversations()
           tableView.isHidden = false
           startListenForConversation()
        //DatabaseManger.shared.test()
       }
    private func startListenForConversation(){
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        print("starting conversation fetch")

        let safeEmail = DatabaseManger.safeEmail(emailAddress: email)
        DatabaseManger.shared.getAllConversations(for: safeEmail, completion: {[weak self] result in
            switch result{
            case .success(let conversations ):
            print("successfully got conversation model")
                guard !conversations.isEmpty else{
                    return
                }
                print("THE CONVOS")
                print(conversations)
                self?.conversations = conversations
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print ("failed to get conversation ")
            }
        })

    }

    @objc private func didTapComposeButton(){
           // present new conversation view controller
           // present in a nav controller

           let vc = NewConversationViewController()
           vc.completion = {[weak self]result in

               // call function createNewConversation

               self?.createNewConversation(result: result)
           }
           let navVC = UINavigationController(rootViewController: vc)
           present(navVC,animated: true)
       }

    //present chat viewController
    private func createNewConversation(result: [String:String]){
        guard let name = result["name"] , let email = result["email"] else {
            return
        }
        // push on the chat view controller
        let chatVC = ChatViewController(with: email, id: nil)
        chatVC.isNewConversation = true
         chatVC.title = name
         chatVC.navigationItem.largeTitleDisplayMode = .never
         navigationController?.pushViewController(chatVC, animated: true)
    }

    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()

           tableView.frame = view.bounds
       }
       override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)


           validateAuth()
       }


       private func validateAuth(){
           // current user is set automatically when you log a user in
           if Auth.auth().currentUser == nil {
               // present login view controller
               let vc = storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
               let nav = UINavigationController(rootViewController: vc)
               nav.modalPresentationStyle = .fullScreen
               present(nav, animated: false)
           }
       }

       private func setupTableView(){
           tableView.delegate = self
           tableView.dataSource = self
       }

       private func fetchConversations(){
           // fetch from firebase and either show table or label

           tableView.isHidden = false
       }
   }




   extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return conversations.count
       }
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.identifier, for: indexPath) as! ConversationTableViewCell
           print(conversations.count)
           let model = conversations[indexPath.row]
           cell.configure(with: model)
           return cell
       }

       // when user taps on a cell, we want to push the chat screen onto the stack
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.deselectRow(at: indexPath, animated: true)
           let model = conversations[indexPath.row]

           let chatVC = ChatViewController( with:model.otherUserEmail , id: model.id)
           chatVC.title = model.name
           chatVC.navigationItem.largeTitleDisplayMode = .never
           navigationController?.pushViewController(chatVC, animated: true)
       }
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 120
       }
}


