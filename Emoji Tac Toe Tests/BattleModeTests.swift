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
        let battleMode = BattleMode(activePlayer: .cross, currentGameboard: freshGameboard)
        
        XCTAssertNotNil(battleMode)
        
        for cell in battleMode.currentGameboard {
            XCTAssertTrue(cell == .untouched)
        }
        
        let rank3Attacks = battleMode.attackList[2]
        XCTAssertTrue(rank3Attacks.count == 4 )
        assert(rank3Attacks[3] == .wipeOut)
    }
    
    func testChooseAttackID() {
        let battleMode = BattleMode(activePlayer: .cross, currentGameboard: freshGameboard)
        
        let attackID = battleMode.chooseAttackID()
        print("attackID.rawValue \(attackID.rawValue)")
        XCTAssertTrue(attackID.rawValue > 0 && attackID.rawValue <  8)

    }
    
    func testAttack() {
        let battleMode = BattleMode(activePlayer: .cross, currentGameboard: testGameboard)
        
        let (updatedGameboard, attackName) = battleMode.attack()
        XCTAssertNotNil(updatedGameboard)
        XCTAssertNotNil(attackName)
    }
    
    func testMeWin() {
        let battleMode = BattleMode(activePlayer: .nought, currentGameboard: testGameboard)
        
        let updatedGameboard = battleMode.meWin()
        let expectedGameboard = transformTextIntoGameboard(textRepresentation: "oxoxoooox")!
        
        XCTAssertTrue(updatedGameboard == expectedGameboard)
    }
    
    func testYouWin() {
        let battleMode = BattleMode(activePlayer: .nought, currentGameboard: testGameboard)
        
        let updatedGameboard = battleMode.youWin()
        let expectedGameboard = transformTextIntoGameboard(textRepresentation: "oxxxxoxox")!
        
        XCTAssertTrue(updatedGameboard == expectedGameboard)
    }
    
    func testWipeOut() {
        let battleMode = BattleMode(activePlayer: .nought, currentGameboard: testGameboard)
        
        let updatedGameboard = battleMode.wipeOut()
        let expectedGameboard = transformTextIntoGameboard(textRepresentation: "_________")!
        
        XCTAssertTrue(updatedGameboard == expectedGameboard)
    }
    
    func testSwitchLocations() {
        let battleMode = BattleMode(activePlayer: .nought, currentGameboard: testGameboard)
        
        let updatedGameboard = battleMode.switchLocations()
        let expectedGameboard = transformTextIntoGameboard(textRepresentation: "xo_o_x_xo")!
        
        XCTAssertTrue(updatedGameboard == expectedGameboard)
    }
    
    func testTakeAllCorners() {
        let battleMode = BattleMode(activePlayer: .nought, currentGameboard: testGameboard)
        
        let updatedGameboard = battleMode.takeAllCorners()
        let expectedGameboard = transformTextIntoGameboard(textRepresentation: "oxox_oooo")!
        
        XCTAssertTrue(updatedGameboard == expectedGameboard)
    }
    
    func testTakeAllMiddles() {
        let battleMode = BattleMode(activePlayer: .nought, currentGameboard: testGameboard)
        
        let updatedGameboard = battleMode.takeAllMiddles()
        let expectedGameboard = transformTextIntoGameboard(textRepresentation: "oo_o_o_ox")!
        
        XCTAssertTrue(updatedGameboard == expectedGameboard)
    }
    
    func testJumpToCenter() {
        let battleMode = BattleMode(activePlayer: .nought, currentGameboard: testGameboard)
        
        let updatedGameboard = battleMode.jumpToCenter()
        let expectedGameboard = transformTextIntoGameboard(textRepresentation: "ox_xoo_ox")!
        
        XCTAssertTrue(updatedGameboard == expectedGameboard)
    }
    
    func testMixUp() {
        let battleMode = BattleMode(activePlayer: .nought, currentGameboard: testGameboard)
        
        let updatedGameboard = battleMode.mixUp()
        let expectedGameboard = transformTextIntoGameboard(textRepresentation: "ox_x_o_ox")!
        
        XCTAssertTrue(updatedGameboard != expectedGameboard)
    }



    
}
