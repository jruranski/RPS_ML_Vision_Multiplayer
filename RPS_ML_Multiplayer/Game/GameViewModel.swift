//
//  GameViewModel.swift
//  RPS_ML_Multiplayer
//
//  Created by Jakub Ruranski on 06/07/2023.
//

import Foundation


class GameViewModel: ObservableObject {
    @Published var game: GameModel
    
    @Published var opponent: Opponent
    
    @Published var isGameOver = false
    @Published var endRoundTitle = "Draw"
    @Published var endRoundImageName = "xmark"
    @Published var roundResult: Winner = .none
    @Published var enemyMoveString = "Paper"
    @Published var gameFinished = false
    
    @Published var gameStateDescription = "Waiting for other player"
    
    @Published var timerText = "0"
    
    var gameServer: GameServer? = nil
    
    init() {
//        gameServer = GameServer(ref: , user: <#T##User#>)
        game = GameModel()
        opponent = Opponent()
    }
    
    init(serverManager: ServerManager, opponent: Opponent) {
       let gameServer = GameServer(ref: serverManager.passDbReference(), user: serverManager.getCurrentUser(), opponent: opponent )
         let game = gameServer.createNewGame(opponent: opponent)
        self.game = game ?? GameModel()
        self.gameServer = gameServer
        self.opponent = opponent
        
       
        
    }
    
    
    init(serverManager: ServerManager, game: GameModel) {
        self.opponent = game.opponent
        let gameServer = GameServer(ref: serverManager.passDbReference(), user: serverManager.getCurrentUser(), game: game )
    
        self.game = game
        self.gameServer = gameServer
      
        
       
        
    }
    
    func resolveRound(playerMove: Move) {
        
        
        if game.turnOf == .player {
           
            game.playerMove = playerMove
            
            //  if game.enemyMove == .none {   game.enemyMove = generateEnemyMove() } // prototyping
            
            // wait or fetch the enemy move
            
            //then
           
            game.turnOf = .enemy
          //  calculateRound()
            gameServer?.updateGame(game: game, move: playerMove)
            let startTime = Date().timeIntervalSince1970
            
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let self = self else {return}
                    var enemyMoved = false
                    while !enemyMoved {
                        gameServer?.fetchMoves(gameID: self.game.gameID) { moves in
                            if let latestMove = moves.last, latestMove.playerID == self.game.opponent.id {
                                enemyMoved = true
                                
                                // enemy has made a move
                                self.game.enemyMove = latestMove.move
                             
                              
                                
                                let endTime = Date().timeIntervalSince1970  // end timer
                                print("Time elapsed: \(endTime - startTime) seconds.")
                                
                                self.calculateRound()
                                DispatchQueue.main.async {
                                    self.enemyMoveString = self.game.enemyMove.rawValue
                                    self.isGameOver = true
                                    self.timerText = "\(endTime - startTime)"
                                }
                                self.gameServer?.updateGame(game: self.game, move: .none)
                            }else {
                                DispatchQueue.main.async {
                                    let endTime = Date().timeIntervalSince1970
                                    self.timerText = "\(endTime - startTime)"
                                }
                            }
                        }
                        
                        // Avoid overwhelming the server with requests
                        sleep(2)
                    }
                }
            
            
        }else if game.turnOf == .enemy {
            // wait
            
            gameStateDescription = "Wait until the enemy has made a move!"
            
        //    gameServer?.updateGame(game: game, move: .none)
            
            
        }
    }
    
    func fetchEnemyMove() {
        opponent.fetchCurrentMove()
        game.enemyMove = opponent.move
    }
    
    func nextRound() {
        game.playerMove = .none
        game.enemyMove = .none
        game.rounds += 1
        
        
        isGameOver = false
    }
    
    
    // Generate random move if enemy does not answer in time
    private func generateEnemyMove() -> Move {
        let moves: [Move] = [.rock, .paper, .scissors]
        let randomIndex = Int.random(in: 0..<moves.count)
        return moves[randomIndex]
    }
    
    // Compare two moves to determine the winner
    internal func compareMoves() -> Winner {
        
        // check whether it's not a draw or failed to play
        guard game.playerMove != .none && game.enemyMove != .none else {return .none}
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
            endRoundTitle = "Round won!"
            endRoundImageName = "trophy.circle"
        }else if winner == .enemy {
            game.enemyScore += 1
            
            endRoundTitle = "Round lost..."
            endRoundImageName =  "xmark.seal"
        }else {
            
            endRoundTitle = "Draw"
            endRoundImageName = "repeat.circle"
        }
        
        roundResult = winner
        
        let champion = game.getGameWinner() // get the winner of the whole game
        
        if champion != .none {gameOver(champion: champion);return}
        
        
        
        // reset the moves
//        game.playerMove = .none
//        game.enemyMove = .none
//
        
        
    }
    
    private func gameOver(champion: Winner) {
        gameFinished = true
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
    
    internal func moveToString(_ move: Move) -> String {
        return ""
    }
    
    // Sets the player's move from the provided String
    public func setMove(playerMove: String) {
        game.playerMove = Move(rawValue: playerMove) ?? .none
    }
    
    
}
