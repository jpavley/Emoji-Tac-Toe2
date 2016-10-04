//
//  EmojiTicTacToe.swift
//  Emo Tac Toe
//
//  Created by John Pavley on 7/26/16.
//  Copyright © 2016 Epic Loot. All rights reserved.
//

import Foundation

enum Player:String {
    case untouched, nought, cross
}

enum GameStatus {
    case notStarted, starting, inProgress, playerPlaying, aiPlaying, win, tie
}

// HINT: Make all emojis available to both players
let emojis = ["⭕️","❌","⚾️","😀","😺","🤖",
              "🍎","🍊","🏈","😩","😈","👻",
              "💤","👍","👁","👶","👩","👳",
              "💩","👎","👄","👦","👨","🎅",
              "💪","👤","👸","🚶","😱","🤘",
              "🙏","👥","👰","🏃","😡","🖖",
              "👠","🎩","👜","💍","👓","👚",
              "👞","🎓","💼","👑","🕶","👔",
              "🐶","🐭","🐰","🐼","🐯","🐮",
              "🐔","🐦","🐥","🐗","🦄","🐛",
              "🐱","🐹","🐻","🐨","🦁","🐷",
              "🐆","🐃","🐄","🐫","🐐","🐑",
              "🐖","🐁","🦃","🐕","🐈","🐿",
              "🐅","🐂","🐪","🐘","🐏","🐎",
              "🐀","🐓","🕊","🐩","🐇","🐉"]


let winningVectors = [
    [0,1,2], // row 1
    [3,4,5], // row 2
    [6,7,8], // rew 3
    [0,3,6], // col 1
    [1,4,7], // col 2
    [2,5,8], // col 3
    [0,4,8], // diag 1
    [2,4,6]  // diag 2
]

struct TicTacToeGame {
    var gameBoard:[Player]
    var noughtMark:String
    var crossMark:String
    var gameOver:Bool
}

func transformGameIntoText(_ game: TicTacToeGame) -> String {
    var result = ""
    
    for (index, cell) in game.gameBoard.enumerated() {
        
        switch cell {
        case .untouched:
            result += "⬜️ "
        case .nought:
            result += game.noughtMark + " "
        case .cross:
            result += game.crossMark + " "
        }
        
        if index == 2 || index == 5 || index == 8 {
            result += "\n"
        }
    }
    
    return result
}

func seachForWin(_ gameBoard:[Player]) -> [Int]? {
    
    for vector in winningVectors {
        if gameBoard[vector[0]] != .untouched && gameBoard[vector[0]] == gameBoard[vector[1]] && gameBoard[vector[0]] == gameBoard[vector[2]] {
            return vector
        }
    }
    return nil
}

func seachForWinForPlayer(_ board:[Player], player:Player) -> Bool {
    
    for vector in winningVectors {
        if board[vector[0]] == player && board[vector[0]] != .untouched && board[vector[0]] == board[vector[1]] && board[vector[0]] == board[vector[2]] {
            return true
        }
    }
    return false
}

func checkForWayToWin(_ gameBoard:[Player]) -> Bool {
    
    return true // is broken!
    
    // TODO: make func calcOpenCells(gameBoard:[Player])
    var openCells = [Int]()
    for (index, cell) in gameBoard.enumerated() {
        if cell == .untouched {
            openCells.append(index)
        }
    }
    
    // if there is one open cell
    if openCells.count == 1 {
        if !seachForWinForPlayer(gameBoard, player: .nought) {
            // DBUG: when there is away for the human player to win search for win for player doesn't find it!
            // no way for human player to win
            return false
        }
    }
    
    return true

}

func checkForUntouchedCells(_ gameBoard:[Player]) -> Bool {
    
    for cell in gameBoard {
        if cell == .untouched {
            return true
        }
    }
    return false

}

/// Returns a move that the AI wants to make
func aiChoose(_ gameBoard:[Player]) -> Int? {
    
    var result:Int?
    
    var openCells = [Int]()
    for (index, cell) in gameBoard.enumerated() {
        if cell == .untouched {
            openCells.append(index)
        }
    }
    
    var occupiedCells = [Int]()
    for (index, cell) in gameBoard.enumerated() {
        if cell == .nought {
            occupiedCells.append(index)
        }
    }
    
    var ownedCells = [Int]()
    for (index, cell) in gameBoard.enumerated() {
        if cell == .cross {
            ownedCells.append(index)
        }
    }
    
    if openCells.count > 0 {
        
        // x% of the time be unpredictible
        if result == nil {
            let chanceToBeRandom = diceRoll(20)
            if chanceToBeRandom <= 3 {
                result = openCells.count > 0 ? openCells[diceRoll(openCells.count)] : nil
                //print("chanceToBeRandom \(chanceToBeRandom), result \(result)")
            }
        }
        
        // Search for blocking move
        if result == nil {
            for cell in openCells {
                var testGameboard = gameBoard
                testGameboard[cell] = .nought
                
                if seachForWinForPlayer(testGameboard, player: .nought) {
                    result = cell
                }
            }
        }
        
        // If player has middle and corner and AI has oposite corner take another corner
        if result == nil {
            let results1 = [0,2,6,8].filter {occupiedCells.contains($0)}
            let flag1 = occupiedCells.contains(4)
            let results2 = [0,2,6,8].filter {ownedCells.contains($0)}
            
            if results1.count > 0 && flag1 && results2.count > 0 {
                let results3 = [0,2,6,8].filter {openCells.contains($0)}
                result = results3.count > 0 ? results3[diceRoll(results3.count)] : nil
            }
        }
        
        // AI has a corner grab a middle
        if result == nil {
            let results1 = [0,2,6,8].filter {ownedCells.contains($0)}
            if results1.count > 0 {
                let results2 = [1,3,5,7].filter {openCells.contains($0)}
                result = results2.count > 0 ? results2[diceRoll(results2.count)] : nil
            }
        }
        
        // Player has a middle grab a corner
        if result == nil {
            let results1 = [1,3,5,7].filter {occupiedCells.contains($0)}
            if results1.count > 0 {
                let results2 = [0,2,6,8].filter {openCells.contains($0)}
                result = results2.count > 0 ? results2[diceRoll(results2.count)] : nil
            }
        }
        
        // Grab the center if it's open
        if result == nil {
            if openCells.contains(4) {
                result = 4
            }
        }
        
        // if AI has the center grab middle position
        if result == nil {
            if ownedCells.contains(4) {
                let results = [1,3,5,7].filter {openCells.contains($0)}
                result = results[diceRoll(results.count)]
            }
        }
        
        // Search for a corner opposite the opponent
        if result == nil {
            if occupiedCells.contains(0) {
                if openCells.contains(8) {
                    result = 8
                }
            } else if occupiedCells.contains(2) {
                if openCells.contains(6) {
                    result = 6
                }
            } else if occupiedCells.contains(6) {
                if openCells.contains(2) {
                    result = 2
                }
            } else if occupiedCells.contains(8) {
                if openCells.contains(0) {
                    result = 0
                }
            }
        }
        
        // Search for winning move
        for cell in openCells {
            var testGameboard = gameBoard
            testGameboard[cell] = .cross
            if seachForWinForPlayer(testGameboard, player: .cross) {
                result = cell
            }
        }
        
        // Search for a corner
        if result == nil {
            let results = [0,2,6,8].filter {openCells.contains($0)}
            result = results.count > 0 ? results[diceRoll(results.count)] : nil
        }
        
        // Search for random moves
        if result == nil {
            let diceRoll = Int(arc4random_uniform(UInt32(openCells.count)))
            result = openCells[diceRoll] // DBUG: just return a random open cell for now
        }
    } else {
        
        result = nil
    }
    
    return result
}

func diceRoll(_ chances: Int) -> Int {
    return Int(arc4random_uniform(UInt32(chances)))
}


let freshGameBoard:[Player] = [.untouched, .untouched, .untouched,
                               .untouched, .untouched, .untouched,
                               .untouched, .untouched, .untouched]

var emojiGame = TicTacToeGame(gameBoard:freshGameBoard,
                              noughtMark: "⭕️",
                              crossMark: "❌",
                              gameOver: false)



