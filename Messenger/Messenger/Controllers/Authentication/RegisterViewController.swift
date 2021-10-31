//
//  RegisterViewController.swift
//  Messenger
//
//  Created by munira almallki on 21/03/1443 AH.
//

import UIKit
import Firebase
import FirebaseAuth


class RegisterViewController: UIViewController  {
    var selectedImage = UIImagePickerController()
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
        createAccount()
    }
    func createAccount(){
        if emailTextField.text! != nil || emailTextField.text! != "" {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: PasswordTextField.text!)
            { ( authResult: AuthDataResult? , error ) in
                guard let result = authResult, error == nil else {
                        print("Error creating user")
                        return
                    }
                    let user = result.user
                    print("Created User: \(user)")
//                if let error = error {
//                    self.showAlter(message: error.localizedDescription)
//                    print(error.localizedDescription)
//                }else  {
//                    print("user succesfully created account : \(self.emailTextField.text!)")
//                }
            }}
     else {
        //showAlter(message: "Please enter a vaild email")
         let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
         navigationController?.popViewController(animated: true)
         

     }}
    
//    func showAlter(message : String){
//        let alterVC = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
//        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
//        alterVC.addAction(action)
//        self.present(alterVC, animated: true, completion: nil)
//    }

    
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

                self.imageView.image = selectedImage
                
//        if let editImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
//            imageView.image = editImage
//        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            imageView.image = originalImage
//        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
}
