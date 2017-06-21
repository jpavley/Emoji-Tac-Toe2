//
//  Emoji_Tac_Toe_Tests.swift
//  Emoji Tac Toe Tests
//
//  Created by John Pavley on 6/19/17.
//  Copyright © 2017 Epic Loot. All rights reserved.
//

import XCTest

@testable import Emoji_Tac_Toe

class Emoji_Tac_Toe_Tests: XCTestCase {
    
    var ticTacToeUT: TicTacToeGame!
    
    let noughtWinningGameBoard:[Player] = [.nought,    .untouched, .cross,
                                           .untouched, .nought,    .untouched,
                                           .cross,     .untouched, .nought]
    
    let crossWinningGameBoard:[Player] = [.untouched, .nought, .untouched,
                                          .cross,     .cross,  .cross,
                                          .untouched, .nought, .untouched]
    
    let losingGameBoard:[Player] = [.nought, .cross,     .nought,
                                    .cross,  .untouched, .nought,
                                    .cross,  .nought,    .cross]
    
    let noughtMark = "⭕️"
    let crossMark = "❌"
    let untouchedMark = "⬜️"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        ticTacToeUT = TicTacToeGame(gameBoard:freshGameBoard,
                                    noughtMark: "⭕️",
                                    crossMark: "❌",
                                    gameOver: false)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        ticTacToeUT = nil
        super.tearDown()
    }
    
    func testGameIsFresh() {
        XCTAssertEqual(freshGameBoard, ticTacToeUT.gameBoard)
    }
    
    func testTransformGameIntoText() {
        
        let requiredGameText = "⭕️ ❌ ⭕️ \n❌ ⬜️ ⭕️ \n❌ ⭕️ ❌ \n"
        ticTacToeUT.gameBoard = losingGameBoard
        
        XCTAssertEqual(requiredGameText, transformGameIntoText(gameboard: ticTacToeUT.gameBoard, noughtMark: "⭕️", crossMark: "❌", untouchedMark: "⬜️"))
    }
    
    func testSearchForWinFail() {
        ticTacToeUT.gameBoard = losingGameBoard
        
        XCTAssertNil(searchForWin(ticTacToeUT.gameBoard))
    }
    
    func testSearchForWinSuccess() {
        ticTacToeUT.gameBoard = noughtWinningGameBoard
        
        XCTAssertEqual([0,4,8], searchForWin(ticTacToeUT.gameBoard)!)
    }
    
    func testSearchForWinForPlayerFail() {
        let requiredResult = seachForWinForPlayer(crossWinningGameBoard, player: .nought)
        XCTAssertFalse(requiredResult)
    }
    
    func testSearchForWinForPlayerSuccess() {
        let requiredResult = seachForWinForPlayer(crossWinningGameBoard, player: .cross)
        XCTAssertTrue(requiredResult)
    }

    
}
