//
//  BattleMode.swift
//  Emoji Tac Toe
//
//  Created by John Pavley on 1/24/18.
//  Copyright © 2018 Epic Loot. All rights reserved.
//

import Foundation

enum BattleModeAttack: Int {
    case replicateAllOpenCells = 0
    case youWin = 7
    case takeAllCorners = 2
    case takeAllMiddles = 4
    case switchLocations = 1
    case jumpToCenter = 3
    case jumpToRandom = 5
    case wipeOut = 6
}

class BattleMode {
    
    
    enum AttackRank: Int {
        case instantWin = 1
        case nearlyInstantWin = 2
        case mixerUpper = 3
    }
    
    var activePlayer: Player
    var currentGameboard: Gameboard
    var touchedCell: Int
    var attackList: [[BattleModeAttack]]
    
    init(activePlayer: Player, currentGameboard: Gameboard, touchedCell: Int) {
        self.activePlayer = activePlayer
        self.currentGameboard = currentGameboard
        self.touchedCell = touchedCell
        self.attackList = [[BattleModeAttack]]()

        createAttackList()
    }
    
    fileprivate func createAttackList(){
        
        let rank1Attacks:[BattleModeAttack] = [.replicateAllOpenCells, .youWin]
        let rank2Attacks:[BattleModeAttack] = [.takeAllCorners, .takeAllMiddles]
        let rank3Attacks:[BattleModeAttack] = [.switchLocations, .jumpToCenter, .jumpToRandom, .wipeOut]
        
        attackList.append(contentsOf: [rank1Attacks, rank2Attacks, rank3Attacks])
    }
    
    /// Chooses a battlemode attack move based on the following probability table.
    /// Rank 1: Instant Win (2% probability).
    /// Rank 2: Nearly Instant Win (8% probability).
    /// Rank 3: Mixer upper (90% probability).
    /// Within each rank an attack move is chosen at random.
    func chooseAttackID() -> BattleModeAttack {
        
        // assemble the list of ranks with frequency based on probability
        
        var rankList = [AttackRank]()
        
        for _ in 0..<2 {
            rankList.append(.instantWin)
        }
        
        for _ in 0..<8 {
            rankList.append(.nearlyInstantWin)
        }
        
        for _ in 0..<90 {
            rankList.append(.mixerUpper)
        }
        
        // find the rank of the attack based on the probability
        let randomRank = rankList[diceRoll(100)]
        return findAttackBaseOnRank(randomRank: randomRank, attackList: attackList)
    }
    
    fileprivate func findAttackBaseOnRank(randomRank: AttackRank,
                                          attackList: [[BattleModeAttack]]) -> BattleModeAttack {
        let attackRankID = randomRank.rawValue - 1
        return attackList[attackRankID][diceRoll(2)]
    }
    
    /// Returns an updated gameboard with the effects of an attack
    /// randomly chosen.
    func attack() -> Gameboard {
        
        var attacks = [replicateAllOpenCells,
                       youWin,
                       takeAllCorners,
                       takeAllMiddles,
                       switchLocations,
                       jumpToCenter,
                       jumpToRandom,
                       wipeOut]
        
        let randomMove = chooseAttackID()
        let updatedGameboard = attacks[randomMove.rawValue]()
        return updatedGameboard
    }
    
    /// All untouched cells become player cells
    func replicateAllOpenCells() -> Gameboard {
        var updatedGameboard = currentGameboard
        for i in 0..<currentGameboard.count {
            if currentGameboard[i] == .untouched {
                updatedGameboard[i] = activePlayer
            }
        }
        return updatedGameboard
    }
    
    /// All untouched cells become opponet's cells
    func youWin() -> Gameboard {
        var updatedGameboard = currentGameboard

        let opponet = (activePlayer == Player.cross) ? Player.nought : Player.cross
        
        for i in 0..<currentGameboard.count {
            if currentGameboard[i] == .untouched {
                updatedGameboard[i] = opponet
            }
        }
        
        return updatedGameboard
    }
    
    /// All cells cells become untouched
    func wipeOut() -> Gameboard {
        var updatedGameboard = currentGameboard

        for i in 0..<currentGameboard.count {
            updatedGameboard[i] = .untouched
        }
        return updatedGameboard
    }
    
    /// Player cells switch places with opponet cells
    func switchLocations() -> Gameboard {
        var updatedGameboard = currentGameboard

        for i in 0..<currentGameboard.count {
            if currentGameboard[i] == .nought {
                updatedGameboard[i] = .cross
            } else if (currentGameboard[i] != .untouched) {
                updatedGameboard[i] = .nought
            }
        }
        
        return updatedGameboard
    }
    
    
    func takeAllCorners() -> Gameboard {
        var updatedGameboard = currentGameboard
        
        for i in 0..<cellCorners.count {
            updatedGameboard[i] = activePlayer
        }
        
        return updatedGameboard
    }
    
    func takeAllMiddles()  -> Gameboard {
        var updatedGameboard = currentGameboard

        for i in 0..<cellMiddles.count {
            updatedGameboard[i] = activePlayer
        }
        
        return updatedGameboard
    }
    
    /// Take the center
    func jumpToCenter() -> Gameboard {
        var updatedGameboard = currentGameboard
        
        updatedGameboard[cellCenter] = activePlayer
        return updatedGameboard
    }
    
    /// Take random cell
    func jumpToRandom() -> Gameboard {
        var updatedGameboard = currentGameboard

        let potentialLocations = cells.filter {$0 != touchedCell}
        let randomIndex = diceRoll(potentialLocations.count)
        let randomButtonID = potentialLocations[randomIndex]
        let targetLocation = randomButtonID - 1
        updatedGameboard[targetLocation] = activePlayer
    
        return updatedGameboard
    }
    
    func stealVictory() -> Gameboard {
        let updatedGameboard = currentGameboard

        // if the user loses it turns the loss into a win
        return updatedGameboard
    }

}
