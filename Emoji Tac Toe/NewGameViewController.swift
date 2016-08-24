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

class NewGameViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, WCSessionDelegate {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var player1Label: UILabel!
    @IBOutlet weak var player1Picker: UIPickerView!
    @IBOutlet weak var player2Label: UILabel!
    @IBOutlet weak var aiSwitch: UISwitch!
    @IBOutlet weak var mysteryModeSwitch: UISwitch!
    
    let player1Data = ["⭕️","🍎","⚾️","😀","😺","🤖",
                       "💤","👍","👁","👶","👩","👳",
                       "💪","👤","👸","🚶","😱","🤘",
                       "👠","🎩","👜","💍","👓","👚",
                       "🐶","🐭","🐰","🐼","🐯","🐮",
                       "🐔","🐦","🐥","🐗","🦄","🐛",
                       "🐆","🐃","🐄","🐫","🐐","🐑",
                       "🐖","🐁","🦃","🐕","🐈","🐿"]
    let player2Data = ["❌","🍊","🏈","😩","😈","👻",
                       "💩","👎","👄","👦","👨","🎅",
                       "🙏","👥","👰","🏃","😡","🖖",
                       "👞","🎓","💼","👑","🕶","👔",
                       "🐱","🐹","🐻","🐨","🦁","🐷",
                       "🐧","🐤","🐣","🐴","🐝","🐌",
                       "🐅","🐂","🐪","🐘","🐏","🐎",
                       "🐀","🐓","🕊","🐩","🐇","🐉"]
    
    var watchSession: WCSession!

    @IBAction func mysteryModeAction(sender: AnyObject) {
        mysteryMode = !mysteryMode
        NSUserDefaults.standardUserDefaults().setObject(mysteryMode, forKey: "savedMysteryMode")
    }
    
    @IBAction func aiAction(sender: AnyObject) {
        useAI = !useAI
        NSUserDefaults.standardUserDefaults().setObject(useAI, forKey: "savedUseAI")
        player1Label.text = useAI ? "Player \(noughtMark)" : "Player 1 \(noughtMark)"
        player2Label.text = useAI ? "AI \(crossMark)" : "Player 2 \(crossMark)"
        
        resetScorePrefs()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        player1Label.text = useAI ? "Player \(noughtMark)" : "Player 1 \(noughtMark)"
        player1Picker.selectRow(player1Row, inComponent: 0, animated: true)

        player2Label.text = useAI ? "AI \(crossMark)" : "Player 2 \(crossMark)"
        player1Picker.selectRow(player2Row, inComponent: 1, animated: true)
        
        mysteryModeSwitch.setOn(mysteryMode, animated: true)
        aiSwitch.setOn(useAI, animated: true)
        
        if WCSession.isSupported() {
            watchSession = WCSession.defaultSession()
            watchSession.delegate = self
            watchSession.activateSession()
            watchSession.sendMessage(["noughtMark":noughtMark, "crossMark":crossMark], replyHandler: nil, errorHandler: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return player1Data.count
        } else {
            return player2Data.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return player1Data[row]
        } else {
            return player2Data[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            noughtMark = player1Data[row]
            player1Row = row
            NSUserDefaults.standardUserDefaults().setObject(player1Row, forKey: "savedPlayer1Row")
            NSUserDefaults.standardUserDefaults().setObject(noughtMark, forKey: "savedNoughtMark")
            player1Label.text = useAI ? "Player \(noughtMark)" : "Player 1 \(noughtMark)"
            emojiGame.noughtMark = noughtMark
        } else {
            crossMark = player2Data[row]
            player2Row = row
            NSUserDefaults.standardUserDefaults().setObject(player2Row, forKey: "savedPlayer2Row")
            NSUserDefaults.standardUserDefaults().setObject(crossMark, forKey: "savedCrossMark")
            player2Label.text = useAI ? "AI \(crossMark)" : "Player 2 \(crossMark)"
            emojiGame.crossMark = crossMark
        }
        if WCSession.isSupported() {
            watchSession.sendMessage(["noughtMark":noughtMark, "crossMark":crossMark], replyHandler: nil, errorHandler: nil)
        }
        resetScorePrefs()
    }
    
    func resetScorePrefs() {
        noughtWins = 0
        crossWins = 0
        draws = 0
        
        NSUserDefaults.standardUserDefaults().setObject(noughtWins, forKey: "savedNoughtWins")
        NSUserDefaults.standardUserDefaults().setObject(crossWins, forKey: "savedCrossWins")
        NSUserDefaults.standardUserDefaults().setObject(draws, forKey: "savedDraws")
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var label = view as! UILabel!
        if label == nil {
            label = UILabel()
        }
        
        var data:String?
        if component == 0 {
            data = player1Data[row]
        } else {
            data = player2Data[row]
        }

        let title = NSAttributedString(string: data!, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(36.0, weight: UIFontWeightRegular)])
        label.attributedText = title
        label.textAlignment = .Center
        return label

    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }

}
