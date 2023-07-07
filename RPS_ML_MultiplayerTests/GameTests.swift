//
//  GameTests.swift
//  RPS_ML_MultiplayerTests
//
//  Created by Jakub Ruranski on 06/07/2023.
//

import XCTest
@testable import RPS_ML_Multiplayer

final class GameTests: XCTestCase {

    var sut: GameViewModel!

        override func setUp() {
            super.setUp()
            sut = GameViewModel()
        }

        override func tearDown() {
            sut = nil
            super.tearDown()
        }

        func testMoveFromString() {
            XCTAssertEqual(sut.moveFromString("Rock"), .rock)
            XCTAssertEqual(sut.moveFromString("Paper"), .paper)
            XCTAssertEqual(sut.moveFromString("Scissors"), .scissors)
            XCTAssertEqual(sut.moveFromString("invalid"), .none)
        }

        func testSetMove() {
            sut.setMove(playerMove: "Rock")
            XCTAssertEqual(sut.game.playerMove, .rock)
        }

        func testResolveRound() {
            
            sut.game.enemyMove = .rock
            sut.resolveRound(playerMove: .rock)
            XCTAssertEqual(sut.game.rounds, 1)
            XCTAssertEqual(sut.roundResult, .draw)
            
            sut.game.enemyMove = .scissors
            sut.resolveRound(playerMove: .rock)
            XCTAssertEqual(sut.game.rounds, 2)
            XCTAssertEqual(sut.roundResult, .player)
            XCTAssertEqual(sut.game.playerScore, 1)
            
            sut.game.enemyMove = .paper
            sut.resolveRound(playerMove: .rock)
            XCTAssertEqual(sut.game.rounds, 3)
            XCTAssertEqual(sut.roundResult, .enemy)
            XCTAssertEqual(sut.game.enemyScore, 1)
        }
    
    func testResolveRoundPlayerMoveNone() {
        sut.game.enemyMove = .rock
        sut.resolveRound(playerMove: .none)
        XCTAssertEqual(sut.game.rounds, 1)
        XCTAssertEqual(sut.roundResult, .none)
    }

    func testResolveRoundEnemyMoveNone() {
        sut.game.enemyMove = .none
        sut.resolveRound(playerMove: .rock)
        XCTAssertEqual(sut.game.rounds, 1)
        XCTAssertEqual(sut.roundResult, .none)
        XCTAssertEqual(sut.game.playerScore, 0)
    }

    func testResolveRoundBothMoveNone() {
        sut.game.enemyMove = .none
        sut.resolveRound(playerMove: .none)
        XCTAssertEqual(sut.game.rounds, 1)
        XCTAssertEqual(sut.roundResult, .none)
    }

    func testResolveRoundSameMoveTwice() {
        sut.game.enemyMove = .scissors
        sut.resolveRound(playerMove: .scissors)
        XCTAssertEqual(sut.game.rounds, 1)
        XCTAssertEqual(sut.roundResult, .draw)

        sut.game.enemyMove = .scissors
        sut.resolveRound(playerMove: .scissors)
        XCTAssertEqual(sut.game.rounds, 2)
        XCTAssertEqual(sut.roundResult, .draw)
    }

    func testResolveRoundConsecutiveWinsPlayer() {
        sut.game.enemyMove = .scissors
        sut.resolveRound(playerMove: .rock)
        XCTAssertEqual(sut.game.rounds, 1)
        XCTAssertEqual(sut.roundResult, .player)
        XCTAssertEqual(sut.game.playerScore, 1)

        sut.game.enemyMove = .scissors
        sut.resolveRound(playerMove: .rock)
        XCTAssertEqual(sut.game.rounds, 2)
        XCTAssertEqual(sut.roundResult, .player)
        XCTAssertEqual(sut.game.playerScore, 2)
    }
    
    

        func testGameOver() {
            // Assume max score to win is 2
            sut.game.playerScore = 3
            sut.game.enemyScore = 0
            sut.calculateRound()
            XCTAssertTrue(sut.isGameOver)
            XCTAssertEqual(sut.endRoundTitle, "You Won!")
            XCTAssertEqual(sut.endRoundImageName, "checkmark")
        }
    
    
    func testGameOverPlayerWin() {
        // Assume max score to win is 3 and player should lead by 2
        sut.game.playerScore = 3
        sut.game.enemyScore = 1
        sut.calculateRound()
        XCTAssertTrue(sut.isGameOver)
        XCTAssertEqual(sut.endRoundTitle, "You Won!")
        XCTAssertEqual(sut.endRoundImageName, "checkmark")
    }

    func testGameOverEnemyWin() {
        // Assume max score to win is 3 and enemy should lead by 2
        sut.game.playerScore = 1
        sut.game.enemyScore = 3
        sut.calculateRound()
        XCTAssertTrue(sut.isGameOver)
        XCTAssertEqual(sut.endRoundTitle, "Enemy Won...")
        XCTAssertEqual(sut.endRoundImageName, "xmark")
    }

    func testGameOverNoWinnerYet() {
        // Assume max score to win is 3 and the player and enemy are tied
        sut.game.playerScore = 2
        sut.game.enemyScore = 2
        sut.calculateRound()
        XCTAssertFalse(sut.isGameOver)
    }

    func testGameOverPlayerAlmostWin() {
        // Assume max score to win is 3 and player has 3 but enemy has 2
        sut.game.playerScore = 3
        sut.game.enemyScore = 2
        sut.calculateRound()
        XCTAssertFalse(sut.isGameOver)
    }

    func testGameOverEnemyAlmostWin() {
        // Assume max score to win is 3 and enemy has 3 but player has 2
        sut.game.playerScore = 2
        sut.game.enemyScore = 3
        sut.calculateRound()
        XCTAssertFalse(sut.isGameOver)
    }
    
    func testGameOverEnemyToughWin() {
        // Assume max score to win is 3 and enemy should lead by 2
        sut.game.playerScore = 2
        sut.game.enemyScore = 4
        sut.calculateRound()
        XCTAssertTrue(sut.isGameOver)
        XCTAssertEqual(sut.endRoundTitle, "Enemy Won...")
        XCTAssertEqual(sut.endRoundImageName, "xmark")
    }

}
