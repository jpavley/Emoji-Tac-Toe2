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
        let gameEngine = GameEngine(noughtToken: "⭕️", crossToken: "❌", untouchedToken: "⬜️")
        
        XCTAssertNotNil(gameEngine)
        XCTAssertEqual(gameEngine.aiEnabled, true)
        XCTAssertEqual(gameEngine.cheatingEnabled, false)
        XCTAssertEqual(gameEngine.instantEnabled, false)
        
        XCTAssertEqual(gameEngine.playerOne.kind, .human)
        XCTAssertEqual(gameEngine.playerOne.role, .nought)
        
        XCTAssertEqual(gameEngine.playerTwo.kind, .ai)
        XCTAssertEqual(gameEngine.playerTwo.role, .cross)
        
        XCTAssertEqual(gameEngine.round, .playerOneRound)
        
        XCTAssertEqual(gameEngine.score.draws, 0)
        XCTAssertEqual(gameEngine.score.playerTwoWins, 0)
        XCTAssertEqual(gameEngine.score.playerOneWins, 0)
        
        XCTAssertEqual(gameEngine.state, .playerOnePlaying)
        
        XCTAssertEqual(gameEngine.ticTacToeGame.gameboard, freshGameboard)
        XCTAssertEqual(gameEngine.ticTacToeGame.gameOver, false)
    }
    
    func testWinningStateAndIsGameOverPlayerOne() {
        let gameEngine = GameEngine(noughtToken: "⭕️", crossToken: "❌", untouchedToken: "⬜️")
        gameEngine.ticTacToeGame.gameboard = transformTextIntoGameboard(textRepresentation: "ooooooooo")!
        gameEngine.checkForWinOrDraw()
        XCTAssertTrue(gameEngine.isGameOver())
        XCTAssertEqual(gameEngine.state, .playerOneWin)
        XCTAssertEqual(gameEngine.score.playerOneWins, 1)
        XCTAssertEqual(gameEngine.ticTacToeGame.gameOver, true)
    }
    
    func testWinningStateAndIsGameOverPlayerTwo() {
        let gameEngine = GameEngine(noughtToken: "⭕️", crossToken: "❌", untouchedToken: "⬜️")
        gameEngine.ticTacToeGame.gameboard = transformTextIntoGameboard(textRepresentation: "xxxxxxxxx")!
        gameEngine.checkForWinOrDraw()
        XCTAssertTrue(gameEngine.isGameOver())
        XCTAssertEqual(gameEngine.state, .playerTwoWin)
        XCTAssertEqual(gameEngine.score.playerTwoWins, 1)
        XCTAssertEqual(gameEngine.ticTacToeGame.gameOver, true)
    }
    
    func testNextRound() {
        let gameEngine = GameEngine(noughtToken: "⭕️", crossToken: "❌", untouchedToken: "⬜️")
        gameEngine.nextRound()
        
        XCTAssertFalse(gameEngine.isGameOver())
        XCTAssertEqual(gameEngine.round, .playerTwoRound)
        XCTAssertEqual(gameEngine.ticTacToeGame.gameOver, false)
        
        gameEngine.nextRound()
        XCTAssertFalse(gameEngine.isGameOver())
        XCTAssertEqual(gameEngine.state, .playerOnePlaying)
        XCTAssertEqual(gameEngine.round, .playerOneRound)
        XCTAssertEqual(gameEngine.ticTacToeGame.gameOver, false)

        gameEngine.aiEnabled = false
        gameEngine.nextRound()
        XCTAssertFalse(gameEngine.isGameOver())
        XCTAssertEqual(gameEngine.state, .playerTwoPlaying)
        XCTAssertEqual(gameEngine.round, .playerTwoRound)
        XCTAssertEqual(gameEngine.ticTacToeGame.gameOver, false)
        
        gameEngine.nextRound()
        XCTAssertFalse(gameEngine.isGameOver())
        XCTAssertEqual(gameEngine.state, .playerOnePlaying)
        XCTAssertEqual(gameEngine.round, .playerOneRound)
        XCTAssertEqual(gameEngine.ticTacToeGame.gameOver, false)
    }
    
    func testNextGame() {
        let gameEngine = GameEngine(noughtToken: "⭕️", crossToken: "❌", untouchedToken: "⬜️")
        gameEngine.nextGame()
        
        XCTAssertFalse(gameEngine.isGameOver())
        XCTAssertEqual(gameEngine.state, .playerOnePlaying)
        XCTAssertEqual(gameEngine.round, .playerOneRound)
        
        XCTAssertEqual(gameEngine.ticTacToeGame.gameboard, freshGameboard)
        XCTAssertEqual(gameEngine.ticTacToeGame.gameOver, false)


    }

    
    
}
