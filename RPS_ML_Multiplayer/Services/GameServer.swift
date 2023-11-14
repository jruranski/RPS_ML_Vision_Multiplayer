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
    
    
    var isPlayerCreator: Bool = true
    
    private var gameId: String?
    
    init(ref: DatabaseReference, user: User) {
        self.ref = ref
        self.user = user
    }
    
    init(ref: DatabaseReference, user: User?, opponent: Opponent?) {
        self.ref = ref
        self.user = user
        self.opponent = opponent
        self.isPlayerCreator = true
    }
    
    init(ref: DatabaseReference, user: User?, game: GameModel) {
        self.ref = ref
        self.user = user
        self.opponent = game.opponent
        self.gameId = game.gameID
        self.isPlayerCreator = false
    }
    
    
    func createNewGame(opponent: Opponent) -> GameModel? {
        guard let ref = ref else {return nil}
        guard let user = user else {return nil}
        guard gameId == nil else {return nil}
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
            player1 : 0,
            player2 : 0,
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
    
    
    func listenForTurnOfChange(gameID: String, completion: @escaping (Winner?) -> Void) {
        guard let ref = self.ref else { return }
        guard let user = self.user else {return}
        
        ref.child("games").child(gameID).child("turnOf").observe(.value) { snapshot in
            print("my id  \(user.uid)")
            guard let turnOfValue = snapshot.value as? String,
                  let turnOf: Winner = turnOfValue == user.uid ? .player : .enemy

            else {
                print("Error observing turnOf changes")
                completion(nil)
                return
            }
            completion(turnOf)
        }
    }
    
    func listenForScoreChange(game: GameModel, completion: @escaping (Int?) -> Void) {
        guard let ref = self.ref else { return }
        guard let user = self.user else {return}
        
        ref.child("games").child(game.gameID).child(user.uid).observe(.value) { snapshot in
            guard let newScore = snapshot.value as? Int,
                  newScore != game.playerScore
                 
            else {
                print("Error observing turnOf changes")
                completion(nil)
                return
            }
            completion(newScore)
        }
    }
    
    func listenForEnemyScoreChange(game: GameModel, completion: @escaping (Int?) -> Void) {
        guard let ref = self.ref else { return }
      //  guard let user = self.user else {return}
        guard let opponentID = game.opponent.id else {return}
        
        
        ref.child("games").child(game.gameID).child(opponentID).observe(.value) { snapshot in
            guard let newScore = snapshot.value as? Int,
                    newScore != game.enemyScore
                 
            else {
                print("Error observing turnOf changes")
                completion(nil)
                return
            }
            completion(newScore)
        }
    }
    
    
    // fetch the current state of game from the database and convert turnOf to Winner
    func fetchCurrentGameState(gameToUpdate: GameModel) {
        guard let ref = ref else {return}
        guard let user = user else {return}
        
        let gameRef = ref.child("games").child(gameToUpdate.gameID)
        gameRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            let turnOf = value?["turnOf"] as? String ?? ""
            let finished = value?["finished"] as? Bool ?? false
            let winner = value?["winner"] as? String ?? ""
            let creator = value?["creator"] as? String ?? ""
            let invited = value?["invited"] as? String ?? ""
            let moves = value?["moves"] as? [String: [String: Any]] ?? [:]
            
            let otherID = creator == user.uid ? invited : creator
            
            let playerScore = value?[user.uid] as? Int ?? 0
            
            self.isPlayerCreator = creator == user.uid
            
            let enemyScore = value?[otherID] as? Int ?? 0
            var movesArray: [PlayerMove] = []
            for (moveID, moveData) in moves {
                if let playerID = moveData["player"] as? String,
                   let moveString = moveData["move"] as? String,
                   let move = Move(rawValue: moveString) {
                    let playerMove = PlayerMove(moveID: Int(moveID) ?? 0, move: move, playerID: playerID)
                    movesArray.append(playerMove)
                }
            }
            
            movesArray.sort(by: { $0.moveID < $1.moveID })
            
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

    func fetchCurrentGameState(gameToUpdate: GameModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let ref = ref, let user = user else {
            completion(.failure(EmptyServer.noRefOrUser)) // Replace with an appropriate error
            return
        }

        let gameRef = ref.child("games").child(gameToUpdate.gameID)
        gameRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            
            
            let turnOf = value?["turnOf"] as? String ?? ""
            let finished = value?["finished"] as? Bool ?? false
            let winner = value?["winner"] as? String ?? ""
            let creator = value?["creator"] as? String ?? ""
            let invited = value?["invited"] as? String ?? ""
            let moves = value?["moves"] as? [String: [String: Any]] ?? [:]
            
            let otherID = creator == user.uid ? invited : creator
            
            let playerScore = value?[user.uid] as? Int ?? 0
            
            self.isPlayerCreator = creator == user.uid
            
            let enemyScore = value?[otherID] as? Int ?? 0
            var movesArray: [PlayerMove] = []
            for (moveID, moveData) in moves {
                if let playerID = moveData["player"] as? String,
                   let moveString = moveData["move"] as? String,
                   let move = Move(rawValue: moveString) {
                    let playerMove = PlayerMove(moveID: Int(moveID) ?? 0, move: move, playerID: playerID)
                    movesArray.append(playerMove)
                }
            }
            
            movesArray.sort(by: { $0.moveID < $1.moveID })
            
            gameToUpdate.playerScore = playerScore
            gameToUpdate.enemyScore = enemyScore
            gameToUpdate.turnOf = turnOf == user.uid ? .player : .enemy
            gameToUpdate.finished = finished
            gameToUpdate.winner = .none
            gameToUpdate.player1 = creator
            gameToUpdate.player2 = invited
            gameToUpdate.moves = movesArray
           

            completion(.success(()))
        }) { (error) in
            print(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
    func updateGame(game: GameModel, move: Move) {
        guard let ref = ref else {return}
        guard let user = user else {return}
        
       // let id = game.opponent.id == user.uid ? user.id :
        
        let gameRef = ref.child("games").child(game.gameID)
        let gameData: [String: Any] = [
            user.uid : game.playerScore,
            game.opponent.id ?? game.player2 : game.enemyScore,
            "turnOf" : game.turnOf == .player ? user.uid : opponent?.id ?? "id_fault",
            "finished" : game.finished
        ]
        print("updating and adding move: \(move.rawValue)")
        addMove(game: game, playerID: user.uid, move: move)
        
        print("updating the ")
        
        gameRef.updateChildValues(gameData)
    }
    
    
    func observeMoves(gameID: String, completion: @escaping ([PlayerMove]) -> Void) {
        guard let ref = ref else {return}
        // Create a reference to the game's moves
        let movesRef = ref.child("games").child(gameID).child("moves")
        
        // Set up observer for any changes to the "moves" node
        movesRef.observe(.value, with: { snapshot in
            var moves: [PlayerMove] = []
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let moveData = childSnapshot.value as? [String: Any],
                   let playerID = moveData["player"] as? String,
                   let moveString = moveData["move"] as? String,
                   let move = Move(rawValue: moveString) {
                    let playerMove = PlayerMove(moveID: Int(childSnapshot.key) ?? 123, move: move, playerID: playerID)
                    moves.append(playerMove)
                }
            }
            
            // Sort moves by moveID
            moves.sort(by: { $0.moveID < $1.moveID })
            
            // Pass the updated moves array to the completion handler
            completion(moves)
        }) { error in
            print("Error observing moves: \(error.localizedDescription)")
        }
    }

    
    
    
    
    func saveFinishedGame(game: GameModel) {
        guard let ref = ref else {return}
        guard let user = user else {return}
        
       // let id = game.opponent.id == user.uid ? user.id :
        
        let winner = game.winner
        
        let gameRef = ref.child("games").child(game.gameID)
        let gameData: [String: Any] = [
            user.uid : game.playerScore,
            game.opponent.id ?? game.player2 : game.enemyScore,
            "turnOf" : game.turnOf == .player ? user.uid : opponent?.id ?? "id_fault",
            "finished" : true,
            "winner": winner == .player ? user.uid : game.opponent.id
            
            
        ]
        //addMove(game: game, playerID: user.uid, move: move)
        
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
        let lastID = game.moves.last?.moveID ?? 0
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



enum EmptyServer: Error {
    case noRefOrUser
}
