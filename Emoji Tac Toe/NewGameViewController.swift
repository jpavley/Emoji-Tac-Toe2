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
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var player1Button: UIButton!
    @IBOutlet weak var player2Button: UIButton!
    
    // HINT: Make all emojis available to both players
    var player1Data = [String]()
    var player2Data = [String]()
    
    @IBAction func mysteryModeAction(_ sender: AnyObject) {
        mysteryMode = !mysteryMode
        UserDefaults.standard.set(mysteryMode, forKey: "savedMysteryMode")
    }
    
    @IBAction func aiAction(_ sender: AnyObject) {
        useAI = !useAI
        UserDefaults.standard.set(useAI, forKey: "savedUseAI")
        
        let player1Label = useAI ? "Player \(noughtMark)" : "Player 1 \(noughtMark)"
        player1Button.setTitle(player1Label, for: .normal)
        
        let player2Label = useAI ? "AI \(crossMark)" : "Player 2 \(crossMark)"
        player2Button.setTitle(player2Label, for: .normal)
        
        resetScorePrefs()
    }
    
    @IBAction func soundAction(_ sender: AnyObject) {
        useSound = !useSound
        UserDefaults.standard.set(useSound, forKey: "savedUseSound")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        player1Data = emojis
        player2Data = emojis
        
        let player1Label = useAI ? "Player \(noughtMark)" : "Player 1 \(noughtMark)"
        player1Button.setTitle(player1Label, for: .normal)
        player1Picker.selectRow(player1Row, inComponent: 0, animated: true)

        let player2Label = useAI ? "AI \(crossMark)" : "Player 2 \(crossMark)"
        player2Button.setTitle(player2Label, for: .normal)
        player1Picker.selectRow(player2Row, inComponent: 1, animated: true)
        
        mysteryModeSwitch.setOn(mysteryMode, animated: true)
        aiSwitch.setOn(useAI, animated: true)
        soundSwitch.setOn(useSound, animated: true)
        
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
        var comparisonRow = player2Row

        if component == 1 {
            comparisonRow = player1Row
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
        // HINT: Make all emojis available to both players
        let uniqueRow = ensureRowsAreUnique(component: component, row: row)
        if component == 0 {
            player1Row = uniqueRow
            noughtMark = player1Data[uniqueRow]
            UserDefaults.standard.set(player1Row, forKey: "savedPlayer1Row")
            UserDefaults.standard.set(noughtMark, forKey: "savedNoughtMark")
            let player1Label = useAI ? "Player \(noughtMark)" : "Player 1 \(noughtMark)"
            player1Button.setTitle(player1Label, for: .normal)
            emojiGame.noughtMark = noughtMark
        } else {
            // HINT: Make all emojis available to both players
            player2Row = uniqueRow
            crossMark = player2Data[uniqueRow]
            UserDefaults.standard.set(player2Row, forKey: "savedPlayer2Row")
            UserDefaults.standard.set(crossMark, forKey: "savedCrossMark")
            let player2Label = useAI ? "AI \(crossMark)" : "Player 2 \(crossMark)"
            player2Button.setTitle(player2Label, for: .normal)
            emojiGame.crossMark = crossMark
        }
        resetScorePrefs()
    }
    
    func resetScorePrefs() {
        noughtWins = 0
        crossWins = 0
        draws = 0
        
        UserDefaults.standard.set(noughtWins, forKey: "savedNoughtWins")
        UserDefaults.standard.set(crossWins, forKey: "savedCrossWins")
        UserDefaults.standard.set(draws, forKey: "savedDraws")
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as! UILabel!
        if label == nil {
            label = UILabel()
        }
        
        var data:String?
        if component == 0 {
            data = player1Data[row]
        } else {
            // HINT: Make all emojis available to both players
            data = player2Data[row]
        }

        let title = NSAttributedString(string: data!, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 36.0, weight: UIFontWeightRegular)])
        label?.attributedText = title
        label?.textAlignment = .center
        return label!

    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    
}
