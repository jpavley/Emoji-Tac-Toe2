//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by John Pavley on 8/1/16.
//  Copyright © 2016 Epic Loot. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController {
    
    var gameEngine = GameEngine(noughtToken: "⭕️", crossToken: "❌")

    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var statusLabel: WKInterfaceLabel! // HINT: Only exists in 42mm layout
    
    @IBOutlet var button1: WKInterfaceButton!
    @IBOutlet var button2: WKInterfaceButton!
    @IBOutlet var button3: WKInterfaceButton!
    @IBOutlet var button4: WKInterfaceButton!
    @IBOutlet var button5: WKInterfaceButton!
    @IBOutlet var button6: WKInterfaceButton!
    @IBOutlet var button7: WKInterfaceButton!
    @IBOutlet var button8: WKInterfaceButton!
    @IBOutlet var button9: WKInterfaceButton!
    
    @IBAction func button1Action() {
        handleButtonPress(0)
    }
    
    @IBAction func button2Action() {
        handleButtonPress(1)
    }

    @IBAction func button3Action() {
        handleButtonPress(2)
    }
    
    @IBAction func button4Action() {
        handleButtonPress(3)
    }
    
    @IBAction func button5Action() {
        handleButtonPress(4)
    }

    @IBAction func button6Action() {
        handleButtonPress(5)
    }
    
    @IBAction func button7Action() {
        handleButtonPress(6)
    }
    
    @IBAction func button8Action() {
        handleButtonPress(7)
    }
    
    @IBAction func button9Action() {
        handleButtonPress(8)
    }
    
    func handleButtonPress(_ tag: Int) {
        
        if gameEngine.aiEnabled {
            return
        }
        
        if gameEngine.isGameOver() {
            newGame()
            return
        }
        
        if gameEngine.gameboard[tag] == .untouched {
            
            gameEngine.gameboard[tag] = gameEngine.activePlayerRole

            let titleText = (gameEngine.round == .playerOneRound)
                ? gameEngine.playerOne.token
                : gameEngine.playerTwo.token
            
            if let button = buttonForIndex(tag) {
                button.setTitle(titleText)
            }
            
            checkForEndGame()
            
            if !gameEngine.isGameOver() {
                gameEngine.nextRound()
                perform(#selector(self.aiTakeTurn), with: nil, afterDelay: 1)
            }
        }
    }
    
    func checkForEndGame() {
        
        let gameOver = checkForWinner()
        
        if gameOver {
            
            var winnerMark = ""
            var statusText = ""
            
            switch gameEngine.state {
                
            case .playerOneWin:
                winnerMark =  gameEngine.playerOne.token
                statusText = "\(winnerMark) Wins!"

            case .playerTwoWin:
                winnerMark =  gameEngine.playerOne.token
                statusText = "\(winnerMark) Wins!"

            case .draw:
                winnerMark =  "😔"
                statusText = " no winner \(winnerMark)"

            default:
                print("error in checkForEndGame()")
            }
            
            if statusLabel != nil {
                statusLabel.setText(statusText)
            } else {
                titleLabel.setText(statusText)
            }
            
        } else {
            
            gameEngine.nextRound()
            
            if statusLabel != nil {
                let nextMark = gameEngine.activePlayerToken
                statusLabel.setText("\(nextMark)'s turn")
            }
        }
    }
    
    func checkForWinner() -> Bool {
        
        gameEngine.checkForWinOrDraw()
        
        if gameEngine.isGameOver() {
            if let winningVector = searchForWin(gameEngine.gameboard) {
                for cell in winningVector {
                    
                    if let button = buttonForIndex(cell) {
                        button.setBackgroundColor(UIColor.gray)
                    }
                }
                return true
            }
        }
        return false
    }
    
    func newGame() {
        
        // start with random emojis
        let tokenOne = emojis[diceRoll(emojis.count/2)]
        let tokenTwo = emojis[diceRoll(emojis.count/2) + emojis.count/2]

        gameEngine.nextGame(noughtToken: tokenOne, crossToken: tokenTwo)
        
        titleLabel.setText("\(gameEngine.playerOne.token) vs \(gameEngine.playerTwo.token)")
        if statusLabel != nil {
            statusLabel.setText("\(gameEngine.activePlayerToken)'s turn")
        }
        
        for i in 0..<gameEngine.gameboard.count {
            if let button = buttonForIndex(i) {
                button.setTitle(calcTitleForButton(i))
                button.setBackgroundColor(UIColor.darkGray)
            }
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        newGame()
    }
    
    func calcTitleForButton(_ tag: Int) -> String {
        switch gameEngine.gameboard[tag] {
        case .untouched:
            return ""
        case .nought:
            return gameEngine.playerOne.token
        case .cross:
            return gameEngine.playerTwo.token
        }
    }
    
    func buttonForIndex(_ index: Int) -> WKInterfaceButton? {
        switch index {
        case 0:
            return button1
        case 1:
            return button2
        case 2:
            return button3
        case 3:
            return button4
        case 4:
            return button5
        case 5:
            return button6
        case 6:
            return button7
        case 7:
            return button8
        case 8:
            return button9
        default:
            print(index)
        }
        return nil
    }
    
    @objc func aiTakeTurn() {
        if let aiCell = aiChoose(gameEngine.gameboard, unpredicible: true) {
            if let aiButton = buttonForIndex(aiCell) {
                aiButton.setTitle(gameEngine.playerTwo.token)
                gameEngine.gameboard[aiCell] = .cross
                gameEngine.nextRound()
                checkForEndGame()
            }
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//        emojiGame.noughtMark = message["noughtMark"] as! String
//        emojiGame.crossMark = message["crossMark"] as! String
//        
//        titleLabel.setText("\(emojiGame.noughtMark) vs \(emojiGame.crossMark)")
//        
//        for i in 0..<emojiGame.gameBoard.count {
//            if let button = buttonForIndex(i) {
//                button.setTitle(calcTitleForButton(i))
//            }
//        }
//
//    }
    
}
