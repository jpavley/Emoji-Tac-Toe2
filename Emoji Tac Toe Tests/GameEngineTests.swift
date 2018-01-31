//
//  GameEngineTests.swift
//  Emoji Tac Toe Tests
//
//  Created by John Pavley on 1/30/18.
//  Copyright © 2018 Epic Loot. All rights reserved.
//

import XCTest

class GameEngineTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitGameEngine() {
        let gameEngine = GameEngine()
        
        XCTAssertNotNil(gameEngine)
        XCTAssertEqual(gameEngine.aiEnabled, true)
        XCTAssertEqual(gameEngine.cheatingEnabled, false)
        XCTAssertEqual(gameEngine.instantEnabled, false)
        
        XCTAssertEqual(gameEngine.playerOne.kind, .human)
        XCTAssertEqual(gameEngine.playerOne.mark, .nought)
        
        XCTAssertEqual(gameEngine.playerTwo.kind, .ai)
        XCTAssertEqual(gameEngine.playerTwo.mark, .cross)
        
        XCTAssertEqual(gameEngine.round, .playerOneRound)
        
        XCTAssertEqual(gameEngine.score.draws, 0)
        XCTAssertEqual(gameEngine.score.playerTwoWins, 0)
        XCTAssertEqual(gameEngine.score.playerOneWins, 0)
        
        XCTAssertEqual(gameEngine.state, .playerOnePlaying)
        
        XCTAssertEqual(gameEngine.ticTacToeGame.gameboard, freshGameboard)
        XCTAssertEqual(gameEngine.ticTacToeGame.gameOver, false)

    }
    
    
}
