//
//  ViewController.swift
//  Emo Tac Toe
//
//  Created by John Pavley on 7/13/16.
//  Copyright © 2016 Epic Loot. All rights reserved.
//

import UIKit
import WatchConnectivity
import AVFoundation

// HINT: Global variables shared by all ViewControlers in this project

var gameEngine = GameEngine(noughtToken: "⭕️", crossToken: "❌", untouchedToken: "⬜️")

var winLooseAVPlayer = AVAudioPlayer()
var noughtAVPlayer = AVAudioPlayer()
var crossAVPlayer = AVAudioPlayer()
var battleAVPlayer = AVAudioPlayer()


class ViewController: UIViewController {
        
    var battleModeAttackName = ""
        
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var cheatButton: UIButton!
    
    /// Share the current game as text.
    @IBAction func share(_ sender: AnyObject) {
        
        let messageToShare = transformGameIntoText(game: gameEngine.ticTacToeGame)
        let activityViewController = UIActivityViewController(activityItems: [messageToShare], applicationActivities: nil)
        
        // BFIX: Crash on iPad: "should have a non-nil sourceView or barButtonItem set before the
        //       presentation occurs" On iPad the activity view controller will be displayed as a
        //       popover using the popoverPresentationController Need to set the sourceView to the
        //       calling view
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            if NSObject.responds(to: #selector(getter: UIViewController.popoverPresentationController)) {
                activityViewController.popoverPresentationController?.sourceView = self.view
            }
        }

        present(activityViewController, animated: true, completion: {})

    }
    
    /// Initiate a normal turn.
    @IBAction func gameButtonAction(_ sender: AnyObject) {
        
        let currentButton = sender as! UIButton
        
        if dontRespond(currentButton.tag - 1) {
            // it's not the player's turn!
            return
        }
        
        playerTurn(currentButton: currentButton)
    }
    
    /// Initiate a BattleMode turn.
    @IBAction func cheatButtonAction(_ sender: Any) {
        battleModeTurn(sender as! UIButton)
    }
    
    /// Pan up: Sound on.
    /// Pan down: Sound off.
    @IBAction func panAction(_ sender: AnyObject) {
        if let pgr = sender as? UIPanGestureRecognizer {
            
            if pgr.state == .ended && !gameEngine.isGameOver() {
                
                let velocity = pgr.velocity(in: view)

                if velocity.y > 0 {
                    gameEngine.soundEnabled = false
                } else {
                    gameEngine.soundEnabled = true
                }
                
                UserDefaults.standard.set(gameEngine.soundEnabled, forKey: "savedUseSound")
            }
        }
    }
    
    func playerTurn(currentButton: UIButton) {
        
        // update the gameboard
        let location = currentButton.tag - 1
        gameEngine.gameboard[location] = gameEngine.activePlayerRole
        
        // update the view
        currentButton.setTitle(gameEngine.activePlayerToken, for: UIControlState())
        //updateGameView()
        
        completeTurn()
    }
    
    func battleModeTurn(_ currentButton: UIButton) {
        
        // do the attack
        let battleMode = BattleMode(activePlayer: .cross, currentGameboard: gameEngine.gameboard)
        let (updatedGameboard, attackName) = battleMode.attack()
        
        // update gameboard
        gameEngine.gameboard = updatedGameboard
        battleModeAttackName = attackName
        print(attackName)
        
        // update the view
        updateGameView()
        
        completeTurn()
    }
    
    @objc func aiTurn() {
        
        // do the attack
        if let aiCell = aiChoose(gameEngine.gameboard, unpredicible: true) {
            
            // update gameboard
            gameEngine.gameboard[aiCell] = gameEngine.activePlayerRole
            
            // update the view
            let tag = aiCell + 1
            let aiButton = view.viewWithTag(tag) as! UIButton
            aiButton.setTitle(gameEngine.activePlayerToken, for: UIControlState())
            
            completeTurn()
        }
    }
    
    fileprivate func completeTurn() {
        playSoundForPlayer()
        updateStatus()
        handleWinOrDraw()
        setupNextTurn()
    }
    
    fileprivate func dontRespond(_ location: Int) -> Bool {
        var result = false
        
        if gameEngine.isGameOver() {
            result = true
        }
        
        if gameEngine.aiEnabled && gameEngine.round == .playerTwoRound {
            result = true
        }
        
        if gameEngine.gameboard[location] != .untouched {
            result = true
        }
        
        return result
    }
    
    fileprivate func playSoundForPlayer() {
        
        if !gameEngine.soundEnabled {
            return
        }
        
        if gameEngine.cheatingEnabled {
            
            // battleAVPlayer.currentTime = 0
            // battleAVPlayer.play()
            
        } else if gameEngine.state == .playerOnePlaying  {
            
            // noughtAVPlayer.currentTime = 0
            // noughtAVPlayer.play()
            
        } else if gameEngine.state == .playerTwoPlaying{
            
            // crossAVPlayer.currentTime = 0
            // crossAVPlayer.play()
        }

    }
    
    fileprivate func updateGameView() {
        
        for tag in 1...9 {
            
            let button = view.viewWithTag(tag) as! UIButton
            let location = tag - 1
            
            switch gameEngine.gameboard[location] {
                
            case .untouched:
                button.setTitle("", for: UIControlState())
                
            case .nought:
                button.setTitle(gameEngine.playerOne.token, for: UIControlState())
                
            case .cross:
                button.setTitle(gameEngine.playerTwo.token, for: UIControlState())
            }
        }
    }
    
    fileprivate func setupNextTurn() {
        
        if !gameEngine.isGameOver() {
            gameEngine.nextRound()

            if gameEngine.round == .playerTwoRound && gameEngine.aiEnabled {
                perform(#selector(self.aiTurn), with: nil, afterDelay: 1)
            }
        }
    }
    
    fileprivate func neutralizeGameboard() {
        var button:UIButton
        for tag in 1...9 {
            button = view.viewWithTag(tag) as! UIButton
            button.backgroundColor = getNormalButtonColor()
            let location = tag - 1
            if gameEngine.gameboard[location] == .untouched {
                button.setTitle("", for: UIControlState())
            }
        }
    }
    
    func getNormalButtonColor() -> UIColor {
        let normalColorValue:CGFloat = 224/255
        return UIColor(red: normalColorValue, green: normalColorValue, blue: normalColorValue, alpha: 1.0)
    }
    
    func handleWinOrDraw() {
        
        gameEngine.checkForWinOrDraw()
        
        if gameEngine.isGameOver() {
            
            updateTitle()
            updateStatus()
            
            UserDefaults.standard.set(gameEngine.score.playerOneWins, forKey: "savedNoughtWins")
            UserDefaults.standard.set(gameEngine.score.playerTwoWins, forKey: "savedCrossWins")
                
            
            if gameEngine.soundEnabled && !(gameEngine.state == .draw) {
                winLooseAVPlayer.currentTime = 0
                winLooseAVPlayer.play()
            }
            
            let alertTitle = getAlertTitleForWin()
            presentGameOverAlert(alertTitle)

        }
    }
    
    fileprivate func getAlertTitleForWin() -> String {
        var alertTitle = ""
        
        switch gameEngine.state {
            
        case .playerOneWin:
            
            alertTitle = "Congrats!"
            hilightWinningVector()
            
        case .playerTwoWin:
            
            if gameEngine.aiEnabled {
                alertTitle = "Sorry!"
            } else {
                alertTitle = "Congrats!"
            }
            
            hilightWinningVector()
            
        case .draw:
            alertTitle = "Opps!"
            
        default:
            // TODO: can't possibly ever get here which means game state has too many states!
            ()
        }
        
        return alertTitle
    }
    
    fileprivate func hilightWinningVector() {
        if let winningVector = searchForWin(gameEngine.gameboard) {
            var winningButton:UIButton
            var tag:Int
            for i in winningVector {
                tag = i + 1
                winningButton = view.viewWithTag(tag) as! UIButton
                winningButton.backgroundColor = UIColor.yellow
            }
        }
    }
    
    func presentGameOverAlert(_ title: String) {
        let alert = UIAlertController(title: title, message: statusLabel.text, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
            (alert: UIAlertAction) in
            winLooseAVPlayer.stop()
        }))
        alert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: {
            (alert: UIAlertAction!) in
            winLooseAVPlayer.stop()
            self.resetGame()
        }))
        
        // HINT: Yes all this awful code just a moment to wait a bit before showing the alert
        let seconds = 1.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            self.present(alert, animated: true, completion: nil)
        })
        // TODO: Figure out how to use perform with Swift functions
        // perform(#selector(self.present(alert, animated: true, completion: nil)), with: nil, afterDelay: 1.0)

    }
    
    func resetGame() {
        
        gameEngine.nextGame()
        
        updateTitle()
        updateStatus()
        
        var button:UIButton
        for tag in 1...9 {
            button = view.viewWithTag(tag) as! UIButton
            button.backgroundColor = getNormalButtonColor()
            button.setTitle("", for: UIControlState())
        }
    }
    
    func updateTitle() {
        let playerOneToken = gameEngine.playerOne.token
        let playerTwoToken = gameEngine.playerTwo.token
        let playerOneWins = gameEngine.score.playerOneWins
        let playerTwoWins = gameEngine.score.playerTwoWins
        let draws = gameEngine.score.draws
        
        titleLabel.text =  "\(playerOneToken) vs \(playerTwoToken)  \(playerOneWins):\(playerTwoWins):\(draws)"
    }
    
    func updateStatus() {
        var playerOneName = ""
        var playerTwoName = ""
        
        if gameEngine.aiEnabled {
            playerOneName = "Player"
            playerTwoName = "AI"
        } else {
            playerOneName = "Player 1"
            playerTwoName = "Player 2"
        }
        
        let playerOneToken = gameEngine.playerOne.token
        let playerTwoToken = gameEngine.playerTwo.token
        
        var status = ""
        switch gameEngine.state {
            
        case .draw:
            status = "no winner 😔"
            
        case .playerTwoWin:
                status = "\(playerTwoName) \(playerTwoToken) Wins"
            
        case .playerTwoPlaying:
                status = "\(playerTwoName) \(playerTwoToken)'s turn"
            
        case .playerOneWin:
                status = "\(playerOneName) \(playerOneToken) Wins"
            
        case .playerOnePlaying:
                status = "\(playerOneName) \(playerOneToken)'s turn"
        }
        
        if gameEngine.cheatingEnabled {
            status += " with\(battleModeAttackName)"
        }
        
        statusLabel.text = status
    }
    
    /// Load user prefs from phone storage:
    /// var noughtMark: String
    /// var crossMark: String
    /// var player1Row: Int
    /// var player2Row: Int
    /// var useAI: Bool
    /// var useSound: Bool
    /// var mysteryMode: Bool
    /// var noughtWins: Int
    /// var crossWins: Int
    /// var draws: Int
    func restoreUserPrefs() {
        
        
        if let savedNoughtMark = UserDefaults.standard.object(forKey: "savedNoughtMark") {
            gameEngine.playerOne.token = savedNoughtMark as! String
        }
        
        if let savedCrossMark = UserDefaults.standard.object(forKey: "savedCrossMark") {
            gameEngine.playerTwo.token = savedCrossMark as! String
        }
        
        if let savedPlayer1Row = UserDefaults.standard.object(forKey: "savedPlayer1Row") {
            gameEngine.playerOneRow = savedPlayer1Row as! Int
        }

        if let savedPlayer2Row = UserDefaults.standard.object(forKey: "savedPlayer2Row") {
            gameEngine.playerTwoRow = savedPlayer2Row as! Int
        }

        if let savedUseAI = UserDefaults.standard.object(forKey: "savedUseAI") {
            gameEngine.aiEnabled = savedUseAI as! Bool
        }
        
        if let savedUseSound = UserDefaults.standard.object(forKey: "savedUseSound") {
            gameEngine.soundEnabled = savedUseSound as! Bool
        }
        
        if let savedMysteryMode = UserDefaults.standard.object(forKey: "savedMysteryMode") {
            gameEngine.cheatingEnabled = savedMysteryMode as! Bool
        }
        
        if let savedNoughtWins = UserDefaults.standard.object(forKey: "savedNoughtWins") {
            gameEngine.score.playerOneWins = savedNoughtWins as! Int
        }
        
        if let savedCrossWins = UserDefaults.standard.object(forKey: "savedCrossWins") {
            gameEngine.score.playerTwoWins = savedCrossWins as! Int
        }
        
        if let savedDraws = UserDefaults.standard.object(forKey: "savedDraws") {
            gameEngine.score.draws = savedDraws as! Int
        }
        
        // TODO: gameEngine.instantEnabled = useInstant
    }
    
    /// Returns an empty AVAudioPlayer if one can't be created from a file
    func createPlayer(name: String, extention: String) -> AVAudioPlayer {
        
        guard let path = Bundle.main.path(forResource: name, ofType: extention) else {
            print("can't find sound files \(name).\(extention) in bundle")
            return AVAudioPlayer()
        }
        
        do {
            return try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            
        }
        catch {
            print ("can't create player for \(path)")
            return AVAudioPlayer()
        }
    }
    
    
    func loadSoundsAndMusic() {
        
        winLooseAVPlayer = createPlayer(name: "Emoji Tac Toe Theme3", extention: ".mp3")
        
        // TODO: Replace with creative commons sound effects
        
//        noughtAVPlayer = createPlayer(name: "glossy_click_02", extention: ".wav")
//        noughtAVPlayer.prepareToPlay()
//        
//        crossAVPlayer = createPlayer(name: "glossy_click_03", extention: ".wav")
//        crossAVPlayer.prepareToPlay()
//        
//        battleAVPlayer = createPlayer(name: "bongweirdness", extention: ".wav")
//        battleAVPlayer.prepareToPlay()

    }
    
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        // HINT: Pick a random pair of emojis
        // HINT: Make all emojis available to both players
        
        let e1 = diceRoll(emojis.count)
        var e2 = diceRoll(emojis.count)
        
        if e1 == e2 {
            if e2 == emojis.count - 1 {
                e2 = e1 - 1
            } else {
                e2 = e1 + 1
            }
        }
        
        // TODO: Refactor into new game code
        
        gameEngine.playerOne.token = emojis[e1]
        gameEngine.playerTwo.token = emojis[e2]
        gameEngine.playerOneRow = e1
        gameEngine.playerTwoRow = e2
        
        UserDefaults.standard.set(gameEngine.playerOneRow, forKey: "savedPlayer1Row")
        UserDefaults.standard.set(gameEngine.playerOne.token, forKey: "savedNoughtMark")
        UserDefaults.standard.set(gameEngine.playerTwoRow, forKey: "savedPlayer2Row")
        UserDefaults.standard.set(gameEngine.playerTwo.token, forKey: "savedCrossMark")
        
        // reset score
        gameEngine.score.playerOneWins = 0
        gameEngine.score.playerTwoWins = 0
        gameEngine.score.draws = 0
        
        UserDefaults.standard.set(gameEngine.score.playerOneWins, forKey: "savedNoughtWins")
        UserDefaults.standard.set(gameEngine.score.playerTwoWins, forKey: "savedCrossWins")
        UserDefaults.standard.set(gameEngine.score.draws, forKey: "savedDraws")


        resetGame()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
//        if emojis == nil {
//            if let emojisFromFile = loadEmojisIntoArray(from: "emoji-ordering", fileType: "txt") {
//                print(emojisFromFile)
//                emojis = emojisFromFile
//            }
//            
//        }
        
        restoreUserPrefs()
        
        resetGame()
        
        loadSoundsAndMusic()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

