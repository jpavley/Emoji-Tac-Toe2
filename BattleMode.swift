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
    var attackList: [[BattleModeAttack]]
    
    init(activePlayer: Player, currentGameboard: Gameboard) {
        self.activePlayer = activePlayer
        self.currentGameboard = currentGameboard
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
        
        var attacks = [meWin,
                       youWin,
                       takeAllCorners,
                       takeAllMiddles,
                       switchLocations,
                       jumpToCenter,
                       mixUp,
                       wipeOut]
        
        let randomMove = chooseAttackID()
        let updatedGameboard = attacks[randomMove.rawValue]()
        return updatedGameboard
    }
    
    /// All untouched cells become player cells
    func meWin() -> Gameboard {
        let gameString = TicTacToeGame(gameboard: currentGameboard)
            .text
            .replacingOccurrences(of: "_", with: activePlayer.rawValue)
        
        return transformTextIntoGameboard(textRepresentation: gameString)!
    }
    
    /// All untouched cells become opponet's cells
    func youWin() -> Gameboard {
        let opponent = (activePlayer == Player.cross) ? Player.nought : Player.cross
        let gameString = TicTacToeGame(gameboard: currentGameboard)
            .text
            .replacingOccurrences(of: "_", with: opponent.rawValue)
        
        return transformTextIntoGameboard(textRepresentation: gameString)!
    }
    
    /// All cells cells become untouched
    func wipeOut() -> Gameboard {
        return transformTextIntoGameboard(textRepresentation: "_________")!
    }
    
    /// Player cells switch places with opponet cells
    func switchLocations() -> Gameboard {
        let opponent = (activePlayer == Player.cross) ? Player.nought : Player.cross
        let gameString = TicTacToeGame(gameboard: currentGameboard)
            .text
            .replacingOccurrences(of: opponent.rawValue, with: "@")
            .replacingOccurrences(of: activePlayer.rawValue, with: opponent.rawValue)
            .replacingOccurrences(of: "@", with: activePlayer.rawValue)

        return transformTextIntoGameboard(textRepresentation: gameString)!
        
    }
    
    /// Player steals the corners of the gameboard
    func takeAllCorners() -> Gameboard {
        var updatedGameboard = currentGameboard
        
        for cell in cellCorners {
            updatedGameboard[cell] = activePlayer
        }
        
        return updatedGameboard
    }
    
    /// Player steals the middle cells of the gameboard
    func takeAllMiddles()  -> Gameboard {
        var updatedGameboard = currentGameboard

        for cell in cellMiddles {
            updatedGameboard[cell] = activePlayer
        }
        
        return updatedGameboard
    }
    
    /// Take the center
    func jumpToCenter() -> Gameboard {
        var updatedGameboard = currentGameboard
        
        updatedGameboard[cellCenter] = activePlayer
        return updatedGameboard
    }
    
    /// Scramble the board
    func mixUp() -> Gameboard {
        var updatedGameboard = currentGameboard
        
        let states: [Player] = [.untouched, .nought, .cross]
        
        for i in 0..<updatedGameboard.count {
            updatedGameboard[i] = states[diceRoll(3)]
        }
    
        return updatedGameboard
    }
}
