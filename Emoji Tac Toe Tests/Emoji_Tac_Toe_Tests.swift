//
//  Emoji_Tac_Toe_Tests.swift
//  Emoji Tac Toe Tests
//
//  Created by John Pavley on 6/19/17.
//  Copyright © 2017 Epic Loot. All rights reserved.
//

import XCTest

//@testable import Emoji_Tac_Toe

class Emoji_Tac_Toe_Tests: XCTestCase {
    
    var ticTacToeUT: TicTacToeGame!
    
    let noughtWinningGameboard:Gameboard = [.nought,    .untouched, .cross,
                                            .untouched, .nought,    .untouched,
                                            .cross,     .untouched, .nought]
    
    let crossWinningGameboard:Gameboard = [.untouched, .nought, .untouched,
                                           .cross,     .cross,  .cross,
                                           .untouched, .nought, .untouched]
    
    let losingGameboard:Gameboard = [.nought, .cross,     .nought,
                                     .cross,  .untouched, .nought,
                                     .cross,  .nought,    .cross]
    
    let fullGameboard:Gameboard = [.nought, .cross,  .nought,
                                   .cross,  .nought, .nought,
                                   .cross,  .nought, .cross]
    
    let wayToWinGameboard:Gameboard = [.nought, .untouched, .nought,
                                       .cross,  .nought,    .nought,
                                       .cross,  .nought,    .cross]
    
    let wayToWinGameboard2:Gameboard = [.nought, .cross,     .nought,
                                        .cross,  .nought,    .nought,
                                        .cross,  .untouched, .cross]
    
    let noughtHasCenterAndCorner:Gameboard = [.untouched, .untouched, .cross,
                                              .untouched, .nought,    .untouched,
                                              .untouched, .untouched, .nought]
    
    let crossHasCenterAndCorner:Gameboard = [ .nought, .untouched, .untouched,
                                              .untouched, .cross,     .untouched,
                                              .cross,     .untouched, .untouched]
    
    let noughtCornerCrossHasCorner:Gameboard = [.untouched, .untouched, .cross,
                                                .untouched, .untouched,  .untouched,
                                                .untouched, .untouched,  .nought]
    
    let noughtMiddleCrossCenter:Gameboard = [.untouched, .untouched, .untouched,
                                             .untouched, .cross,     .nought,
                                             .untouched, .untouched, .nought]
    
    let noughtCenterCrossMiddle:Gameboard = [.untouched, .untouched, .untouched,
                                             .untouched, .nought,    .cross,
                                             .untouched, .untouched, .nought]
    
    let noughtMark = "⭕️"
    let crossMark = "❌"
    let untouchedMark = "⬜️"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        ticTacToeUT = TicTacToeGame(gameboard:freshGameboard,
                                    noughtMark: "⭕️",
                                    crossMark: "❌",
                                    untouchedMark: "⬜️",
                                    gameOver: false)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        ticTacToeUT = nil
        super.tearDown()
    }
    
    func testGameIsFresh() {
        XCTAssertEqual(freshGameboard, ticTacToeUT.gameboard)
    }
    
    func testTransformGameIntoText() {
        let requiredGameText = "⭕️ ❌ ⭕️ \n❌ ⬜️ ⭕️ \n❌ ⭕️ ❌ \n"
        ticTacToeUT.gameboard = losingGameboard
        
        let ticTacToeGame = TicTacToeGame(gameboard: ticTacToeUT.gameboard, noughtMark: "⭕️", crossMark: "❌", untouchedMark: "⬜️", gameOver: false)
        XCTAssertEqual(requiredGameText, transformGameIntoText(game: ticTacToeGame))
    }
    
    func testTransformTextIntoGameboard() {
        XCTAssertEqual(losingGameboard, transformTextIntoGameboard(textRepresentation: "oxox_oxox")!)
        XCTAssertNil(transformTextIntoGameboard(textRepresentation: "oxox_oxo"))
        XCTAssertNil(transformTextIntoGameboard(textRepresentation: "oxo@_oxox"))
        XCTAssertEqual(losingGameboard, transformTextIntoGameboard(textRepresentation: "*+*+-*+*+", noughtMark: "*", crossMark: "+", untouchedMark: "-")!)

    }
    
    func testSearchForWinFail() {
        
        ticTacToeUT.gameboard = losingGameboard
        
        XCTAssertNil(searchForWin(ticTacToeUT.gameboard))
    }
    
    func testSearchForWinSuccess() {
        
        ticTacToeUT.gameboard = noughtWinningGameboard
        
        XCTAssertEqual([0,4,8], searchForWin(ticTacToeUT.gameboard)!)
    }
    
    func testSearchForWinForPlayerFail() {
        
        let requiredResult = seachForWinForPlayer(crossWinningGameboard, player: .nought)
        
        XCTAssertFalse(requiredResult)
    }
    
    func testSearchForWinForPlayerSuccess() {
        
        let requiredResult = seachForWinForPlayer(crossWinningGameboard, player: .cross)
        
        XCTAssertTrue(requiredResult)
    }
    
    func testCalcOpenCellsSuccess() {
        
        let requiredResult1 = calcOpenCells(gameboard: noughtWinningGameboard)
        let testOpenCells1 = [1,3,5,7]
        
        XCTAssertEqual(testOpenCells1, requiredResult1)
    }
    
    func testCalcOpenCellsFail() {
        
        let requiredResult2 = calcOpenCells(gameboard: fullGameboard)
        let testOpenCells2:[Int] = []
        
        XCTAssertEqual(testOpenCells2, requiredResult2)
    }
    
    func testCheckForWayToWinSuccess() {
        
        XCTAssertTrue(checkForWayToWin(wayToWinGameboard))
        XCTAssertTrue(checkForWayToWin(fullGameboard))
    }
    
    func testCheckForWayToWinFail() {
        XCTAssertFalse(checkForWayToWin(losingGameboard))

    }
    
    func testCheckForUntouchedCellsSuccess() {
        XCTAssertTrue(checkForUntouchedCells(wayToWinGameboard))
    }
    
    func testCheckForUntouchedCellsFail() {
        XCTAssertFalse(checkForUntouchedCells(fullGameboard))
    }
    
    func testCalcOccupiedCellsFail() {
        let requiredCells1 = calcOccupiedCells(freshGameboard, for: .cross)
        XCTAssertEqual(requiredCells1.count, 0)
        
        let requiredCells2 = calcOccupiedCells(freshGameboard, for: .nought)
        XCTAssertEqual(requiredCells2.count, 0)
        
        let requiredCells3 = calcOccupiedCells(freshGameboard, for: .untouched)
        XCTAssertEqual(requiredCells3.count, 9)
    }
    
    func testCalcOccupiedCellsSuccess() {
        let requiredCells1 = calcOccupiedCells(fullGameboard, for: .cross)
        XCTAssertEqual(requiredCells1.count, 4)
        
        let requiredCells2 = calcOccupiedCells(fullGameboard, for: .nought)
        XCTAssertEqual(requiredCells2.count, 5)

        let requiredCells3 = calcOccupiedCells(fullGameboard, for: .untouched)
        XCTAssertEqual(requiredCells3.count, 0)
    }
    
    func testRandomCellFail() {
        let requiredCell1 = calcRandomCell(freshGameboard, threshold: 0)
        XCTAssertNil(requiredCell1)
        
        let requiredCell2 = calcRandomCell(fullGameboard, threshold: 100)
        XCTAssertNil(requiredCell2)
    }
    
    func testRandomCellSuccess() {
        let requiredCell1 = calcRandomCell(freshGameboard, threshold: 100)
        XCTAssertNotNil(requiredCell1)
    }
    
    func testRandomCellSuccessFiftyPercent() {
        var successCount = 0
        for _ in 0..<10000 {
            let requiredCell = calcRandomCell(freshGameboard, threshold: 50)
            if requiredCell != nil {
                successCount += 1
            }
        }
        let successRange = 4700..<5300
        XCTAssertTrue(successRange.contains(successCount))
    }

    
    // Tests for aiChoose(gameboard:)
    
    // 1. Zero open cells
    func testAiChooseZeroOpenCellsFail() {
        XCTAssertNil(aiChoose(fullGameboard, unpredicible: true))
        XCTAssertNil(aiChoose(fullGameboard, unpredicible: false))
    }
    
    func testAiChooseZeroOpenCellsSucess() {
        XCTAssertNotNil(aiChoose(freshGameboard, unpredicible: true))
        XCTAssertNotNil(aiChoose(freshGameboard, unpredicible: false))
    }

    // 2. Unpredicible (need to turn this off to do a true test!)
    // 2.1. Test for a random cell
    func testAiChooseUnpredicible() {
        // TODO: figure out how to test
    }
    
    // 3. Blocking move
    func testSearchForBlockingMoveSuccess() {
        XCTAssertNotNil(searchForBlockingMove(gameboard: wayToWinGameboard, for: .cross))
        XCTAssertNotNil(searchForBlockingMove(gameboard: wayToWinGameboard2, for: .nought))
    }
    
    func testSearchForBlockingMoveFail() {
        XCTAssertNil(searchForBlockingMove(gameboard: wayToWinGameboard, for: .nought))
        XCTAssertNil(searchForBlockingMove(gameboard: wayToWinGameboard2, for: .cross))
    }
   
    // 4. Take another corner
    func testSearchForCornerIfOpponentHasMiddleAndCornerSuccess() {
        XCTAssertNotNil(searchForAnotherCornerIfOpponentHasMiddleAndCorner(gameboard: noughtHasCenterAndCorner, for: .cross))
        XCTAssertNotNil(searchForAnotherCornerIfOpponentHasMiddleAndCorner(gameboard: crossHasCenterAndCorner, for: .nought))
    }
    
    func testSearchForCornerIfOpponentHasMiddleAndCornerFail() {
        XCTAssertNil(searchForAnotherCornerIfOpponentHasMiddleAndCorner(gameboard: noughtHasCenterAndCorner, for: .nought))
        XCTAssertNil(searchForAnotherCornerIfOpponentHasMiddleAndCorner(gameboard: crossHasCenterAndCorner, for: .cross))
    }
    
    // 5. Grab a middle
    func testSearchForMiddleIfCornerSuccess() {
        XCTAssertNotNil(searchForMiddleIfCorner(gameboard: noughtCornerCrossHasCorner, for: .cross))
        XCTAssertNotNil(searchForMiddleIfCorner(gameboard: noughtCornerCrossHasCorner, for: .nought))
    }
    
    func testSearchForMiddleIfCornerFail() {
        XCTAssertNil(searchForMiddleIfCorner(gameboard: fullGameboard, for: .cross))
        XCTAssertNil(searchForMiddleIfCorner(gameboard: fullGameboard, for: .nought))
    }

    // 6. Grab a corner
    func testSearchForCornerIfOpponentHasMiddleSuccess() {
        XCTAssertNotNil(searchForCornerIfOpponentHasMiddle(gameboard: noughtMiddleCrossCenter, for: .cross))
        XCTAssertNotNil(searchForCornerIfOpponentHasMiddle(gameboard: noughtCenterCrossMiddle, for: .nought))
    }
    
    func testSearchForCornerIfOpponentHasMiddleFail() {
        XCTAssertNil(searchForCornerIfOpponentHasMiddle(gameboard: noughtMiddleCrossCenter, for: .nought))
        XCTAssertNil(searchForCornerIfOpponentHasMiddle(gameboard: noughtCenterCrossMiddle, for: .cross))
    }
    
    // 7. Grab the center
    func testSearchForCenterIfOpenSuccess() {
        XCTAssertNotNil(searchForCenterIfOpen(gameboard: freshGameboard))
    }
    
    func testSearchForCenterIfOpenFial() {
        XCTAssertNil(searchForCenterIfOpen(gameboard: fullGameboard))
    }
    
    // 8. Grab a middle position
    func testSearchForMiddleIfCenterFail() {
        XCTAssertNil(searchForMiddleIfCenter(gameboard: noughtCenterCrossMiddle, for: .cross))
        XCTAssertNil(searchForMiddleIfCenter(gameboard: noughtMiddleCrossCenter, for: .nought))
    }
    
    func testSearchForMiddleIfCenterSuccess() {
        XCTAssertNotNil(searchForMiddleIfCenter(gameboard: noughtMiddleCrossCenter, for: .cross))
        XCTAssertNotNil(searchForMiddleIfCenter(gameboard: noughtCenterCrossMiddle, for: .nought))
    }
    
    // 9. Grab corner opposite opponent
    func testSearchForConterOpposteOpponentSuccess() {
        let testGame1 = transformTextIntoGameboard(textRepresentation: "________o")
        XCTAssertNotNil(searchForCornerOppositeOpponent(gameboard: testGame1!, for: .cross))
        
        let testGame3 = transformTextIntoGameboard(textRepresentation: "__o______")
        XCTAssertNotNil(searchForCornerOppositeOpponent(gameboard: testGame3!, for: .cross))
        
        let testGame4 = transformTextIntoGameboard(textRepresentation: "______o__")
        XCTAssertNotNil(searchForCornerOppositeOpponent(gameboard: testGame4!, for: .cross))
        
        let testGame2 = transformTextIntoGameboard(textRepresentation: "x________")
        XCTAssertNotNil(searchForCornerOppositeOpponent(gameboard: testGame2!, for: .nought))
    }
    
    func testSearchForConterOpposteOpponentFail() {
        let testGame1 = transformTextIntoGameboard(textRepresentation: "x_x___x_o")
        XCTAssertNil(searchForCornerOppositeOpponent(gameboard: testGame1!, for: .cross))
        
        let testGame2 = transformTextIntoGameboard(textRepresentation: "o_o___o_x")
        XCTAssertNil(searchForCornerOppositeOpponent(gameboard: testGame2!, for: .nought))
    }
    
    // 10. Winning Move
    
    func testSearchForWinningMoveFail() {
        XCTAssertNil(searchForWinningMove(gameboard: noughtWinningGameboard, for: .cross))
        XCTAssertNil(searchForWinningMove(gameboard: crossWinningGameboard, for: .nought))
    }
    
    func testSearchForWinningMoveSuccess() {
        XCTAssertNotNil(searchForWinningMove(gameboard: noughtWinningGameboard, for: .nought))
        XCTAssertNotNil(searchForWinningMove(gameboard: crossWinningGameboard, for: .cross))
    }

    // 11. Any corner
    
    func testSearchForAnyOpenCornerFail() {
        let testGame1 = transformTextIntoGameboard(textRepresentation: "o_o___o_o")
        XCTAssertNil(searchForAnyOpenCorner(gameboard: testGame1!))
    }
    
    func testSearchForAnyOpenCornerSuccess() {
        XCTAssertNotNil(searchForAnyOpenCorner(gameboard: freshGameboard))
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
