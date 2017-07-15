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
    
    let noughtWinningGameBoard:GameBoard = [.nought,    .untouched, .cross,
                                            .untouched, .nought,    .untouched,
                                            .cross,     .untouched, .nought]
    
    let crossWinningGameBoard:GameBoard = [.untouched, .nought, .untouched,
                                           .cross,     .cross,  .cross,
                                           .untouched, .nought, .untouched]
    
    let losingGameBoard:GameBoard = [.nought, .cross,     .nought,
                                     .cross,  .untouched, .nought,
                                     .cross,  .nought,    .cross]
    
    let fullGameBoard:GameBoard = [.nought, .cross,  .nought,
                                   .cross,  .nought, .nought,
                                   .cross,  .nought, .cross]
    
    let wayToWinGameBoard:GameBoard = [.nought, .untouched, .nought,
                                       .cross,  .nought,    .nought,
                                       .cross,  .nought,    .cross]
    
    let wayToWinGameBoard2:GameBoard = [.nought, .cross,     .nought,
                                        .cross,  .nought,    .nought,
                                        .cross,  .untouched, .cross]
    
    let noughtHasCenterAndCorner:GameBoard = [.untouched, .untouched, .cross,
                                              .untouched, .nought,    .untouched,
                                              .untouched, .untouched, .nought]
    
    let crossHasCenterAndCorner:GameBoard = [ .nought, .untouched, .untouched,
                                              .untouched, .cross,     .untouched,
                                              .cross,     .untouched, .untouched]
    
    let noughtCornerCrossHasCorner:GameBoard = [.untouched, .untouched, .cross,
                                                .untouched, .untouched,  .untouched,
                                                .untouched, .untouched,  .nought]
    
    let noughtMiddleCrossCenter:GameBoard = [.untouched, .untouched, .untouched,
                                             .untouched, .cross,     .nought,
                                             .untouched, .untouched, .nought]
    
    let noughtCenterCrossMiddle:GameBoard = [.untouched, .untouched, .untouched,
                                             .untouched, .nought,    .cross,
                                             .untouched, .untouched, .nought]
    
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
    
    func testCalcOpenCellsSuccess() {
        
        let requiredResult1 = calcOpenCells(gameBoard: noughtWinningGameBoard)
        let testOpenCells1 = [1,3,5,7]
        
        XCTAssertEqual(testOpenCells1, requiredResult1)
    }
    
    func testCalcOpenCellsFail() {
        
        let requiredResult2 = calcOpenCells(gameBoard: fullGameBoard)
        let testOpenCells2:[Int] = []
        
        XCTAssertEqual(testOpenCells2, requiredResult2)
    }
    
    func testCheckForWayToWinSuccess() {
        
        XCTAssertTrue(checkForWayToWin(wayToWinGameBoard))
        XCTAssertTrue(checkForWayToWin(fullGameBoard))
    }
    
    func testCheckForWayToWinFail() {
        XCTAssertFalse(checkForWayToWin(losingGameBoard))

    }
    
    func testCheckForUntouchedCellsSuccess() {
        XCTAssertTrue(checkForUntouchedCells(wayToWinGameBoard))
    }
    
    func testCheckForUntouchedCellsFail() {
        XCTAssertFalse(checkForUntouchedCells(fullGameBoard))
    }
    
    func testCalcOccupiedCellsFail() {
        let requiredCells1 = calcOccupiedCells(freshGameBoard, for: .cross)
        XCTAssertEqual(requiredCells1.count, 0)
        
        let requiredCells2 = calcOccupiedCells(freshGameBoard, for: .nought)
        XCTAssertEqual(requiredCells2.count, 0)
        
        let requiredCells3 = calcOccupiedCells(freshGameBoard, for: .untouched)
        XCTAssertEqual(requiredCells3.count, 9)
    }
    
    func testCalcOccupiedCellsSuccess() {
        let requiredCells1 = calcOccupiedCells(fullGameBoard, for: .cross)
        XCTAssertEqual(requiredCells1.count, 4)
        
        let requiredCells2 = calcOccupiedCells(fullGameBoard, for: .nought)
        XCTAssertEqual(requiredCells2.count, 5)

        let requiredCells3 = calcOccupiedCells(fullGameBoard, for: .untouched)
        XCTAssertEqual(requiredCells3.count, 0)
    }
    
    func testRandomCellFail() {
        let requiredCell1 = randomCell(freshGameBoard, threshold: 0)
        XCTAssertNil(requiredCell1)
        
        let requiredCell2 = randomCell(fullGameBoard, threshold: 100)
        XCTAssertNil(requiredCell2)
    }
    
    func testRandomCellSuccess() {
        let requiredCell1 = randomCell(freshGameBoard, threshold: 100)
        XCTAssertNotNil(requiredCell1)
    }
    
    func testRandomCellSuccessFiftyPercent() {
        var successCount = 0
        for _ in 0..<10000 {
            let requiredCell = randomCell(freshGameBoard, threshold: 50)
            if requiredCell != nil {
                successCount += 1
            }
        }
        let successRange = 4700..<5300
        XCTAssertTrue(successRange.contains(successCount), "successCount \(successCount)")
    }

    
    // Tests for aiChoose(gameBoard:)
    
    // 1. Zero open cells
    func testAiChooseZeroOpenCellsFail() {
        XCTAssertNil(aiChoose(fullGameBoard, unpredicible: true))
        XCTAssertNil(aiChoose(fullGameBoard, unpredicible: false))
    }
    
    func testAiChooseZeroOpenCellsSucess() {
        XCTAssertNotNil(aiChoose(freshGameBoard, unpredicible: true))
        XCTAssertNotNil(aiChoose(freshGameBoard, unpredicible: false))
    }

    // 2. Unpredicible (need to turn this off to do a true test!)
    // 2.1. Test for a random cell
    func testAiChooseUnpredicible() {
        // TODO: figure out how to test
    }
    
    // 3. Blocking move
    func testSearchForBlockingMoveSuccess() {
        XCTAssertNotNil(searchForBlockingMove(gameBoard: wayToWinGameBoard, for: .cross))
        XCTAssertNotNil(searchForBlockingMove(gameBoard: wayToWinGameBoard2, for: .nought))
    }
    
    func testSearchForBlockingMoveFail() {
        XCTAssertNil(searchForBlockingMove(gameBoard: wayToWinGameBoard, for: .nought))
        XCTAssertNil(searchForBlockingMove(gameBoard: wayToWinGameBoard2, for: .cross))
    }
   
    // 4. Take another corner
    func testSearchForCornerIfOpponentHasMiddleAndCornerSuccess() {
        XCTAssertNotNil(searchForAnotherCornerIfOpponentHasMiddleAndCorner(gameBoard: noughtHasCenterAndCorner, for: .cross))
        XCTAssertNotNil(searchForAnotherCornerIfOpponentHasMiddleAndCorner(gameBoard: crossHasCenterAndCorner, for: .nought))
    }
    
    func testSearchForCornerIfOpponentHasMiddleAndCornerFail() {
        XCTAssertNil(searchForAnotherCornerIfOpponentHasMiddleAndCorner(gameBoard: noughtHasCenterAndCorner, for: .nought))
        XCTAssertNil(searchForAnotherCornerIfOpponentHasMiddleAndCorner(gameBoard: crossHasCenterAndCorner, for: .cross))
    }
    
    // 5. Grab a middle
    func testSearchForMiddleIfCornerSuccess() {
        XCTAssertNotNil(searchForMiddleIfCorner(gameBoard: noughtCornerCrossHasCorner, for: .cross))
        XCTAssertNotNil(searchForMiddleIfCorner(gameBoard: noughtCornerCrossHasCorner, for: .nought))
    }
    
    func testSearchForMiddleIfCornerFail() {
        XCTAssertNil(searchForMiddleIfCorner(gameBoard: fullGameBoard, for: .cross))
        XCTAssertNil(searchForMiddleIfCorner(gameBoard: fullGameBoard, for: .nought))
    }

    // 6. Grab a corner
    func testSearchForCornerIfOpponentHasMiddleSuccess() {
        XCTAssertNotNil(searchForCornerIfOpponentHasMiddle(gameBoard: noughtMiddleCrossCenter, for: .cross))
        XCTAssertNotNil(searchForCornerIfOpponentHasMiddle(gameBoard: noughtCenterCrossMiddle, for: .nought))
    }
    
    func testSearchForCornerIfOpponentHasMiddleFail() {
        XCTAssertNil(searchForCornerIfOpponentHasMiddle(gameBoard: noughtMiddleCrossCenter, for: .nought))
        XCTAssertNil(searchForCornerIfOpponentHasMiddle(gameBoard: noughtCenterCrossMiddle, for: .cross))
    }
    
    // 7. Grab the center
    func testSearchForCenterIfOpenSuccess() {
        XCTAssertNotNil(searchForCenterIfOpen(gameBoard: freshGameBoard))
    }
    
    func testSearchForCenterIfOpenFial() {
        XCTAssertNil(searchForCenterIfOpen(gameBoard: fullGameBoard))
    }
    
    // 8. Grab a middle position
    func testSearchForMiddleIfCenterFail() {
        XCTAssertNil(searchForMiddleIfCenter(gameBoard: noughtCenterCrossMiddle, for: .cross))
        XCTAssertNil(searchForMiddleIfCenter(gameBoard: noughtMiddleCrossCenter, for: .nought))
    }
    
    func testSearchForMiddleIfCenterSuccess() {
        XCTAssertNotNil(searchForMiddleIfCenter(gameBoard: noughtMiddleCrossCenter, for: .cross))
        XCTAssertNotNil(searchForMiddleIfCenter(gameBoard: noughtCenterCrossMiddle, for: .nought))
    }
    
    // 9. Grab corner opposite opponent
    func testSearchForConterOpposteOpponentFail() {
        
    }
    
    
    // 10. Winning Move
    // 11. Any corner
    // 12. Random move
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
