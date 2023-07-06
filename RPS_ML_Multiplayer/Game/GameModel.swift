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
    
    private let maxScore = 3
    
    func getGameWinner() -> Winner {
        if playerScore >= maxScore && playerScore - enemyScore >= 2 {
            return .player
        } else if enemyScore >= maxScore && enemyScore - playerScore >= 2 {
            return .enemy
        }
        return .none
    }
    
    
}

enum Move {
    case rock
    case paper
    case scissors
    case none
}

enum Winner {
    case player
    case enemy
    case draw
    case none
}
