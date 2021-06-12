//
//  NewGameViewController.swift
//  Emo Tac Toe
//
//  Created by John Pavley on 7/15/16.
//  Copyright © 2016 Epic Loot. All rights reserved.
//

import UIKit
import WatchConnectivity

// TODO: Dismiss the keyboard after the user types one character!

class NewGameViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var player1Picker: UIPickerView!
    @IBOutlet weak var aiSwitch: UISwitch!
    @IBOutlet weak var mysteryModeSwitch: UISwitch!
    @IBOutlet weak var instantGameSwitch: UISwitch!
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var player1Button: UIButton!
    @IBOutlet weak var player2Button: UIButton!
    
    // HINT: Make all emojis available to both players
    var player1Data = [String]()
    var player2Data = [String]()
    
    @IBAction func mysteryModeAction(_ sender: AnyObject) {
        gameEngine.cheatingEnabled = !gameEngine.cheatingEnabled
        UserDefaults.standard.set(gameEngine.cheatingEnabled, forKey: "savedMysteryMode")
    }
    
    @IBAction func aiAction(_ sender: AnyObject) {
        gameEngine.aiEnabled = !gameEngine.aiEnabled
        UserDefaults.standard.set(gameEngine.aiEnabled, forKey: "savedUseAI")
        
        let player1Label = gameEngine.aiEnabled ? "Player \(gameEngine.playerOne.token)" : "Player 1 \(gameEngine.playerOne.token)"
        player1Button.setTitle(player1Label, for: .normal)
        
        let player2Label = gameEngine.aiEnabled ? "AI \(gameEngine.playerTwo.token)" : "Player 2 \(gameEngine.playerTwo.token)"
        player2Button.setTitle(player2Label, for: .normal)
        
        resetScorePrefs()
    }
    
    @IBAction func soundAction(_ sender: AnyObject) {
        gameEngine.soundEnabled = !gameEngine.soundEnabled
        UserDefaults.standard.set(gameEngine.soundEnabled, forKey: "savedUseSound")
    }
    
    @IBAction func player1Action(_ sender: Any) {
        jumpPicker(component: 0)
    }
    
    @IBAction func player2Action(_ sender: Any) {
        jumpPicker(component: 1)
    }
    
    /// There are over 80 sections.
    /// When the user touches the player1 or player 2 button
    /// we want to jump to the next section based on the index
    /// of the current row. Also we want to cycle through all
    /// the sections in order with each button press.
    func jumpPicker(component: Int) {
        
        let isPlayerOnePlayer = component == 0
        let currentRow = isPlayerOnePlayer ? gameEngine.playerOneRow : gameEngine.playerTwoRow
        let jumpRow = findNextSection(currentRow)
        let uniqueRow = ensureRowsAreUnique(component: component, row: jumpRow)
        
        if isPlayerOnePlayer {
            updatePlayerOne(uniqueRow)
        } else {
            updatePlayerTwo(uniqueRow)
        }
        
        resetScorePrefs()
        player1Picker.selectRow(uniqueRow, inComponent: component, animated: true)
        
        // print("component \(component), currentRow \(currentRow), jumpRow \(jumpRow)")
        
    }
    
    func findNextSection(_ currentRow: Int) -> Int {
        
        var nextRow = currentRow
        
        for section in emojiSections {
            if section > currentRow {
                nextRow = section
                break
            }
        }
        
        // nextRow was not set by the loop
        if nextRow == currentRow {
            nextRow = 0
        }
        
        return nextRow
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        player1Data = emojis
        player2Data = emojis
        
        let player1Label = gameEngine.aiEnabled ? "Player \(gameEngine.playerOne.token)" : "Player 1 \(gameEngine.playerOne.token)"
        player1Button.setTitle(player1Label, for: .normal)
        player1Picker.selectRow(gameEngine.playerOneRow, inComponent: 0, animated: true)

        let player2Label = gameEngine.aiEnabled ? "AI \(gameEngine.playerTwo.token)" : "Player 2 \(gameEngine.playerTwo.token)"
        player2Button.setTitle(player2Label, for: .normal)
        player1Picker.selectRow(gameEngine.playerTwoRow, inComponent: 1, animated: true)
        
        mysteryModeSwitch.setOn(gameEngine.cheatingEnabled, animated: true)
        aiSwitch.setOn(gameEngine.aiEnabled, animated: true)
        soundSwitch.setOn(gameEngine.soundEnabled, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return player1Data.count
        } else {
            return player2Data.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return player1Data[row]
        } else {
            return player2Data[row]
        }
    }
    
    // HINT: Make all emojis available to both players
    func ensureRowsAreUnique(component: Int, row: Int) -> Int {
        var possibleRow = row
        var comparisonRow = gameEngine.playerOneRow

        if component == 1 {
            comparisonRow = gameEngine.playerOneRow
        }
        
        if possibleRow == comparisonRow {
            if possibleRow == emojis.count - 1 {
                possibleRow = comparisonRow - 1
            } else {
                possibleRow = comparisonRow + 1
            }
            player1Picker.selectRow(possibleRow, inComponent: component, animated: true)
        }
        
        
        return possibleRow
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let uniqueRow = ensureRowsAreUnique(component: component, row: row)
        if component == 0 {
            updatePlayerOne(uniqueRow)
        } else {
            updatePlayerTwo(uniqueRow)
        }
        resetScorePrefs()
    }
    
    fileprivate func updatePlayerOne(_ uniqueRow: Int) {
        gameEngine.playerOneRow = uniqueRow
        gameEngine.playerOne.token = player1Data[uniqueRow]
        UserDefaults.standard.set(gameEngine.playerOneRow, forKey: "savedPlayer1Row")
        UserDefaults.standard.set(gameEngine.playerOne.token, forKey: "savedNoughtMark")
        let player1Label = gameEngine.aiEnabled ? "Player \(gameEngine.playerOne.token)" : "Player 1 \(gameEngine.playerOne.token)"
        player1Button.setTitle(player1Label, for: .normal)
    }
    
    fileprivate func updatePlayerTwo(_ uniqueRow: Int) {
        gameEngine.playerTwoRow = uniqueRow
        gameEngine.playerTwo.token = player2Data[uniqueRow]
        UserDefaults.standard.set(gameEngine.playerTwoRow, forKey: "savedPlayer2Row")
        UserDefaults.standard.set(gameEngine.playerTwo.token, forKey: "savedCrossMark")
        let player2Label = gameEngine.aiEnabled ? "AI \(gameEngine.playerTwo.token)" : "Player 2 \(gameEngine.playerTwo.token)"
        player2Button.setTitle(player2Label, for: .normal)
    }
    
    func resetScorePrefs() {
        gameEngine.score.playerOneWins = 0
        gameEngine.score.playerTwoWins = 0
        gameEngine.score.draws = 0
        
        UserDefaults.standard.set(gameEngine.score.playerOneWins, forKey: "savedNoughtWins")
        UserDefaults.standard.set(gameEngine.score.playerTwoWins, forKey: "savedCrossWins")
        UserDefaults.standard.set(gameEngine.score.draws, forKey: "savedDraws")
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        var label: UILabel
        if view != nil {
            label = view as! UILabel
        } else {
            label = UILabel()
        }
        
        var data:String?
        if component == 0 {
            data = player1Data[row]
        } else {
            // HINT: Make all emojis available to both players
            data = player2Data[row]
        }

        let title = NSAttributedString(string: data!, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 36.0, weight: UIFont.Weight.regular)])
        label.attributedText = title
        label.textAlignment = .center
        return label

    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    
}
