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
    
    var roundHistory: [RoundResult] = []
    
    let maxScore = 3
    
    init() {
        print("initializing gamemodel")
    }
    
    func getGameWinner() -> Winner {
        if playerScore >= maxScore && playerScore - enemyScore >= 2 {
            return .player
        } else if enemyScore >= maxScore && enemyScore - playerScore >= 2 {
            return .enemy
        }
        return .none
    }
    
    
}


struct RoundResult {
    var roundNumber = 0
    var winner: Winner
    var winningMove: Move
    
    
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
