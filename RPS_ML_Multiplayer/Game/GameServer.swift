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
    var opponent: Opponent?
    
    
    
    private var gameId: String?
    
    init(ref: DatabaseReference, user: User) {
        self.ref = ref
        self.user = user
    }
    
    init(ref: DatabaseReference, user: User?, opponent: Opponent?) {
        self.ref = ref
        self.user = user
        self.opponent = opponent
    }
    
    init(ref: DatabaseReference, user: User?, game: GameModel) {
        self.ref = ref
        self.user = user
        self.opponent = game.opponent
        self.gameId = game.gameID
    }
    
    
    func createNewGame(opponent: Opponent) -> GameModel? {
        guard let ref = ref else {return nil}
        guard let user = user else {return nil}
        let currentDate = Date()
        let currentDateInSeconds: Int = Int(currentDate.timeIntervalSince1970)
        print(currentDateInSeconds)
        let uid = UUID().uuidString
        let player1 = user.uid
        let player2 = opponent.id ?? "no_id"
        let gameData: [String: Any] = [
            "created" : currentDateInSeconds,
            "finished" : false,
            "uid" : uid,
//            "moves": [], // Initialize moves as an empty array
            "participants": [player1, player2],
            "creator": player1,
            "invited": player2,
            "winner": "",
            "playerScore" : 0,
            "enemyScore" : 0,
            "turnOf" : player1
        ]

    ref.child("games").child(uid).setValue(gameData) { error, _ in
        if let error = error {
            print("Data could not be saved: \(error).")
        } else {
            print("Data saved successfully!")
        }
    }
        gameId = uid
        
        print("created a new game \(String(describing: gameId))")

        return GameModel(player1: player1, player2: player2, gameID: uid, opponent: opponent, turnOf: .player)
            
    }
    
    // fetch the current state of game from the database and convert turnOf to Winner
    func fetchCurrentGameState(gameToUpdate: GameModel) {
        guard let ref = ref else {return}
        guard let user = user else {return}
        
        let gameRef = ref.child("games").child(gameToUpdate.gameID)
        gameRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let playerScore = value?["playerScore"] as? Int ?? 0
            let enemyScore = value?["enemyScore"] as? Int ?? 0
            let turnOf = value?["turnOf"] as? String ?? ""
            let finished = value?["finished"] as? Bool ?? false
            let winner = value?["winner"] as? String ?? ""
            let creator = value?["creator"] as? String ?? ""
            let invited = value?["invited"] as? String ?? ""
            let moves = value?["moves"] as? [String: [String: Any]] ?? [:]
            var movesArray: [PlayerMove] = []
            for (moveID, moveData) in moves {
                if let playerID = moveData["player"] as? String,
                   let moveString = moveData["move"] as? String,
                   let move = Move(rawValue: moveString) {
                    let playerMove = PlayerMove(moveID: Int(moveID) ?? 123, move: move, playerID: playerID)
                    movesArray.append(playerMove)
                }
            }
            
            gameToUpdate.playerScore = playerScore
            gameToUpdate.enemyScore = enemyScore
            gameToUpdate.turnOf = turnOf == user.uid ? .player : .enemy
            gameToUpdate.finished = finished
            gameToUpdate.winner = .none
            gameToUpdate.player1 = creator
            gameToUpdate.player2 = invited
            gameToUpdate.moves = movesArray
        }) { (error) in
            print(error.localizedDescription)
        }
    }


    
    func updateGame(game: GameModel, move: Move) {
        guard let ref = ref else {return}
        guard let user = user else {return}
        
        let gameRef = ref.child("games").child(game.gameID)
        let gameData: [String: Any] = [
            "playerScore" : game.playerScore,
            "enemyScore" : game.enemyScore,
            "turnOf" : game.turnOf == .player ? user.uid : opponent?.id ?? "id_fault",
            "finished" : game.finished
        ]
        addMove(game: game, playerID: user.uid, move: move)
        
        print("updating the ")
        
        gameRef.updateChildValues(gameData)
    }
    
    func getLastMove(game: GameModel) -> PlayerMove? {
        fetchCurrentGameState(gameToUpdate: game)
        return game.moves.last
    }
    
//
//    func addMove(game: GameModel, playerID: String, move: Move) {
//        guard let ref = ref else {return}
//        let playerMove = PlayerMove(move: move, playerID: playerID)
//        game.moves.append(playerMove)
//
//        // Update the game in Firebase
//        let gameRef = ref.child("games").child(game.gameID)
//        gameRef.updateChildValues(["moves": game.moves])
//    }
    
    
    // use this one
    func addMove(game: GameModel, playerID: String, move: Move) {
        guard let ref = ref else {return}
      //  guard let user = user else {return}
        guard move != .none else {return}
        let lastID = game.moves.last?.moveID ?? 124
        let playerMove = PlayerMove(moveID: lastID + 1, move: move, playerID: playerID)
        game.moves.append(playerMove)
        
        let moveData: [String : Any] = [
            "move" : move.rawValue,
            "player" : playerID
            
        ]
        
        ref.child("games").child(game.gameID).child("moves").child(String(playerMove.moveID)).setValue(moveData) { error, ref in
                if let error = error {
                    print("Error saving move data \(error.localizedDescription)")
                } else {
                    print("Saved move data successfully")
                }
            }
    }
    
    
    func fetchMoves(gameID: String, completion: @escaping ([PlayerMove]) -> Void) {
        guard let ref = self.ref else { return }

        ref.child("games").child(gameID).child("moves").observeSingleEvent(of: .value) { (snapshot) in
            var moves: [PlayerMove] = []

            for child in snapshot.children {
                guard let childSnapshot = child as? DataSnapshot,
                      let moveData = childSnapshot.value as? [String: Any],
                      let moveRawValue = moveData["move"] as? String,
                      let move = Move(rawValue: moveRawValue),
                      let playerID = moveData["player"] as? String
                else {
                    print("Error while fetching moves")
                    continue
                }
                
                guard let moveID = Int(childSnapshot.key) else {
                    print("Error converting move ID to Int")
                    continue
                }

                let playerMove = PlayerMove(moveID: moveID, move: move, playerID: playerID)
                moves.append(playerMove)
            }

            // Return the moves sorted by moveID
            completion(moves.sorted(by: { $0.moveID < $1.moveID }))
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
