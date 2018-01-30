//
//  BattleMode.swift
//  Emoji Tac Toe
//
//  Created by John Pavley on 1/24/18.
//  Copyright © 2018 Epic Loot. All rights reserved.
//

import Foundation

enum BattleModeAttack: Int {
    case meWin = 0
    case youWin = 1
    case takeAllCorners = 2
    case takeAllMiddles = 3
    case switchLocations = 4
    case jumpToCenter = 5
    case mixUp = 6
    case wipeOut = 7
}

class BattleMode {
    
    enum AttackRank: Int {
        case instantWin = 1
        case nearlyInstantWin = 2
        case mixerUpper = 3
    }
    
    struct attackNames {
        static let meWin = "Me Win"
        static let youWin = " You Win"
        static let takeAllCorners = "Take All Corners"
        static let takeAllMiddles = "Take All Middles"
        static let switchLocations = "Swap Places"
        static let jumpToCenter = "Take Center"
        static let mixUp = "Mix It Up"
        static let wipeOut = "Wipe Out"
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
        
        let rank1Attacks:[BattleModeAttack] = [.meWin, .youWin]
        let rank2Attacks:[BattleModeAttack] = [.takeAllCorners, .takeAllMiddles]
        let rank3Attacks:[BattleModeAttack] = [.switchLocations, .jumpToCenter, .mixUp, .wipeOut]
        
        attackList.append(contentsOf: [rank1Attacks, rank2Attacks, rank3Attacks])
    }
    
    /// Chooses a battlemode attack move based on the following probability table.
    /// Rank 1: Instant Win (10% probability).
    /// Rank 2: Nearly Instant Win (20% probability).
    /// Rank 3: Mixer upper (70% probability).
    /// Within each rank an attack move is chosen at random.
    func chooseAttackID() -> BattleModeAttack {
        
        // assemble the list of ranks with frequency based on probability
        var rankList = [AttackRank]()
        
        for _ in 0..<10 {
            rankList.append(.instantWin)
        }
        
        for _ in 0..<20 {
            rankList.append(.nearlyInstantWin)
        }
        
        for _ in 0..<70 {
            rankList.append(.mixerUpper)
        }
        
        // find the rank of the attack based on the probability
        let randomRank = rankList[diceRoll(100)]
        
        // some ranks have more attacks then other
        var rankCount: Int
        
        switch randomRank {
        case .instantWin:
            rankCount = 2
        case .nearlyInstantWin:
            rankCount = 2
        case .mixerUpper:
            rankCount = 4
        }
        
        // return a random attack based on the random rank
        let attackRankID = randomRank.rawValue - 1
        let battleModeAttack = attackList[attackRankID][diceRoll(rankCount)]
        return battleModeAttack
    }
    
    /// Returns an updated gameboard with the effects of an attack
    /// randomly chosen.
    func attack() -> (Gameboard, String) {
        
        let randomMove = chooseAttackID()
        
        switch randomMove {
            
        case .meWin:           // rank 1 (10%)
            return (meWin(), attackNames.meWin)
            
        case .youWin:          // rank 1 (10%)
            return (youWin(), attackNames.youWin)
            
        case .takeAllCorners:  // rank 2 (20%)
            return (takeAllCorners(), attackNames.takeAllCorners)
            
        case .takeAllMiddles:  // rank 2 (20%)
            return (takeAllMiddles(), attackNames.takeAllMiddles)
            
        case .switchLocations: // rank 3 (70%)
            return (switchLocations(), attackNames.switchLocations)
            
        case .jumpToCenter:    // rank 3 (70%)
            return (jumpToCenter(), attackNames.jumpToCenter)
            
        case .mixUp:           // rank 3 (70%)
            return (mixUp(), attackNames.mixUp)
            
        case .wipeOut:         // rank 3 (70%)
            return (wipeOut(), attackNames.wipeOut)
        }
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
