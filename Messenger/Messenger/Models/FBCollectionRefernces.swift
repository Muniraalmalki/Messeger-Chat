//
//  FBCollectionRefernces.swift
//  Messenger
//
//  Created by munira almallki on 25/03/1443 AH.
//

import Foundation
import FirebaseDatabase

enum FBCollectionReference: String {
     case User
}

func reference(_ colectionReference: FBCollectionReference) -> CollectionDifference{
    return Firestore.firestore().collection(CollectionDifference.rawValue)
}
