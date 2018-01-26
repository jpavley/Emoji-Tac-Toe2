//
//  BattleModeTests.swift
//  Emoji Tac Toe Tests
//
//  Created by John Pavley on 1/25/18.
//  Copyright © 2018 Epic Loot. All rights reserved.
//

import XCTest

class BattleModeTests: XCTestCase {
    
    let testGameboard:Gameboard = [.nought,     .cross,    .untouched,
                                   .cross,     .untouched, .nought,
                                   .untouched, .nought,    .cross]

    
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

    }
    
}
