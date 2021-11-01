//
//  User.swift
//  Messenger
//
//  Created by munira almallki on 25/03/1443 AH.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth


class User {
    var id: String
    var firstName: String
    var lastName: String
    var email: String
    var isLoggedIn: Bool
    
    
    init (_ dictionary: NSDictionary){
        if let _id = _dictionary[KID]{
            id = _id as! String
        }
        else{
            id = ""
        }
        if let mail = _dictionary[KEMAIL]{
           email = mail as! String
        }
        else{
            email = ""
        }
        if let _fname = _dictionary[KFIRSTNAME]{
            firstName = _fname as! String
        }
        else{
            firstName = ""
        }
    }
}




class func UserRegisterWith(email: String , password: String , firstName: String , lastName: String, completion: @escaping(_error:Error?) -> Void{
    Auth.auth().createPDF(with: email, completionHandler: <#T##(NSData?, Error?) -> Void#>)
}

func userDictionaryFrom(user: User) -> NSDictionary{
    return NSDictionary(objects: [user.id, user.email , user.firstName , user.lastName , user.isLoggedIn], forKeys: [KID as NSCopying , KEMAIL as NSCopying , KFIRSTNAME as NSCopying , KLASTNAME as NSCopying , KISLOGGEDIN as NSCopying])
}

func saveUserLocally(userDictionary: NSDictionary){
    UserDefaults.standard.set(userDictionary, forKey: KCURRENTUSER)
    UserDefaults.standard.synchronize()
}

// login

class func loginUser(with : em)


// save user firebase & firestore

func saveUserToFirebase (myUser: User){
    reference(.User).document(myUser.id).setData(userDictionaryFrom(user: myUser) as! [String: Any]){ error) in
        if error != nil{
            print("Error is "+ error.localizedDescription)
        }
    }
}

func saveUserToFireStore(user: User)
{
    reference(.User).document(user.id).getData(snapshot, error) in
    guard let snapshot = snapshot else { return}
    if snapshot.exits{
        saveUserLocally(userDictionary: snapshot.data()! as NSDictionary)
    }else{
        saveUserLocally(userDictionary: userDictionaryFrom(user: user))
        saveUserToFireStore(user: user)
    }
}
  // fetch user func

func fetchCurrentFromFirestore(userId: String){
    reference(.User).document(userId).getData(snapshot, error) in
    guard let snapshot = snapshot else { return}
    if snapshot.exits{
        debugPrint("update current user")
        saveUserLocally(userDictionary: snapshot.data()! as NSDictionary)
    }else{
        saveUserLocally(userDictionary: userDictionaryFrom(user: user))
        saveUserToFireStore(user: user)
    }
