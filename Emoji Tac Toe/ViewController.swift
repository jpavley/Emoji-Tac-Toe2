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

var noughtMark = "⭕️"
var crossMark = "❌"
var player1Row = 0 // Picker Index number
var player2Row = 0 // Picker Index number
var useAI = true
var useSound = true
var mysteryMode = false
var playing = true

var noughtWins = 0
var crossWins = 0
var draws = 0

var gameBoard:[Player] = [.untouched, .untouched, .untouched,
                          .untouched, .untouched, .untouched,
                          .untouched, .untouched, .untouched]

var winLooseAVPlayer = AVAudioPlayer()
var noughtAVPlayer = AVAudioPlayer()
var crossAVPlayer = AVAudioPlayer()
var battleAVPlayer = AVAudioPlayer()


class ViewController: UIViewController, WCSessionDelegate {
        
    var activePlayer:Player = .untouched
    
    var aiIsPlaying = false
    var winner = Player.untouched
    
    var playerMark = ""
    var statusText = ""
    
    var watchSession: WCSession!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBAction func share(sender: AnyObject) {
        
        let game = TicTacToeGame(gameBoard: gameBoard,
                                 noughtMark: noughtMark,
                                 crossMark: crossMark,
                                 gameOver: false)
        
        let messageToShare = transformGameIntoText(game)
        let activityViewController = UIActivityViewController(activityItems: [messageToShare], applicationActivities: nil)
        
        // BFIX: Crash on iPad: "should have a non-nil sourceView or barButtonItem set before the presentation occurs"
        //       On iPad the activity view controller will be displayed as a popover using the popoverPresentationController
        //       Need to set the sourceView to the calling view
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            
            if activityViewController.respondsToSelector(Selector("popoverPresentationController")) {
                activityViewController.popoverPresentationController?.sourceView = self.view
            }
        }

        presentViewController(activityViewController, animated: true, completion: {})

    }
    
    
    
    @IBAction func gameButtonAction(sender: AnyObject) {
        
        classicTTTButtonTouch(sender as! UIButton)
    }
    
    
    @IBAction func longPressAction(sender: AnyObject) {
        if let lpgr = sender as? UILongPressGestureRecognizer {
            if lpgr.state == .Began {
                if mysteryMode {
                    battleModeAttack((lpgr.view?.tag)!)
                }
            }
        }
    }
    
    @IBAction func panAction(sender: AnyObject) {
        if let pgr = sender as? UIPanGestureRecognizer {
            if pgr.state == .Began {
                if playing {
                    let velocity = pgr.velocityInView(view)
                    if velocity.y > 0 {
                        useSound = false
                    } else {
                        useSound = true
                    }
                    NSUserDefaults.standardUserDefaults().setObject(useSound, forKey: "savedUseSound")
                }
            }
        }
    }
    
    
    func battleModeAttack(buttonID: Int) {
        
        if gameBoard[buttonID - 1] != activePlayer {
            // HINT: ignore if activePlayer is pressing on other player's button!
            return
        }
        
        if activePlayer == .nought {
            playerMark = noughtMark
        } else {
            playerMark = crossMark
        }

        
        let battleEmojis = ["🤖", "👻","😱", "😡","🚶", "🏃","🐿", "🐉","👸", "👰", "🦄", "🐝"]
        if !battleEmojis.contains(playerMark) {
            return
        }
        
        if useSound {
            battleAVPlayer.currentTime = 0
            battleAVPlayer.play()
        }

        
        // set up this turn
        neutralizeGameboard()
        updateStatus(.inProgress)
        
        // do the special move
        switch playerMark {
        case "🤖", "👻":
            replicateAllOpenCells(buttonID)
        case "😱", "😡":
            switchLocations(buttonID)
        case "🚶", "🏃":
            takeAllCorners(buttonID)
        case "🐿", "🐉":
            jumpToCenter(buttonID)
        case "👸", "👰":
            takeAllMiddles(buttonID)
        case "🦄", "🐝":
            jumpToRandom(buttonID)
        default:
            nop()
        }
        
        // prep for next turn
        if activePlayer == .nought {
            activePlayer = .cross
        } else {
            activePlayer = .nought
        }
        
        checkForWinner()
        checkForDraw()
        if useAI && activePlayer == .cross {
            if !playing {
                return
            }
            aiIsPlaying = true
            performSelector(#selector(self.aiClassicTakeTurn), withObject: nil, afterDelay: 1)
        }

    }
    
    func nop() {
        
    }
    
    func replicateAllOpenCells(buttonID: Int) {
        for i in 0..<gameBoard.count {
            if gameBoard[i] == .untouched {
                gameBoard[i] = activePlayer
                let targetButton = view.viewWithTag(i + 1) as! UIButton
                targetButton.setTitle(playerMark, forState: .Normal)
            }
        }
    }
    
    func switchLocations(buttonID: Int) {
        for i in 0..<gameBoard.count {
            if gameBoard[i] == .nought {
                gameBoard[i] = .cross
                let targetButton = view.viewWithTag(i + 1) as! UIButton
                targetButton.setTitle(crossMark, forState: .Normal)
            } else if (gameBoard[i] != .untouched) {
                gameBoard[i] = .nought
                let targetButton = view.viewWithTag(i + 1) as! UIButton
                targetButton.setTitle(noughtMark, forState: .Normal)
            }
        }

    }
    
    func takeAllCorners(buttonID: Int) {
        // HINT: erase mark at current colition
        let sourceButton = view.viewWithTag(buttonID) as! UIButton
        sourceButton.setTitle("", forState: .Normal)
        let sourceLocation = buttonID - 1
        gameBoard[sourceLocation] = .untouched
        
        // HINT: replace mark at the center
        let cornerIDs = [1,3,7,9]
        for i in 0..<cornerIDs.count {
            let targetButton = view.viewWithTag(cornerIDs[i]) as! UIButton
            targetButton.setTitle(playerMark, forState: .Normal)
            let targetLocation = cornerIDs[i] - 1
            gameBoard[targetLocation] = activePlayer
        }
    }
    
    func takeAllMiddles(buttonID: Int) {
        // HINT: erase mark at current colition
        let sourceButton = view.viewWithTag(buttonID) as! UIButton
        sourceButton.setTitle("", forState: .Normal)
        let sourceLocation = buttonID - 1
        gameBoard[sourceLocation] = .untouched
        
        // HINT: replace mark at the center
        let cornerIDs = [2,4,6,8]
        for i in 0..<cornerIDs.count {
            let targetButton = view.viewWithTag(cornerIDs[i]) as! UIButton
            targetButton.setTitle(playerMark, forState: .Normal)
            let targetLocation = cornerIDs[i] - 1
            gameBoard[targetLocation] = activePlayer
        }
    }

    func jumpToCenter(buttonID: Int) {
        // HINT: erase mark at current colition
        let sourceButton = view.viewWithTag(buttonID) as! UIButton
        sourceButton.setTitle("", forState: .Normal)
        let sourceLocation = buttonID - 1
        gameBoard[sourceLocation] = .untouched
        
        // HINT: replace mark at the center
        let centerID = 5
        let targetButton = view.viewWithTag(centerID) as! UIButton
        targetButton.setTitle(playerMark, forState: .Normal)
        let targetLocation = centerID - 1
        gameBoard[targetLocation] = activePlayer
    }
    
    func jumpToRandom(buttonID: Int) {
        // HINT: erase mark at current colition
        let sourceButton = view.viewWithTag(buttonID) as! UIButton
        sourceButton.setTitle("", forState: .Normal)
        let sourceLocation = buttonID - 1
        gameBoard[sourceLocation] = .untouched
        
        // HINT: replace mark at the center
        let potentialButtonIDs = [1,2,3,4,5,6,7,8,9].filter {$0 != buttonID}
        let randomIndex = diceRoll(potentialButtonIDs.count)
        let randomButtonID = potentialButtonIDs[randomIndex]
        let targetButton = view.viewWithTag(randomButtonID) as! UIButton
        targetButton.setTitle(playerMark, forState: .Normal)
        let targetLocation = randomButtonID - 1
        gameBoard[targetLocation] = activePlayer
    }
    
    func stealVictory(buttonID: Int) {
        // if the user loses it turns the loss into a win
    }
    
    func dontRespond(location: Int) -> Bool {
        var result = false
        
        if !playing {
            result = true
        }
        
        if aiIsPlaying {
            result = true
        }
        
        if gameBoard[location] != .untouched {
            result = true
        }
        
        return result
    }
    
    func classicTTTButtonTouch(currentButton: UIButton) {
        
        if dontRespond(currentButton.tag - 1) {
            return
        }
        
        neutralizeGameboard()
        
        updateStatus(.inProgress)
        
        // HINT: Update the screen
        if activePlayer == .nought {
            playerMark = noughtMark
            currentButton.setTitle(playerMark, forState: .Normal)
            
            if useSound {
                noughtAVPlayer.currentTime = 0
                noughtAVPlayer.play()
            }
            
            activePlayer = .cross
        } else {
            playerMark = crossMark
            currentButton.setTitle(playerMark, forState: .Normal)
            
            if useSound {
                crossAVPlayer.currentTime = 0
                crossAVPlayer.play()
            }

            activePlayer = .nought
        }
        
        // HINT: Update the game board
        let location = currentButton.tag - 1
        if playerMark == noughtMark {
            gameBoard[location] = .nought
        } else {
            gameBoard[location] = .cross
        }
        
        checkForWinner()
        checkForDraw()
        
        if useAI && activePlayer == .cross {
            if !playing {
                return
            }
            aiIsPlaying = true
            performSelector(#selector(self.aiClassicTakeTurn), withObject: nil, afterDelay: 1)
        }

    }
    
    func aiClassicTakeTurn() {
        if let aiCell = aiChoose(gameBoard) {
            neutralizeGameboard()
            updateStatus(.inProgress)
            playerMark = crossMark
            let tag = aiCell + 1
            let aiButton = view.viewWithTag(tag) as! UIButton
            aiButton.setTitle(playerMark, forState: .Normal)
            activePlayer = .nought
            gameBoard[aiCell] = .cross
            
            if useSound {
                crossAVPlayer.currentTime = 0
                crossAVPlayer.play()
            }
            
            checkForWinner()
            checkForDraw()
            aiIsPlaying = false
        }
    }
    
    func neutralizeGameboard() {
        var button:UIButton
        for tag in 1...9 {
            button = view.viewWithTag(tag) as! UIButton
            button.backgroundColor = getNormalButtonColor()
            let location = tag - 1
            if gameBoard[location] == .untouched {
                button.setTitle("", forState: .Normal)
            }
        }
    }
    
    func getNormalButtonColor() -> UIColor {
        let normalColorValue:CGFloat = 224/255
        return UIColor(red: normalColorValue, green: normalColorValue, blue: normalColorValue, alpha: 1.0)
    }
    
    func checkForWinner() {
        if let winningVector = seachForWin(gameBoard) {
            playing = false
            winner = gameBoard[winningVector[0]]
            
            if winner == .cross {
                crossWins += 1
            } else {
                noughtWins += 1
            }
            
            updateTitle()
            updateStatus(.win)
            
            NSUserDefaults.standardUserDefaults().setObject(noughtWins, forKey: "savedNoughtWins")
            NSUserDefaults.standardUserDefaults().setObject(crossWins, forKey: "savedCrossWins")
            
            var winningButton:UIButton
            var tag:Int
            for i in winningVector {
                tag = i + 1
                winningButton = view.viewWithTag(tag) as! UIButton
                winningButton.backgroundColor = UIColor.yellowColor()
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
            
        }
    }
    
    func presentGameOverAlert(title: String) {
        let alert = UIAlertController(title: title, message: statusLabel.text, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: {
            (alert: UIAlertAction) in
            winLooseAVPlayer.stop()
        }))
        alert.addAction(UIAlertAction(title: "Play Again", style: .Default, handler: {
            (alert: UIAlertAction!) in
            winLooseAVPlayer.stop()
            self.resetGame()
        }))
        
        // HINT: Yes all this awful code just a moment to wait a bit before showing the alert
        let seconds = 1.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.presentViewController(alert, animated: true, completion: nil)
        })

    }
    
    func checkForDraw() {
        
        if playing {
            playing = checkForUntouchedCells(gameBoard)
            if !playing {
                // HINT: Game over!
                draws += 1
                updateTitle()
                updateStatus(.tie)
                NSUserDefaults.standardUserDefaults().setObject(draws, forKey: "savedDraws")
                presentGameOverAlert("Oops!")
            }
        }
    }
        
        
    func resetGame() {
        playing = true
        winner = Player.untouched
        activePlayer = .nought
        
        updateTitle()
        updateStatus(.starting)
        
        for i in 0..<gameBoard.count {
            gameBoard[i] = .untouched
        }

        var button:UIButton
        for tag in 1...9 {
            button = view.viewWithTag(tag) as! UIButton
            button.backgroundColor = getNormalButtonColor()
            button.setTitle("", forState: .Normal)
        }
        
        emojiGame = TicTacToeGame(gameBoard: gameBoard,
                                  noughtMark: noughtMark,
                                  crossMark: crossMark,
                                  gameOver: false)
    }
    
    func updateTitle() {
        titleLabel.text =  "\(noughtMark) vs \(crossMark)" + "  \(noughtWins):\(crossWins):\(draws)"
    }
    
    func updateStatus(mode:GameStatus) {
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
            if activePlayer == .nought {
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
        
        if let savedNoughtMark = NSUserDefaults.standardUserDefaults().objectForKey("savedNoughtMark") {
            noughtMark = savedNoughtMark as! String
        }
        
        if let savedCrossMark = NSUserDefaults.standardUserDefaults().objectForKey("savedCrossMark") {
            crossMark = savedCrossMark as! String
        }
        
        if let savedPlayer1Row = NSUserDefaults.standardUserDefaults().objectForKey("savedPlayer1Row") {
            player1Row = savedPlayer1Row as! Int
        }

        if let savedPlayer2Row = NSUserDefaults.standardUserDefaults().objectForKey("savedPlayer2Row") {
            player2Row = savedPlayer2Row as! Int
        }

        if let savedUseAI = NSUserDefaults.standardUserDefaults().objectForKey("savedUseAI") {
            useAI = savedUseAI as! Bool
        }
        
        if let savedUseSound = NSUserDefaults.standardUserDefaults().objectForKey("savedUseSound") {
            useSound = savedUseSound as! Bool
        }
        
        if let savedMysteryMode = NSUserDefaults.standardUserDefaults().objectForKey("savedMysteryMode") {
            mysteryMode = savedMysteryMode as! Bool
        }
        
        if let savedNoughtWins = NSUserDefaults.standardUserDefaults().objectForKey("savedNoughtWins") {
            noughtWins = savedNoughtWins as! Int
        }
        
        if let savedCrossWins = NSUserDefaults.standardUserDefaults().objectForKey("savedCrossWins") {
            crossWins = savedCrossWins as! Int
        }
        
        if let savedDraws = NSUserDefaults.standardUserDefaults().objectForKey("savedDraws") {
            draws = savedDraws as! Int
        }
        
        emojiGame.crossMark = crossMark
        emojiGame.noughtMark = noughtMark
    }
    
    /// Returns an empty AVAudioPlayer if one can't be created from a file
    func createPlayer(name name: String, extention: String) -> AVAudioPlayer {
        
        guard let path = NSBundle.mainBundle().pathForResource(name, ofType: extention) else {
            print("can't find sound files \(name).\(extention) in bundle")
            return AVAudioPlayer()
        }
        
        do {
            return try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path))
            
        }
        catch {
            print ("can't create player for \(path)")
            return AVAudioPlayer()
        }
    }
    
    
    func loadSoundsAndMusic() {
        
        winLooseAVPlayer = createPlayer(name: "Emoji Tac Toe Theme3", extention: ".mp3")
        
        noughtAVPlayer = createPlayer(name: "glossy_click_02", extention: ".wav")
        noughtAVPlayer.prepareToPlay()
        
        crossAVPlayer = createPlayer(name: "glossy_click_03", extention: ".wav")
        crossAVPlayer.prepareToPlay()
        
        battleAVPlayer = createPlayer(name: "bongweirdness", extention: ".wav")
        battleAVPlayer.prepareToPlay()

    }
    
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        
        // HINT: Pick a random pair of emojis
        let e1 = diceRoll(emojis.count/2)
        let e2 = diceRoll(emojis.count/2) + emojis.count/2
        noughtMark = emojis[e1]
        crossMark = emojis[e2]
        player1Row = e1
        player2Row = e2 - emojis.count/2
                
        NSUserDefaults.standardUserDefaults().setObject(player1Row, forKey: "savedPlayer1Row")
        NSUserDefaults.standardUserDefaults().setObject(noughtMark, forKey: "savedNoughtMark")
        NSUserDefaults.standardUserDefaults().setObject(player2Row, forKey: "savedPlayer2Row")
        NSUserDefaults.standardUserDefaults().setObject(crossMark, forKey: "savedCrossMark")

        resetGame()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        restoreUserPrefs()
        
        resetGame()
        
        if WCSession.isSupported() {
            watchSession = WCSession.defaultSession()
            watchSession.delegate = self
            watchSession.activateSession()
            watchSession.sendMessage(["noughtMark":noughtMark, "crossMark":crossMark], replyHandler: nil, errorHandler: nil)
        }
        
        loadSoundsAndMusic()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

