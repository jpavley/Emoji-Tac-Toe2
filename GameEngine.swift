//
//  GameEngine.swift
//  Emoji Tac Toe
//
//  Created by John Pavley on 1/30/18.
//  Copyright © 2018 Epic Loot. All rights reserved.
//

import Foundation

enum PlayerKind {
    case human, ai
}

typealias PlayerToken = String

/// Differenitate between Player Kind, Mark, and Token
/// Kind is human or machine (species?)
/// Role is is both the role (nought or cross) and the state of the board (untouched)
/// Token is the glyph used to represent the role/board state to the UI
struct GamePlayer {
    var kind: PlayerKind
    var role: PlayerRole
    var token: PlayerToken
}

struct GameScore {
    var playerOneWins: Int
    var playerTwoWins: Int
    var draws: Int
    var rounds: Int
}

enum GameState {
    case playerOnePlaying, playerTwoPlaying, playerOneWin, playerTwoWin, draw
}

enum GameRound {
    case playerOneRound, playerTwoRound
}

class GameEngine {
    var ticTacToeGame: TicTacToeGame
    
    var playerOne: GamePlayer
    var playerTwo: GamePlayer
    var round: GameRound
    
    var aiEnabled: Bool
    var cheatingEnabled: Bool
    var instantEnabled: Bool
    var soundEnabled: Bool
    var playerOneRow: Int
    var playerTwoRow: Int
    var untouchedToken: String
    
    var score: GameScore
    var state: GameState
    
    var gameboard: Gameboard {
        get {
            return ticTacToeGame.gameboard
        }
        set {
            ticTacToeGame.gameboard = newValue
        }
    }
    
    var activePlayerRole: PlayerRole {
        get {
            switch round {
                
            case .playerOneRound:
                return playerOne.role
                
            case .playerTwoRound:
                return playerTwo.role
            }
        }
    }
    
    var activePlayerToken: PlayerToken {
        get {
            switch round {
                
            case .playerOneRound:
                return playerOne.token
                
            case .playerTwoRound:
                return playerTwo.token
            }
        }
    }

        
    init(noughtToken: String, crossToken: String, untouchedToken: String) {
        ticTacToeGame = TicTacToeGame(from: "_________")

        playerOne = GamePlayer(kind: .human, role: .nought, token: noughtToken)
        playerTwo = GamePlayer(kind: .ai, role: .cross, token: crossToken)
        self.untouchedToken = untouchedToken
        round = .playerOneRound
        
        aiEnabled = true
        cheatingEnabled = false
        instantEnabled = false
        soundEnabled = true
        playerOneRow = 0
        playerTwoRow = 1
        
        score = GameScore(playerOneWins: 0, playerTwoWins: 0, draws: 0, rounds: 0)
        state = .playerOnePlaying
    }
        
    func isGameOver() -> Bool {
        return state == .playerOneWin || state == .playerTwoWin || state == .draw
    }
    
    func checkForWinOrDraw() {
        
        if let winningVector = searchForWin(ticTacToeGame.gameboard) {
            let winner = ticTacToeGame.gameboard[winningVector[0]]
            
            if playerOne.role == winner {
                score.playerOneWins += 1
                state = .playerOneWin
            } else if playerTwo.role == winner {
                score.playerTwoWins += 1
                state = .playerTwoWin
            }
            
            score.rounds += 1
            ticTacToeGame.gameOver = true
            
        } else if calcOpenCells(ticTacToeGame.gameboard).count == 0 {
            score.rounds += 1
            state = .draw
            ticTacToeGame.gameOver = true


        } else if isThereAFinalWinningMove(ticTacToeGame.gameboard, for: playerOne.role) ||
                  isThereAFinalWinningMove(ticTacToeGame.gameboard, for: playerTwo.role) {
            score.draws += 1
            state = .draw
            ticTacToeGame.gameOver = true
        }
        
        
    }
    
    func nextRound() {
        switch round {
            
        case .playerOneRound:
            round = .playerTwoRound
            state = .playerTwoPlaying
            
        case .playerTwoRound:
            round = .playerOneRound
            state = .playerOnePlaying
        }
    }
    
    func nextGame() {
        
        ticTacToeGame = TicTacToeGame(from: "_________")
        
        round = .playerOneRound
        state = .playerOnePlaying

    }
    
}
