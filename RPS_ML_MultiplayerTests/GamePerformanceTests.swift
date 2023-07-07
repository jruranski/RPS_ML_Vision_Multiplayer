//
//  GamePerformanceTests.swift
//  RPS_ML_MultiplayerTests
//
//  Created by Jakub Ruranski on 06/07/2023.
//

import XCTest
@testable import RPS_ML_Multiplayer

final class GamePerformanceTests: XCTestCase {

    var sut: GameViewModel!

        override func setUp() {
            super.setUp()
            sut = GameViewModel()
        }

        override func tearDown() {
            sut = nil
            super.tearDown()
        }

    
    func testPerformancePlayerRockEnemyScissors() {
        sut.game.playerMove = .rock
        sut.game.enemyMove = .scissors
        measure {
           
            _ = sut.compareMoves()
        }
    }

    func testPerformancePlayerRockEnemyRock() {
        sut.game.playerMove = .rock
        sut.game.enemyMove = .rock
        measure {
            
            _ = sut.compareMoves()
        }
    }

    func testPerformancePlayerNoneEnemyNone() {
        sut.game.playerMove = .none
        sut.game.enemyMove = .none
        measure {
           
            _ = sut.compareMoves()
        }
    }
    
//    func testPerformanceRandomMoves() {
//        sut.game.playerMove = sut.game.gene
//        sut.game.enemyMove = .none
//        measure {
//
//            _ = sut.compareMoves()
//        }
//    }


}
