//
//  GameViewModel.swift
//  RPS_ML_Multiplayer
//
//  Created by Jakub Ruranski on 06/07/2023.
//

import Foundation


class GameViewModel: ObservableObject {
    @Published var game = GameModel()
    @Published var isGameOver = false
    @Published var endRoundTitle = "Draw"
    @Published var endRoundImageName = "xmark"
    @Published var roundResult: Winner = .none
    
    func resolveRound(playerMove: Move) {
        game.rounds += 1
        game.playerMove = playerMove
        if game.enemyMove == nil {   game.enemyMove = generateEnemyMove() } // prototyping
        calculateRound()
    }
    
    // Generate random move if enemy does not answer in time
    private func generateEnemyMove() -> Move {
        let moves: [Move] = [.rock, .paper, .scissors]
        let randomIndex = Int.random(in: 0..<moves.count)
        return moves[randomIndex]
    }
    
    // Compare two moves to determine the winner
    private func compareMoves() -> Winner {
        
        // check whether it's not a draw or failed to play
        guard game.playerMove != .none else {return .none}
        guard game.playerMove != game.enemyMove else { return .draw}
        
        // calculate other options
        var winner: Winner = .draw
        
        if game.playerMove == .rock { winner = game.enemyMove == .scissors ? .player : .enemy }
        else if game.playerMove == .paper { winner = game.enemyMove == .rock ? .player : .enemy }
        else if game.playerMove == .scissors { winner = game.enemyMove == .paper ? .player : .enemy }
        
        
        return winner
    }
    
    func calculateRound() {
        let winner = compareMoves()
        
        if winner == .player {
            game.playerScore += 1
                // add info for user about the outcome
        }else if winner == .enemy {
            game.enemyScore += 1
            
        }
        
        roundResult = winner
        
        let champion = game.getGameWinner() // get the winner of the whole game
        
        if champion != .none {gameOver(champion: champion);return}
        
        
        
        // reset the moves
        game.playerMove = .none
        game.enemyMove = .none
        
        
        
    }
    
    private func gameOver(champion: Winner) {
        isGameOver = true
        let playerWon = champion == .player
        endRoundTitle = playerWon ? "You Won!" : "Enemy Won..."
        endRoundImageName = playerWon ? "checkmark" : "xmark"
        
        // save game
        
        // exit the game
        
        
    }
    
    // convert string to Move
    internal func moveFromString(_ move: String) -> Move {
        switch move.lowercased() {
        case "rock":
            return .rock
        case "paper":
            return .paper
        case "scissors":
            return .scissors
        default:
            return .none
        }
    }
    
    // Sets the player's move from the provided String
    public func setMove(playerMove: String) {
        game.playerMove = moveFromString(playerMove)
    }
    
    
}
