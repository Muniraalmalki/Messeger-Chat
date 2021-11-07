//
//  DatabaseManager.swift
//  Messenger
//
//  Created by munira almallki on 25/03/1443 AH.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth



final class DatabaseManger {
    
    static let shared = DatabaseManger()
    
    // reference the database below
    
    private let database = Database.database().reference()
    
    // create a simple write function
    
    static func safeEmail(emailAddress: String) -> String  {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
   
    
    public func test() {
        // NoSQL - JSON (keys and objects)
        // child refers to a key that we want to write data to
        // in JSON, we can point it to anything that JSON supports - String, another object
        // for users, we might want a key that is the user's email address

        database.child("foo").setValue(["something":true])
    }
    
}
// MARK: - account management
//extension DatabaseManger {
//

//    // have a completion handler because the function to get data out of the database is asynchrounous so we need a completion block
//
//
//    public func userExists(with email:String, completion: @escaping ((Bool) -> Void)) {
//        // will return true if the user email does not exist
//
//        // firebase allows you to observe value changes on any entry in your NoSQL database by specifying the child you want to observe for, and what type of observation you want
//        // let's observe a single event (query the database once)
//
//        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
//        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
//
//        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
//            // snapshot has a value property that can be optional if it doesn't exist
//
//            guard snapshot.value as? String != nil else {
//                // otherwise... let's create the account
//                completion(false)
//                return
//            }
//
//            // if we are able to do this, that means the email exists already!
//
//            completion(true) // the caller knows the email exists already
//        }
//    }
//
//    /// Insert new user to database
//
//    public func insertUser(with user: ChatAppUser,completion: @escaping(Bool) -> Void){
//           database.child(user.safeEmail).setValue(["first_name": user.firstName,
//                                                    "last_name": user.lastName],
//               withCompletionBlock: {error, _ in
//              guard error == nil else{
//               print("fialed to wries database ")
//               completion(false)
//                  return
//           }
//              completion(true)
//           } )
//
//       }
//
//}

extension DatabaseManger {
    
 
    // have a completion handler because the function to get data out of the database is asynchrounous so we need a completion block
    
    public func userExists(with email:String, completion: @escaping ((Bool) -> Void)) {
        // will return true if the user email does not exist
        
        // firebase allows you to observe value changes on any entry in your NoSQL database by specifying the child you want to observe for, and what type of observation you want
        // let's observe a single event (query the database once)
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            // snapshot has a value property that can be optional if it doesn't exist
            
            guard snapshot.value as? String != nil else {
                // otherwise... let's create the account
                completion(false)
                return
            }
            
            // if we are able to do this, that means the email exists already!
            
            completion(true) // the caller knows the email exists already
            
        }
    }
    
    /// Insert new user to database
    public func insertUser(with user: ChatAppUser, completion: @escaping (Bool) -> Void){
        // adding completion block here so once it's done writing to database, we want to upload the image
        
        // once user object is creatd, also append it to the user's collection
        database.child(user.safeEmail).setValue(["first_name":user.firstName,"last_name":user.lastName]) { error, _ in
            guard error  == nil else {
                print("failed to write to database")
                completion(false)
                return
            }
            
            self.database.child("users").observeSingleEvent(of: .value) { snapshot in
                // snapshot is not the value itself
                if var usersCollection = snapshot.value as? [[String: String]] {

                    // if var so we can make it mutable so we can append more contents into the array, and update it
                    // append to user dictionary
                    let newElement = [
                        "name": user.firstName + " " + user.lastName,
                        "email": user.safeEmail
                    ]
                    usersCollection.append(newElement)
                    
                    self.database.child("users").setValue(usersCollection) { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    }
                    
                }else{
                    // create that array
                    let newCollection: [[String: String]] = [
                        [
                            "name": user.firstName + " " + user.lastName,
                            "email": user.safeEmail
                        ]
                    ]
                    self.database.child("users").setValue(newCollection) { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    }
                }
            }
        }
    }
    
    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void){
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
            
        }
    }
    
    public enum DatabaseError: Error {
        case failedToFetch
    }
    
    
    
    
}
struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    var profilePictureUrl: String{
        return "\(safeEmail)_profile_picture.png"
    }
    
    // create a computed property safe email
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
