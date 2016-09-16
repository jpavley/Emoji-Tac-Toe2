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


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
    @available(watchOS 2.2, *)
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print(error)
    }

        
    var activePlayer:Player = .nought
    var watchSession:WCSession!
    var aiIsPlaying = false


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
        
        if aiIsPlaying {
            return
        }
        
        if emojiGame.gameOver {
            newGame()
            return
        }
        
        if emojiGame.gameBoard[tag] == .untouched {
            
            emojiGame.gameBoard[tag] = activePlayer

            let titleText = (activePlayer == .cross) ? emojiGame.crossMark : emojiGame.noughtMark
            
            if let button = buttonForIndex(tag) {
                button.setTitle(titleText)
            }
            
            checkForEndGame()
            
            if !emojiGame.gameOver {
                aiIsPlaying = true
                perform(#selector(self.aiTakeTurn), with: nil, afterDelay: 1)
            }
        }
    }
    
    func checkForEndGame() {
        if checkForWinner() {
            let winnerMark = (activePlayer == .cross) ? emojiGame.crossMark : emojiGame.noughtMark
            
            if statusLabel != nil {
                statusLabel.setText("\(winnerMark) Wins!")
            } else {
                titleLabel.setText("\(winnerMark) Wins!")
            }
            emojiGame.gameOver = true
            return
        }
        
        if !emojiGame.gameOver && !checkForUntouchedCells(emojiGame.gameBoard) {
            if statusLabel != nil {
                statusLabel.setText("no winner 😔")
            } else {
                titleLabel.setText("no winner 😔")
            }
            emojiGame.gameOver = true
            return
        }
        
        if !emojiGame.gameOver {
            activePlayer = (activePlayer == .cross) ? .nought : .cross
            
            if statusLabel != nil {
                let nextMark = (activePlayer == .cross) ? emojiGame.crossMark : emojiGame.noughtMark
                statusLabel.setText("\(nextMark)'s turn")
            }
        }

    }
    
    func checkForWinner() -> Bool {
        if let winningVector = seachForWin(emojiGame.gameBoard) {
            emojiGame.gameOver = true
            
            for cell in winningVector {
                
                if let button = buttonForIndex(cell) {
                    button.setBackgroundColor(UIColor.gray)
                }
            }
            return true
        }
        return false
    }
    
    func newGame() {
        
        // start with random emojis
        emojiGame.noughtMark = emojis[diceRoll(emojis.count/2)]
        emojiGame.crossMark = emojis[diceRoll(emojis.count/2) + emojis.count/2]
        
        emojiGame.gameBoard = freshGameBoard
        activePlayer = .nought
        titleLabel.setText("\(emojiGame.noughtMark) vs \(emojiGame.crossMark)")
        if statusLabel != nil {
            statusLabel.setText("\(emojiGame.noughtMark)'s turn")
        }
        
        for i in 0..<emojiGame.gameBoard.count {
            if let button = buttonForIndex(i) {
                button.setTitle(calcTitleForButton(i))
                button.setBackgroundColor(UIColor.darkGray)
            }
        }
        
        emojiGame.gameOver = false
        aiIsPlaying = false
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        newGame()
    }
    
    func calcTitleForButton(_ tag: Int) -> String {
        switch emojiGame.gameBoard[tag] {
        case .untouched:
            return ""
        case .nought:
            return emojiGame.noughtMark
        case .cross:
            return emojiGame.crossMark
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
    
    func aiTakeTurn() {
        if let aiCell = aiChoose(emojiGame.gameBoard) {
            if let aiButton = buttonForIndex(aiCell) {
                aiButton.setTitle(emojiGame.crossMark)
                emojiGame.gameBoard[aiCell] = .cross
                aiIsPlaying = false
                checkForEndGame()
            }
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if WCSession.isSupported() {
            watchSession = WCSession.default()
            watchSession.delegate = self
            watchSession.activate()
        }

    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        emojiGame.noughtMark = message["noughtMark"] as! String
        emojiGame.crossMark = message["crossMark"] as! String
        
        titleLabel.setText("\(emojiGame.noughtMark) vs \(emojiGame.crossMark)")
        
        for i in 0..<emojiGame.gameBoard.count {
            if let button = buttonForIndex(i) {
                button.setTitle(calcTitleForButton(i))
            }
        }

    }

}
