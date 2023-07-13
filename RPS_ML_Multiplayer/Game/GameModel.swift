//
//  GameModel.swift
//  RPS_ML_Multiplayer
//
//  Created by Jakub Ruranski on 06/07/2023.
//

import Foundation


class GameModel {
    var rounds = 0
    var playerScore = 0
    var enemyScore = 0
    var playerMove: Move = .none
    var enemyMove: Move = .none
    var winner: Winner = .none
    
    // player ids from database
    var player1: String = ""
    var player2: String = ""
    
    var gameID: String = ""
    
    var finished: Bool = false
    
    var opponent: Opponent = Opponent()
    
    var moves: [PlayerMove] = []
    
    let maxScore = 3
    

    var turnOf: Winner = .player
    
    
    init() {
        print("initializing gamemodel")
    }
    
    convenience init?(from dict: [String: Any], id: String, opponentID: String, opponentName: String) {
        guard case let gameData = dict["participants"] as? [String], let player1 = gameData?[0] as? String,
              let player2 = gameData?[1] as? String
               
           
        else {
            print("not enought participants! Failed to load GameModel")
            return nil
        }
//        let opponentName = dict["opponentName"] as? String
        let opponent = Opponent(name: opponentName, uid: opponentID, isOnline: true)
      //  let rounds = dict["rounds"] as? Int ?? 0
        let userID = player1 != opponentID ? player1 : player2
        let otherID = player1 == opponentID ? player1 : player2
        let playerScore = dict[userID] as? Int ?? 0
        let enemyScore = dict[otherID] as? Int ?? 0
        let finished = dict["finished"] as? Bool ?? false
       // let roundHistory = dict["move"] as? [PlayerMove] ?? []  // You'll need to map this properly
        var roundHistory: [PlayerMove] = []
        if let movesDict = dict["moves"] as? [String: [String: Any]] {
            for (moveID, moveData) in movesDict {
                if let playerID = moveData["player"] as? String,
                   let moveString = moveData["move"] as? String,
                   let move = Move(rawValue: moveString) {
                    let playerMove = PlayerMove(moveID: Int(moveID) ?? 123, move: move, playerID: playerID)
                    roundHistory.append(playerMove)
                }
            }
        }
        let turnOf = dict["turnOf"] as? String
        let currentTurn: Winner = turnOf == opponentID ? .enemy : .player
        self.init(
            rounds: 0,
            playerScore: playerScore,
            enemyScore: enemyScore,
            player1: player1,
            player2: player2,
            gameID: id,
            finished: finished,
            opponent: opponent,
            roundHistory: roundHistory,
            turnOf: currentTurn
        )
    }
    
    init(
        rounds: Int = 0,
        playerScore: Int = 0,
        enemyScore: Int = 0,
        playerMove: Move = .none,
        enemyMove: Move = .none,
        winner: Winner = .none,
        player1: String,
        player2: String,
        gameID: String,
        finished: Bool = false,
        opponent: Opponent,
        roundHistory: [PlayerMove] = [],
        turnOf: Winner
    ) {
        self.rounds = rounds
        self.playerScore = playerScore
        self.enemyScore = enemyScore
        self.playerMove = playerMove
        self.enemyMove = enemyMove
        self.winner = winner
        self.player1 = player1
        self.player2 = player2
        self.gameID = gameID
        self.finished = finished
        self.opponent = opponent
        self.moves = roundHistory
        self.turnOf = turnOf
    }
    
    func getGameWinner() -> Winner {
        if playerScore >= maxScore && playerScore - enemyScore >= 2 {
            return .player
        } else if enemyScore >= maxScore && enemyScore - playerScore >= 2 {
            return .enemy
        }
        return .none
    }
    
    
    
    func calculateScores() {
        // Reset scores to zero before calculation
        playerScore = 0
        enemyScore = 0
        print("current moves: \(moves.debugDescription)")
        print("number of moves: \(moves.count)")
        // Buffer to hold a pair of moves
        var playerMove: Move? = nil
        var enemyMove: Move? = nil
        let userID = player1 == opponent.id ? player2 : player1
        // Iterate over moves array
        for move in moves {
            // Check the playerID of the move to determine the move ownership
            if move.playerID == userID {
                playerMove = move.move
            } else if move.playerID == opponent.id {
                enemyMove = move.move
            }

            // If we have both player's and enemy's moves, score the round
            if let playerMoveUnwrapped = playerMove, let enemyMoveUnwrapped = enemyMove {
                switch (playerMoveUnwrapped, enemyMoveUnwrapped) {
                case (.rock, .scissors), (.scissors, .paper), (.paper, .rock):
                    playerScore += 1
                case (.rock, .paper), (.scissors, .rock), (.paper, .scissors):
                    enemyScore += 1
                default:
                    // In case of a draw, no points are awarded
                    continue
                }

                // Reset moves to nil after scoring
                playerMove = nil
                enemyMove = nil
            }
        }
    }

    
    
    
}


struct PlayerMove {
    var moveID: Int = 0
    var roundNumber = 0
   // var player: Winner
    var move: Move
    var playerID: String
    
}

enum Move: String {
    case rock = "Rock"
    case paper = "Paper"
    case scissors = "Scissors"
    case none = ""
}

enum Winner {
    case player
    case enemy
    case draw
    case none
}
