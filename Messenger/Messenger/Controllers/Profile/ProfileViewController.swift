////
////  ProfileViewController.swift
////  Messenger
////
////  Created by munira almallki on 21/03/1443 AH.
////
//
//import UIKit
//import FirebaseAuth
//import FirebaseStorage
//    class ProfileViewController: UIViewController {
//
//        @IBOutlet var tableView: UITableView!
//
//        let data = ["Log Out"]
//
//        override func viewDidLoad() {
//            super.viewDidLoad()
//
//            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//            tableView.delegate = self
//            tableView.dataSource = self
//
//
//        }
//        func profileImage()-> UIView?{
//            guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
//                return nil
//            }
//            let safeEmail = DatabaseManger.safeEmail(emailAddress: email)
//            let fileName = safeEmail+"_profile_picture.png"
//            let path = "images/"+fileName
//            
//         
//            
//            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 300))
//            headerView.backgroundColor = .link
//            let imageView = UIImageView(frame: CGRect(x: (headerView.width-150), y: 75, width: 150, height: 150))
//            
//            //imagView.addSubview(imagView)
//          imageView.contentMode = .scaleAspectFill
//            imageView.layer.borderColor = UIColor.white.cgColor
//            imageView.layer.borderWidth = 2
//            imageView.layer.masksToBounds = true
//            headerView.addSubview(imageView)
//            return headerView
//
//        }
//
//
//
//
//    }
//    extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
//        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return data.count
//        }
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//            cell.textLabel?.text = data[indexPath.row]
//            cell.textLabel?.textAlignment = .center
//            cell.textLabel?.textColor = .red
//            return cell
//        }
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            tableView.deselectRow(at: indexPath, animated: true) // unhighlight the cell
//            // logout the user
//
//            // show alert
//
//            let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
//
//            actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [weak self] _ in
//                // action that is fired once selected
//
//                guard let strongSelf = self else {
//                    return
//                }
//
//
//
//                do {
//                    try FirebaseAuth.Auth.auth().signOut()
//
//                    // present login view controller
//                    let vc = LoginViewController()
//                    let nav = UINavigationController(rootViewController: vc)
//                    nav.modalPresentationStyle = .fullScreen
//                    strongSelf.present(nav, animated: true)
//                }
//                catch {
//                    print("failed to logout")
//                }
//
//            }))
//
//            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//            present(actionSheet, animated: true)
//        }
//
//    }
//
//
//
////class ProfileViewController: UIViewController {
////
////    @IBOutlet weak var tableView: UITableView!
////
////    @IBOutlet weak var imageView: UIImageView!
////
////    override func viewDidLoad() {
////        super.viewDidLoad()
////    }
////    @IBAction func logoutPressed(_ sender: UIButton) {
////    }
////}
//
