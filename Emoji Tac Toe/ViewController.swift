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

// HINT: User prefs
// TODO: Save as user prefs

enum GameStatus {
    case notStarted, starting, inProgress, playerPlaying, aiPlaying, win, tie
}

var noughtMark = "⭕️"
var crossMark = "❌"
var untouchedMark = "⬜️"

// HINT: Make all emojis available to both players
var player1Row = 0
var player2Row = 1

var useAI = true
var useSound = true
var mysteryMode = false
var playing = true

var noughtWins = 0
var crossWins = 0
var draws = 0

var gameboard:Gameboard = [.untouched, .untouched, .untouched,
                           .untouched, .untouched, .untouched,
                           .untouched, .untouched, .untouched]

var winLooseAVPlayer = AVAudioPlayer()
var noughtAVPlayer = AVAudioPlayer()
var crossAVPlayer = AVAudioPlayer()
var battleAVPlayer = AVAudioPlayer()


class ViewController: UIViewController {
        
    var activePlayer:Player = .untouched
    
    var aiIsPlaying = false {
        didSet {
            cheatButton.isEnabled = !aiIsPlaying
        }
    }
    var winner = Player.untouched
    
    var playerMark = ""
    var statusText = ""
        
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var cheatButton: UIButton!
    
    /// Share the current game as text.
    @IBAction func share(_ sender: AnyObject) {
        
        let ticTacToeGame = TicTacToeGame(gameboard: gameboard, noughtMark: noughtMark, crossMark: crossMark, untouchedMark: "⬜️", gameOver: false)
        let messageToShare = transformGameIntoText(game: ticTacToeGame)
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
        classicTTTButtonTouch(sender as! UIButton)
    }
    
    /// Initiate a BattleMode turn.
    @IBAction func cheatButtonAction(_ sender: Any) {
        battleModeTurn(sender as! UIButton)
    }
    
    /// Pan up: Sound on.
    /// Pan down: Sound off.
    @IBAction func panAction(_ sender: AnyObject) {
        if let pgr = sender as? UIPanGestureRecognizer {
            
            if pgr.state == .ended && playing {
                
                let velocity = pgr.velocity(in: view)

                if velocity.y > 0 {
                    useSound = false
                } else {
                    useSound = true
                }
                
                UserDefaults.standard.set(useSound, forKey: "savedUseSound")
            }
        }
    }
    
    func dontRespond(_ location: Int) -> Bool {
        var result = false
        
        if !playing {
            result = true
        }
        
        if aiIsPlaying {
            result = true
        }
        
        if gameboard[location] != .untouched {
            result = true
        }
        
        return result
    }
    
    func battleModeTurn(_ currentButton: UIButton) {
        
        setupThisTurn()
        
        // do the attack
        let battleMode = BattleMode(activePlayer: .cross, currentGameboard: gameboard)
        let (updatedGameboard, attackName) = battleMode.attack()
        
        // update gameboard and view with the results
        gameboard = updatedGameboard
        print(attackName)
        updateGameView()
        
        completeThisTurn()
        setupNextTurn()
    }
    
    fileprivate func setupThisTurn() {
        playerMark = getActivePlayerMark()
        playSoundForPlayer()
        neutralizeGameboard()
        updateStatus(.inProgress)
    }
    
    fileprivate func getActivePlayerMark() -> String {
        return activePlayer == .nought ? noughtMark : crossMark
    }
    
    fileprivate func playSoundForPlayer() {
//        battleAVPlayer.currentTime = 0
//        battleAVPlayer.play()
    }
    
    fileprivate func updateGameView() {
        
        var button:UIButton
        
        for tag in 1...9 {
            
            button = view.viewWithTag(tag) as! UIButton
            let location = tag - 1
            
            switch gameboard[location] {
                
            case .untouched:
                button.setTitle("", for: UIControlState())
                
            case .nought:
                button.setTitle(noughtMark, for: UIControlState())
                
            case .cross:
                button.setTitle(crossMark, for: UIControlState())
            }
        }
    }
    
    fileprivate func setupNextTurn() {
        if useAI && activePlayer == .cross && playing {
            activePlayer = getOpponent()
            aiIsPlaying = true
            perform(#selector(self.aiClassicTakeTurn), with: nil, afterDelay: 1)
        }
    }
    
    fileprivate func getOpponent()  -> Player {
        return activePlayer == .nought ? .cross : .nought
    }
    
    fileprivate func completeThisTurn() {
        if !checkForWinner() {
            checkForDraw()
        }
    }
    
    func playerTurn() {
        // TODO: Rewrite classicTTTButtonTouch
    }
    
    func aiTurn() {
        // TODO: Rewrite aiClassicTakeTurn
    }
    
    func classicTTTButtonTouch(_ currentButton: UIButton) {
        
        if dontRespond(currentButton.tag - 1) {
            return
        }
        
        neutralizeGameboard()
        
        updateStatus(.inProgress)
        
        // HINT: Update the screen
        
        // TODO: replace with creative commons sound effects
        
        if activePlayer == .nought {
            playerMark = noughtMark
            currentButton.setTitle(playerMark, for: UIControlState())
            
            if useSound {
//                noughtAVPlayer.currentTime = 0
//                noughtAVPlayer.play()
            }
            
        } else {
            playerMark = crossMark
            currentButton.setTitle(playerMark, for: UIControlState())
            
            if useSound {
//                crossAVPlayer.currentTime = 0
//                crossAVPlayer.play()
            }
        }
        
        // HINT: Update the game board
        let location = currentButton.tag - 1
        if playerMark == noughtMark {
            gameboard[location] = .nought
        } else {
            gameboard[location] = .cross
        }
        
        if !checkForWinner() {
            checkForDraw()
        }
        
        activePlayer = getOpponent()
        
        if useAI && activePlayer == .cross && playing {
            aiIsPlaying = true
            perform(#selector(self.aiClassicTakeTurn), with: nil, afterDelay: 1)
        }

    }
    
    @objc func aiClassicTakeTurn() {
        if let aiCell = aiChoose(gameboard, unpredicible: true) {
            neutralizeGameboard()
            updateStatus(.inProgress)
            playerMark = crossMark
            let tag = aiCell + 1
            let aiButton = view.viewWithTag(tag) as! UIButton
            aiButton.setTitle(playerMark, for: UIControlState())
            gameboard[aiCell] = .cross
            
            // TODO: replace with creative commons sound effect
            
            if useSound {
//                crossAVPlayer.currentTime = 0
//                crossAVPlayer.play()
            }
                        
            if !checkForWinner() {
                checkForDraw()
            }
            
            aiIsPlaying = false
            activePlayer = .nought
            
            let openCells = calcOpenCells(gameboard)
            if openCells.count == 1 {
                if !isThereAFinalWinningMove(gameboard, for: .nought) {
                    // HINT: No way for .nought to win
                    gameOverDraw()
                }
            }
        }
    }
    
    func gameOverDraw() {
        draws += 1
        updateTitle()
        updateStatus(.tie)
        UserDefaults.standard.set(draws, forKey: "savedDraws")
        presentGameOverAlert("Oops!")
    }
    
    func neutralizeGameboard() {
        var button:UIButton
        for tag in 1...9 {
            button = view.viewWithTag(tag) as! UIButton
            button.backgroundColor = getNormalButtonColor()
            let location = tag - 1
            if gameboard[location] == .untouched {
                button.setTitle("", for: UIControlState())
            }
        }
    }
    
    func getNormalButtonColor() -> UIColor {
        let normalColorValue:CGFloat = 224/255
        return UIColor(red: normalColorValue, green: normalColorValue, blue: normalColorValue, alpha: 1.0)
    }
    
    func checkForWinner() -> Bool {
        if let winningVector = searchForWin(gameboard) {
            playing = false
            winner = gameboard[winningVector[0]]
            
            if winner == .cross {
                crossWins += 1
            } else {
                noughtWins += 1
            }
            
            updateTitle()
            updateStatus(.win)
            
            UserDefaults.standard.set(noughtWins, forKey: "savedNoughtWins")
            UserDefaults.standard.set(crossWins, forKey: "savedCrossWins")
            
            var winningButton:UIButton
            var tag:Int
            for i in winningVector {
                tag = i + 1
                winningButton = view.viewWithTag(tag) as! UIButton
                winningButton.backgroundColor = UIColor.yellow
            }
            
            var alertTitle = "Congrats!"
            if winner == .cross && useAI {
                alertTitle = "Sorry!"
            }
            
            if useSound {
                winLooseAVPlayer.currentTime = 0
                winLooseAVPlayer.play()
            }
            
            presentGameOverAlert(alertTitle)
            
            return true
            
        } else {
            return false
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
    
    func checkForDraw() {
        
        if playing {
            playing = checkForUntouchedCells(gameboard)
            if !playing {
                // HINT: Game over!
                gameOverDraw()
            }
        }
    }
        
        
    func resetGame() {
        playing = true
        winner = Player.untouched
        activePlayer = .nought
                
        updateTitle()
        updateStatus(.starting)
        
        for i in 0..<gameboard.count {
            gameboard[i] = .untouched
        }

        var button:UIButton
        for tag in 1...9 {
            button = view.viewWithTag(tag) as! UIButton
            button.backgroundColor = getNormalButtonColor()
            button.setTitle("", for: UIControlState())
        }
        
        emojiGame = TicTacToeGame(gameboard: gameboard,
                                  noughtMark: noughtMark,
                                  crossMark: crossMark,
                                  untouchedMark: untouchedMark,
                                  gameOver: false)
    }
    
    func updateTitle() {
        titleLabel.text =  "\(noughtMark) vs \(crossMark)  \(noughtWins):\(crossWins):\(draws)"
    }
    
    func updateStatus(_ mode:GameStatus) {
        var result = ""
        switch mode {
        case .starting:
            // HINT: turn = current player
            if activePlayer == .nought {
                result = useAI ? "Player \(noughtMark)'s turn" : "Player 1 \(noughtMark)'s turn"
            } else {
                result = useAI ? "AI \(crossMark)'s turn" : "Player 2 \(crossMark)'s turn"
            }
        case .inProgress:
            // HINT: turn = next player
            if activePlayer == .nought {
                result = useAI ? "AI \(crossMark)'s turn" : "Player 2 \(crossMark)'s turn"
            } else {
                result = useAI ? "Player \(noughtMark)'s turn" : "Player 1 \(noughtMark)'s turn"
            }
        case .win:
            // TODO: This seems revered! If activePlayer is nought
            if activePlayer == .cross {
                result = useAI ? "AI \(crossMark) Wins" : "Player 2 \(crossMark)Wins"
            } else {
                result = useAI ? "Player \(noughtMark) Wins" : "Player 1 \(noughtMark) Wins"
            }
            if mysteryMode {
                result = result + " Battle Mode!"
            } else {
                result = result + "!"
            }
        case .tie:
            result = "no winner 😔"
        case .notStarted:
            print(mode)
        case .playerPlaying:
            print(mode)
        case .aiPlaying:
            print(mode)
        }
        
        statusLabel.text = result
        
    }
    
    /// Load user prefs from phone storage:
    /// - noughtMark:String
    /// - crossMark:String
    /// - player1Row:Int
    /// - player2Row:Int
    /// - useAI:Bool
    /// - useSound:Bool
    /// - mysteryMode:Bool
    /// - noughtWins:Int
    /// - crossWins:Int
    /// - draws:Int
    func restoreUserPrefs() {
        
        if let savedNoughtMark = UserDefaults.standard.object(forKey: "savedNoughtMark") {
            noughtMark = savedNoughtMark as! String
        }
        
        if let savedCrossMark = UserDefaults.standard.object(forKey: "savedCrossMark") {
            crossMark = savedCrossMark as! String
        }
        
        if let savedPlayer1Row = UserDefaults.standard.object(forKey: "savedPlayer1Row") {
            player1Row = savedPlayer1Row as! Int
        }

        if let savedPlayer2Row = UserDefaults.standard.object(forKey: "savedPlayer2Row") {
            player2Row = savedPlayer2Row as! Int
        }

        if let savedUseAI = UserDefaults.standard.object(forKey: "savedUseAI") {
            useAI = savedUseAI as! Bool
        }
        
        if let savedUseSound = UserDefaults.standard.object(forKey: "savedUseSound") {
            useSound = savedUseSound as! Bool
        }
        
        if let savedMysteryMode = UserDefaults.standard.object(forKey: "savedMysteryMode") {
            mysteryMode = savedMysteryMode as! Bool
        }
        
        if let savedNoughtWins = UserDefaults.standard.object(forKey: "savedNoughtWins") {
            noughtWins = savedNoughtWins as! Int
        }
        
        if let savedCrossWins = UserDefaults.standard.object(forKey: "savedCrossWins") {
            crossWins = savedCrossWins as! Int
        }
        
        if let savedDraws = UserDefaults.standard.object(forKey: "savedDraws") {
            draws = savedDraws as! Int
        }
        
        emojiGame.crossMark = crossMark
        emojiGame.noughtMark = noughtMark
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
        
        noughtMark = emojis[e1]
        crossMark = emojis[e2]
        player1Row = e1
        player2Row = e2
        
        UserDefaults.standard.set(player1Row, forKey: "savedPlayer1Row")
        UserDefaults.standard.set(noughtMark, forKey: "savedNoughtMark")
        UserDefaults.standard.set(player2Row, forKey: "savedPlayer2Row")
        UserDefaults.standard.set(crossMark, forKey: "savedCrossMark")
        
        // reset score
        noughtWins = 0
        crossWins = 0
        draws = 0
        
        UserDefaults.standard.set(noughtWins, forKey: "savedNoughtWins")
        UserDefaults.standard.set(crossWins, forKey: "savedCrossWins")
        UserDefaults.standard.set(draws, forKey: "savedDraws")


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

