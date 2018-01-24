//
//  BattleMode.swift
//  Emoji Tac Toe
//
//  Created by John Pavley on 1/24/18.
//  Copyright © 2018 Epic Loot. All rights reserved.
//

import Foundation

class BattleMode {
    
    var activePlayer: Player
    var playerMark: String
    var currentGameboard: Gameboard
    
    init(activePlayer: Player, playerMark: String, currentGameboard: Gameboard) {
        self.activePlayer = activePlayer
        self.playerMark = playerMark
        self.currentGameboard = currentGameboard
    }
    
    enum AttackRank:Int {
        case instantWin = 1
        case nearlyInstantWin = 2
        case mixerUpper = 3
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
        let attackList = createAttackList()
        
        return findAttackBaseOnRank(randomRank: randomRank, attackList: attackList)
    }
    
    fileprivate func createAttackList() -> [[BattleModeAttack]] {
        
        let rank1Attacks:[BattleModeAttack] = [.replicateAllOpenCells, .youWin]
        let rank2Attacks:[BattleModeAttack] = [.takeAllCorners, .takeAllMiddles]
        let rank3Attacks:[BattleModeAttack] = [.switchLocations, .jumpToCenter, .jumpToRandom, .wipeOut]
        
        return [rank1Attacks, rank2Attacks, rank3Attacks]
    }
    
    fileprivate func findAttackBaseOnRank(randomRank: AttackRank, attackList: [[BattleModeAttack]]) -> BattleModeAttack {
        
        var randomMove: BattleModeAttack
        
        switch randomRank {
            
        case .instantWin:
            randomMove = attackList[0][diceRoll(2)]
            
        case .nearlyInstantWin:
            randomMove = attackList[1][diceRoll(2)]
            
        case .mixerUpper:
            randomMove = attackList[2][diceRoll(4)]
        }
        
        return randomMove
    }
    
    func battleModeAttack(touchedCell: Int) -> Gameboard {
        
        if activePlayer == .nought {
            playerMark = noughtMark
        } else {
            playerMark = crossMark
        }
        
        let randomMove = chooseAttackID()
        var updatedGameboard: Gameboard
        
        switch randomMove {
        case .replicateAllOpenCells:
            // rank: 1
            updatedGameboard = replicateAllOpenCells(touchedCell)
        case .youWin:
            // rank: 1
            updatedGameboard = youWin(touchedCell)
        case .takeAllCorners:
            // rank: 2
            updatedGameboard = takeAllCorners(touchedCell)
        case .takeAllMiddles:
            // rank: 2
            updatedGameboard = takeAllMiddles(touchedCell)
        case .switchLocations:
            // rank: 3
            updatedGameboard = switchLocations(touchedCell)
        case .jumpToCenter:
            // rank: 3
            updatedGameboard = jumpToCenter(touchedCell)
        case .jumpToRandom:
            // rank: 3
            updatedGameboard = jumpToRandom(touchedCell)
        case .wipeOut:
            // rank: 3
            updatedGameboard = wipeOut(touchedCell)
        }
        
        return updatedGameboard
        
    }
    
    /// All untouched cells become player cells
    func replicateAllOpenCells(_ touchLocation: Int) -> Gameboard {
        var updatedGameboard = currentGameboard
        for i in 0..<currentGameboard.count {
            if currentGameboard[i] == .untouched {
                updatedGameboard[i] = activePlayer
            }
        }
        return updatedGameboard
    }
    
    /// All untouched cells become opponet's cells
    func youWin(_ touchLocation: Int) -> Gameboard {
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
    func wipeOut(_ touchLocation: Int) -> Gameboard {
        var updatedGameboard = currentGameboard

        for i in 0..<currentGameboard.count {
            updatedGameboard[i] = .untouched
        }
        return updatedGameboard
    }
    
    /// Player cells switch places with opponet cells
    func switchLocations(_ touchedLocation: Int) -> Gameboard {
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
    
    
    func takeAllCorners(_ touchedLocation: Int) -> Gameboard {
        var updatedGameboard = currentGameboard
        
        for i in 0..<cellCorners.count {
            updatedGameboard[i] = activePlayer
        }
        
        return updatedGameboard
    }
    
    func takeAllMiddles(_ buttonID: Int)  -> Gameboard {
        var updatedGameboard = currentGameboard

        for i in 0..<cellMiddles.count {
            updatedGameboard[i] = activePlayer
        }
        
        return updatedGameboard
    }
    
    /// Take the center
    func jumpToCenter(_ touchedLocation: Int) -> Gameboard {
        var updatedGameboard = currentGameboard
        
        updatedGameboard[cellCenter] = activePlayer
        return updatedGameboard
    }
    
    /// Take random cell
    func jumpToRandom(_ touchedLocation: Int) -> Gameboard {
        var updatedGameboard = currentGameboard

        // HINT: replace mark at the center
        let potentialLocations = cells.filter {$0 != touchedLocation}
        let randomIndex = diceRoll(potentialLocations.count)
        let randomButtonID = potentialLocations[randomIndex]
        let targetLocation = randomButtonID - 1
        updatedGameboard[targetLocation] = activePlayer
    
        return updatedGameboard
    }
    
    func stealVictory(_ buttonID: Int) -> Gameboard {
        let updatedGameboard = currentGameboard

        // if the user loses it turns the loss into a win
        return updatedGameboard
    }

}
