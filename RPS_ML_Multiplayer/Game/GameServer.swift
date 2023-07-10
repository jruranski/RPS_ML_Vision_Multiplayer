//
//  GameServer.swift
//  RPS_ML_Multiplayer
//
//  Created by Jakub Ruranski on 10/07/2023.
//

import Foundation
import FirebaseCore
import Firebase

class GameServer {
    
    private var ref: DatabaseReference?
    
    
    init(ref: DatabaseReference) {
        self.ref = ref
    }
    
    
}

