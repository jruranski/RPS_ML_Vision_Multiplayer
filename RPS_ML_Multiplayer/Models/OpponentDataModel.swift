//
//  OpponentDataModel.swift
//  RPS_ML_Multiplayer
//
//  Created by Jakub Ruranski on 06/07/2023.
//

import Foundation


class Opponent {
    
    var name = "AI"
    var id: String?
    var move: Move = .none
    var isOnline: Bool = false
    
    init(name: String = "AI", id: String? = nil, move: Move) {
        self.name = name
        self.id = id
        self.move = move
    }
    
    init(name: String, uid: String?, isOnline: Bool) {
        self.name = name
        self.id = uid
        self.move = .none
        self.isOnline = isOnline
    }
    
    init() {
        
    }
    
    func fetchCurrentMove() {
        #if DEBUG
        move = generateEnemyMove()
        #endif
    }
    
    // Generate random move if enemy does not answer in time
    private func generateEnemyMove() -> Move {
        let moves: [Move] = [.rock, .paper, .scissors]
        let randomIndex = Int.random(in: 0..<moves.count)
        return moves[randomIndex]
    }
    
    func connect() {
        
    }
    
    
    
    func sendPlayerMove(playerMove: Move) {
        
    }
    
}
