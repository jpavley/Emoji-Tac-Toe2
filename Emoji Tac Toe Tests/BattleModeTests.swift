//
//  BattleModeTests.swift
//  Emoji Tac Toe Tests
//
//  Created by John Pavley on 1/25/18.
//  Copyright © 2018 Epic Loot. All rights reserved.
//

import XCTest

class BattleModeTests: XCTestCase {
    
    let testGameboard = transformTextIntoGameboard(textRepresentation: "ox_x_o_ox")!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBattleModeInit() {
        let battleMode = BattleMode(activePlayer: .cross, currentGameboard: freshGameboard, touchedCell: 0)
        
        XCTAssertNotNil(battleMode)
        
        for cell in battleMode.currentGameboard {
            XCTAssertTrue(cell == .untouched)
        }
        
        let rank3Attacks = battleMode.attackList[2]
        XCTAssertTrue(rank3Attacks.count == 4 )
        assert(rank3Attacks[3] == .wipeOut)
    }
    
    func testChooseAttackID() {
        let battleMode = BattleMode(activePlayer: .cross, currentGameboard: freshGameboard, touchedCell: 0)
        
        let attackID = battleMode.chooseAttackID()
        XCTAssertTrue(attackID.rawValue > 0 && attackID.rawValue <  8)

    }
    
    func testAttack() {
        let battleMode = BattleMode(activePlayer: .cross, currentGameboard: testGameboard, touchedCell: cellCenter)
        
        let updatedGameboard = battleMode.attack()
        XCTAssertNotNil(updatedGameboard)
    }
    
    func testMeWin() {
        let battleMode = BattleMode(activePlayer: .nought, currentGameboard: testGameboard, touchedCell: cellCenter)
        
        let updatedGameboard = battleMode.meWin()
        let expectedGameboard = transformTextIntoGameboard(textRepresentation: "oxoxoooox")!
        
        XCTAssertTrue(updatedGameboard == expectedGameboard)
    }
    
    func testYouWin() {
        let battleMode = BattleMode(activePlayer: .nought, currentGameboard: testGameboard, touchedCell: cellCenter)
        
        let updatedGameboard = battleMode.youWin()
        let expectedGameboard = transformTextIntoGameboard(textRepresentation: "oxxxxoxox")!
        
        XCTAssertTrue(updatedGameboard == expectedGameboard)
    }
    
    func testWipeOut() {
        let battleMode = BattleMode(activePlayer: .nought, currentGameboard: testGameboard, touchedCell: cellCenter)
        
        let updatedGameboard = battleMode.wipeOut()
        let expectedGameboard = transformTextIntoGameboard(textRepresentation: "_________")!
        
        XCTAssertTrue(updatedGameboard == expectedGameboard)
    }
    
    func testSwitchLocations() {
        let battleMode = BattleMode(activePlayer: .nought, currentGameboard: testGameboard, touchedCell: cellCenter)
        
        let updatedGameboard = battleMode.switchLocations()
        let expectedGameboard = transformTextIntoGameboard(textRepresentation: "xo_o_x_xo")!
        
        XCTAssertTrue(updatedGameboard == expectedGameboard)

    }

    
}
