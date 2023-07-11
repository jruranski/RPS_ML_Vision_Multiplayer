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
    var user: User?

    private var gameId: String?
    
    init(ref: DatabaseReference, user: User) {
        self.ref = ref
        self.user = user
    }
    
    
    func createNewGame() {
        guard let ref = ref else {return}
        guard let user = user else {return}
        let currentDate = Date()
        let currentDateInSeconds: Int = Int(currentDate.timeIntervalSince1970)
        print(currentDateInSeconds)
        let player1 = "ee"
        let player2 = ""
        let gameData: [String: Any] = [
            "created" : currentDateInSeconds,
            "finished" : false,
            "uid" : UUID().uuidString,
             "moves": [], // Initialize moves as an empty array
            "participants": [player1, player2],
            player1: [player1: true],
            player2: [player2: true],
            "winner": ""
        ]

    ref.child("games").child(gameId!).setValue(gameData) { error, _ in
        if let error = error {
            print("Data could not be saved: \(error).")
        } else {
            print("Data saved successfully!")
        }
    }

    }
    
    func addMove(move: Move) {
        guard let ref = ref else {return}
        guard let user = user else {return}
        
        let moveData: [String: Any] = [
            "move" : move.rawValue,
            "player" : user.uid,
            "timestamp" : ServerValue.timestamp()
        ]
        
        ref.child("games").child("moves").childByAutoId().setValue(moveData) {error, ref in
            if let error = error {
                print("Error saving move data \(error.localizedDescription)")
            }else{
                print("Saved move data successfully")
            }
        }
    }
    
}

