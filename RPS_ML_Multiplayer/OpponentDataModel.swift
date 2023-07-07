//
//  OpponentDataModel.swift
//  RPS_ML_Multiplayer
//
//  Created by Jakub Ruranski on 06/07/2023.
//

import Foundation


class OpponentModel {
    
    var name = "AI"
    var id: UUID?
    var move: Move = .none
    
    init(name: String = "AI", id: UUID? = nil, move: Move) {
        self.name = name
        self.id = id
        self.move = move
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
