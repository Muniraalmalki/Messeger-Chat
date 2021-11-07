//
//  RegisterViewController.swift
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

class RegisterViewController: UIViewController  {
    private let spinner = JGProgressHUD()
    
    var selectedImage :UIImage?
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var imagePicker: UIButton!
    
   
  
   
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.borderWidth = 1
            imageView.layer.masksToBounds = false
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.cornerRadius = imageView.frame.height/2
            imageView.clipsToBounds = true
         
        // Do any additional setup after loading the view.
    }
   
   // MARK : add image picker for profile
    @IBAction func imageProfile(_ sender: UIButton) {
        // call function for show image
        showImagePickerController()
     
}


    
    @IBAction func registerButton(_ sender: UIButton) {
        guard let email = emailTextField.text ,
              let firstName = firstNameTextField.text,
                let lastName = lastNameTextField.text,
              let password = PasswordTextField.text ,
              !email.isEmpty,
              !password.isEmpty,
              password.count >= 6 else{
                  self.showAlter(message: "enter all options")
                  return
              }
        spinner.show(in: view)
        DatabaseManger.shared.userExists(with: email, completion: {[weak self] exists in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            UserDefaults.standard.set(email,forKey: "email")
            UserDefaults.standard.set("\(firstName) \(lastName)",forKey: "name")
            guard !exists else{
                strongSelf.showAlter(message: "looks like a user")
                return
            }
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { authResult,error in
              
                guard authResult != nil , error == nil else {
                    print("Error cresting user")
                    return
                }
                let chatUser = ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email)
                DatabaseManger.shared.insertUser(with: chatUser , completion: {success in
                    if success {
                         // upload image
                        guard let image = strongSelf.selectedImage, let data = image.pngData() else {
                            return
                        }
                        let fileName = chatUser.profilePictureUrl
                        StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName, completion: {result in
                                switch result{
                                case .success(let downloadURL):
                                    print(downloadURL)
                                    UserDefaults.standard.set(downloadURL, forKey: "profile_picture_URL")
                                case .failure(let error):
                                    print(error.localizedDescription)
                                    
                                
                            }
                        })
                    }
                })
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            })
        })
    }
   
    
  func showAlter(message : String){
       let alterVC = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
      let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
      alterVC.addAction(action)
       self.present(alterVC, animated: true, completion: nil)
   }

    
}

//  MARK: Add imagePicker for profile
extension RegisterViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    // function to display image from photo album
    func showImagePickerController(){
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
                    action in
                    self.presentCamera(type: .camera)
                }))
                actionSheet.addAction(UIAlertAction(title: " Photo Library", style: .default, handler: {
                    action in
                    self.presentPhotoPicker(type: .photoLibrary)
                }))
                
               present(actionSheet, animated: true)
            }
    func presentCamera(type : UIImagePickerController.SourceType) {
                let vc = UIImagePickerController()
                vc.sourceType = type
                vc.delegate = self
                vc.allowsEditing = true
                present(vc, animated: true)
            }
            func presentPhotoPicker(type : UIImagePickerController.SourceType) {
                let vc = UIImagePickerController()
                vc.sourceType = type
                vc.delegate = self
                vc.allowsEditing = true
                present(vc, animated: true)
            }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
                print(info)
                
                guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
                    return
                }
        
        self.selectedImage = selectedImage

                self.imageView.image = selectedImage
                
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

