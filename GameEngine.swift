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

struct GamePlayer {
    var kind: PlayerKind
    var mark: Player
}

struct GameScore {
    var playerOneWins: Int
    var playerTwoWins: Int
    var draws: Int
    var rounds: Int
}

enum GameState {
    case playerOnePlaying, playerTwoPlaying, aiPlaying, playerOneWin, playerTwoWin, draw
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
    
    var score: GameScore
    var state: GameState
    
    init() {
        ticTacToeGame = TicTacToeGame(from: "_________")

        playerOne = GamePlayer(kind: .human, mark: .nought)
        playerTwo = GamePlayer(kind: .ai, mark: .cross)
        round = .playerOneRound
        
        aiEnabled = true
        cheatingEnabled = false
        instantEnabled = false
        
        score = GameScore(playerOneWins: 0, playerTwoWins: 0, draws: 0, rounds: 0)
        state = .playerOnePlaying
    }
        
    func isGameOver() -> Bool {
        return state == .playerOneWin || state == .playerTwoWin || state == .draw
    }
    
    func checkForWinOrDraw() {
        
        if let winningVector = searchForWin(ticTacToeGame.gameboard) {
            let winner = ticTacToeGame.gameboard[winningVector[0]]
            
            if playerOne.mark == winner {
                score.playerOneWins += 1
                state = .playerOneWin
            } else if playerTwo.mark == winner {
                score.playerTwoWins += 1
                state = .playerTwoWin
            }
            
            score.rounds += 1
            ticTacToeGame.gameOver = true
            
        } else if checkForUntouchedCells(ticTacToeGame.gameboard) {
            score.rounds += 1
            state = .draw
            ticTacToeGame.gameOver = true

        } else if isThereAFinalWinningMove(ticTacToeGame.gameboard, for: playerOne.mark) ||
                  isThereAFinalWinningMove(ticTacToeGame.gameboard, for: playerTwo.mark) {
            score.draws += 1
            state = .draw
            ticTacToeGame.gameOver = true
        }
        
        
    }
    
    func nextRound() {
        switch round {
            
        case .playerOneRound:
            round = .playerTwoRound
            
            if aiEnabled {
                state = .aiPlaying
            } else {
                state = .playerTwoPlaying
            }
            
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
