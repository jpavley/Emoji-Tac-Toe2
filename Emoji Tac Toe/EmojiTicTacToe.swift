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

let emojiSections = [0, 171, 389, 654, 844]

var emojis =
    // 0     1     2     3      4    5      6     7     8     9     10    11    12    13     14    15    16    17    18    19
    ["😀", "😁", "😂", "😃", "😄", "😅", "😆", "😉", "😊", "😋", "😎", "😍", "😘", "😗", "😙", "😚", "🙂", "🤗", "🤔", "😐",
     "😑", "😶", "🙄", "😏", "😣", "😥", "😮", "🤐", "😯", "😪", "😫", "😴", "😌", "🤓", "😛", "😜", "😝", "😒", "😓", "😔",
     "😕", "🙃", "🤑", "😲", "😖", "😞", "😟", "😤", "😢", "😭", "😦", "😧", "😨", "😩", "😬", "😰", "😱", "😳", "😵", "😡",
     "😠", "😇", "😷", "🤒", "🤕", "😈", "👿", "👹", "👺", "💀", "☠", "👻", "👽", "👾", "🤖", "💩", "😺", "😸", "😹", "😻",
     "😼", "😽", "🙀", "😿", "😾", "🙈", "🙉", "🙊", "👦", "👧", "👨", "👩", "👴", "👵", "👶", "👼", "👮", "🕵", "💂", "👷",
     "👳", "👱", "🎅", "👸", "👰", "👲", "🙍", "🙎", "🙅", "🙆", "💁", "🙋", "🙇", "💆", "💇", "🚶", "🏃", "💃", "👯", "🕴",
     "🗣", "👤", "👥", "🏇", "⛷", "🏂", "🏌", "🏄", "🚣", "🏊", "⛹", "🏋", "🚴", "🚵", "🏎", "🏍", "👫", "👬", "👭", "💏",
     "💑", "👪", "💪", "👈", "👉", "👆", "🖕", "👇", "🖖", "🤘", "🖐", "✋", "👌", "👍", "👎", "✊", "👊", "👋", "👏", "👐",
     "🙌", "🙏", "💅", "👂", "👃", "👣", "👀", "👁", "👅", "👄", "💋",
     // 0     1     2     3      4    5      6     7     8     9     10    11    12    13     14    15    16    17    18    19
     "💘", "💓", "💔", "💕", "💖", "💗", "💙", "💚", "💛", "💜", "💝", "💞", "💟", "💌", "💤", "💢", "💣", "💥", "💦", "💨",
     "💫", "💬", "🗨", "🗯", "💭", "🕳", "👓", "🕶", "👔", "👕", "👖", "👗", "👘", "👙", "👚", "👛", "👜", "👝", "🛍", "🎒",
     "👞", "👟", "👠", "👡", "👢", "👑", "👒", "🎩", "🎓", "⛑", "📿", "💄", "💍", "💎", "🐵", "🐒", "🐶", "🐕", "🐩", "🐺",
     "🐱", "🐈", "🦁", "🐯", "🐅", "🐆", "🐴", "🐎", "🦄", "🐮", "🐂", "🐃", "🐄", "🐷", "🐖", "🐗", "🐽", "🐏", "🐑", "🐐",
     "🐪", "🐫", "🐘", "🐭", "🐁", "🐀", "🐹", "🐰", "🐇", "🐿", "🐻", "🐨", "🐼", "🐾", "🦃", "🐔", "🐓", "🐣", "🐤", "🐥",
     "🐦", "🐧", "🕊", "🐸", "🐊", "🐢", "🐍", "🐲", "🐉", "🐳", "🐋", "🐬", "🐟", "🐠", "🐡", "🐙", "🐚", "🦀", "🐌", "🐛",
     "🐜", "🐝", "🐞", "🕷", "🕸", "🦂", "💐", "🌸", "💮", "🏵", "🌹", "🌺", "🌻", "🌼", "🌷", "🌱", "🌲", "🌳", "🌴", "🌵",
     "🌾", "🌿", "☘", "🍀", "🍁", "🍂", "🍃", "🍇", "🍈", "🍉", "🍊", "🍋", "🍌", "🍍", "🍎", "🍏", "🍐", "🍑", "🍒", "🍓",
     "🍅", "🍆", "🌽", "🌶", "🍄", "🌰", "🍞", "🧀", "🍖", "🍗", "🍔", "🍟", "🍕", "🌭", "🌮", "🌯", "🍳", "🍲", "🍿", "🍱",
     "🍘", "🍙", "🍚", "🍛", "🍜", "🍝", "🍠", "🍢", "🍣", "🍤", "🍥", "🍡", "🍦", "🍧", "🍨", "🍩", "🍪", "🎂", "🍰", "🍫",
     "🍬", "🍭", "🍮", "🍯", "🍼", "☕", "🍵", "🍶", "🍾", "🍷", "🍸", "🍹", "🍺", "🍻", "🍽", "🍴", "🔪", "🏺",
     // 0     1     2     3      4    5      6     7     8     9     10    11    12    13     14    15    16    17    18    19
     "🌍", "🌎", "🌏", "🌐", "🗺", "🗾", "🏔", "⛰", "🌋", "🗻", "🏕", "🏖", "🏜", "🏝", "🏞", "🏟", "🏛", "🏗", "🏘", "🏙",
     "🏚", "🏠", "🏡", "🏢", "🏣", "🏤", "🏥", "🏦", "🏨", "🏩", "🏪", "🏫", "🏬", "🏭", "🏯", "🏰", "💒", "🗼", "🗽", "⛪",
     "🕌", "🕍", "⛩", "🕋", "⛲", "⛺", "🌁", "🌃", "🌄", "🌅", "🌆", "🌇", "🌉", "🌌", "🎠", "🎡", "🎢", "💈", "🎪", "🎭",
     "🖼", "🎨", "🎰", "🚂", "🚃", "🚄", "🚅", "🚆", "🚇", "🚈", "🚉", "🚊", "🚝", "🚞", "🚋", "🚌", "🚍", "🚎", "🚐", "🚑",
     "🚒", "🚓", "🚔", "🚕", "🚖", "🚗", "🚘", "🚙", "🚚", "🚛", "🚜", "🚲", "🚏", "🛣", "🛤", "⛽", "🚨", "🚥", "🚦", "🚧",
     "⚓", "⛵", "🚤", "🛳", "⛴", "🛥", "🚢", "🛩", "🛫", "🛬", "💺", "🚁", "🚟", "🚠", "🚡", "🚀", "🛰", "🛎", "🚪", "🛌",
     "🛏", "🛋", "🚽", "🚿", "🛀", "🛁", "⌛", "⏳", "⌚", "⏰", "⏱", "⏲", "🕰", "🕛", "🕧", "🕐", "🕜", "🕑", "🕝", "🕒",
     "🕞", "🕓", "🕟", "🕔", "🕠", "🕕", "🕡", "🕖", "🕢", "🕗", "🕣", "🕘", "🕤", "🕙", "🕥", "🕚", "🕦", "🌑", "🌒", "🌓",
     "🌔", "🌕", "🌖", "🌗", "🌘", "🌙", "🌚", "🌛", "🌜", "🌡", "🌝", "🌞", "⭐", "🌟", "🌠", "⛅", "⛈", "🌤", "🌥", "🌦",
     "🌧", "🌨", "🌩", "🌪", "🌫", "🌬", "🌀", "🌈", "🌂", "☔", "⛱", "⚡", "⛄", "☄", "🔥", "💧", "🌊", "🎃", "🎄", "🎆",
     "🎇", "✨", "🎈", "🎉", "🎊", "🎋", "🎍", "🎎", "🎏", "🎐", "🎑", "🎀", "🎁", "🎗", "🎟", "🎫", "🎖", "🏆", "🏅", "⚽",
     "🏀", "🏐", "🏈", "🏉", "🎾", "🎱", "🎳", "🏏", "🏑", "🏒", "🏓", "🏸", "🎯", "⛳", "⛸", "🎣", "🎽", "🎿", "🎮", "🕹",
     "🎲", "🃏", "🀄", "🎴", "🔈", "🔉", "🔊", "📢", "📣", "📯", "🔔", "🔕", "🎼", "🎵", "🎙", "🎚", "🎛", "🎤", "🎧", "📻",
     "🎷", "🎸", "🎹", "🎺", "🎻",
     // 0     1     2     3      4    5      6     7     8     9     10    11    12    13     14    15    16    17    18    19
     "📱", "📞", "📟", "📠", "🔋", "🔌", "💻", "🖥", "🖨", "⌨", "🖱", "🖲", "💽", "💾", "💿", "📀", "🎥", "🎞", "📽", "🎬",
     "📺", "📷", "📸", "📹", "📼", "🔍", "🔎", "🔬", "🔭", "📡", "🕯", "💡", "🔦", "🏮", "📔", "📕", "📖", "📗", "📘", "📙",
     "📚", "📓", "📒", "📃", "📜", "📄", "📰", "📑", "🔖", "🏷", "💰", "💴", "💵", "💶", "💷", "💸", "💳", "💹", "💱", "📧",
     "📤", "📥", "📦", "📫", "🖋", "🖊", "🖌", "🖍", "📝", "💼", "📁", "📂", "🗂", "📅", "📆", "🗒", "🗓", "📇", "📈", "📉",
     "📊", "📋", "📌", "📍", "📎", "🖇", "📏", "📐", "🗃", "🗄", "🗑", "🔒", "🔓", "🔑", "🗝", "🔨", "⛏", "⚒", "🛠", "🗡",
     "⚔", "🔫", "🏹", "🛡", "🔧", "🔩", "⚙", "🗜", "⚗", "⚖", "🔗", "⛓", "💉", "💊", "🚬", "⚰", "⚱", "🗿", "🛢", "🔮",
     "🏧", "🚮", "🚰", "♿", "🚹", "🚺", "🚻", "🚼", "🚾", "🛂", "🛃", "🛄", "🛅", "🚸", "⛔", "🚫", "☢", "☣", "🔄", "🛐",
     "⚛", "🕉", "☸", "☦", "☪", "☮", "🕎", "🔯", "♈", "♉", "♊", "♋", "♌", "♍", "♎", "♏", "♐", "♑", "♒", "♓",
     "⛎", "⚜", "🔰", "🔱", "⭕", "✅", "❌", "❎", "❓", "❗", "#️⃣", "*️⃣", "0️⃣", "1️⃣", "2️⃣", "3️⃣", "4️⃣", "5️⃣", "6️⃣", "7️⃣",
     "8️⃣", "9️⃣", "🔟", "💯", "🆘", "💠", "⚪", "⚫", "🔴", "🔵",
     // 0     1     2     3      4    5      6     7     8     9     10    11    12    13     14    15    16    17    18    19
     "🏁", "🚩", "🎌", "🏴", "🏳", "🇦🇨", "🇦🇩", "🇦🇪", "🇦🇫", "🇦🇬", "🇦🇮", "🇦🇱", "🇦🇲", "🇦🇴", "🇦🇶", "🇦🇷", "🇦🇸", "🇦🇹", "🇦🇺", "🇦🇼",
     "🇦🇽", "🇦🇿", "🇧🇦", "🇧🇧", "🇧🇩", "🇧🇪", "🇧🇫", "🇧🇬", "🇧🇭", "🇧🇮", "🇧🇯", "🇧🇱", "🇧🇲", "🇧🇳", "🇧🇴", "🇧🇶", "🇧🇷", "🇧🇸", "🇧🇹", "🇧🇻",
     "🇧🇼", "🇧🇾", "🇧🇿", "🇨🇦", "🇨🇨", "🇨🇩", "🇨🇫", "🇨🇬", "🇨🇭", "🇨🇮", "🇨🇰", "🇨🇱", "🇨🇲", "🇨🇳", "🇨🇴", "🇨🇵", "🇨🇷", "🇨🇺", "🇨🇻", "🇨🇼",
     "🇨🇽", "🇨🇾", "🇨🇿", "🇩🇪", "🇩🇬", "🇩🇯", "🇩🇰", "🇩🇲", "🇩🇴", "🇩🇿", "🇪🇦", "🇪🇨", "🇪🇪", "🇪🇬", "🇪🇭", "🇪🇷", "🇪🇸", "🇪🇹", "🇪🇺", "🇫🇮",
     "🇫🇯", "🇫🇰", "🇫🇲", "🇫🇴", "🇫🇷", "🇬🇦", "🇬🇧", "🇬🇩", "🇬🇪", "🇬🇫", "🇬🇬", "🇬🇭", "🇬🇮", "🇬🇱", "🇬🇲", "🇬🇳", "🇬🇵", "🇬🇶", "🇬🇷", "🇬🇸",
     "🇬🇹", "🇬🇺", "🇬🇼", "🇬🇾", "🇭🇰", "🇭🇲", "🇭🇳", "🇭🇷", "🇭🇹", "🇭🇺", "🇮🇨", "🇮🇩", "🇮🇪", "🇮🇱", "🇮🇲", "🇮🇳", "🇮🇴", "🇮🇶", "🇮🇷", "🇮🇸",
     "🇮🇹", "🇯🇪", "🇯🇲", "🇯🇴", "🇯🇵", "🇰🇪", "🇰🇬", "🇰🇭", "🇰🇮", "🇰🇲", "🇰🇳", "🇰🇵", "🇰🇷", "🇰🇼", "🇰🇾", "🇰🇿", "🇱🇦", "🇱🇧", "🇱🇨", "🇱🇮",
     "🇱🇰", "🇱🇷", "🇱🇸", "🇱🇹", "🇱🇺", "🇱🇻", "🇱🇾", "🇲🇦", "🇲🇨", "🇲🇩", "🇲🇪", "🇲🇫", "🇲🇬", "🇲🇭", "🇲🇰", "🇲🇱", "🇲🇲", "🇲🇳", "🇲🇴", "🇲🇵",
     "🇲🇶", "🇲🇷", "🇲🇸", "🇲🇹", "🇲🇺", "🇲🇻", "🇲🇼", "🇲🇽", "🇲🇾", "🇲🇿", "🇳🇦", "🇳🇨", "🇳🇪", "🇳🇫", "🇳🇬", "🇳🇮", "🇳🇱", "🇳🇴", "🇳🇵", "🇳🇷",
     "🇳🇺", "🇳🇿", "🇴🇲", "🇵🇦", "🇵🇪", "🇵🇫", "🇵🇬", "🇵🇭", "🇵🇰", "🇵🇱", "🇵🇲", "🇵🇳", "🇵🇷", "🇵🇸", "🇵🇹", "🇵🇼", "🇵🇾", "🇶🇦", "🇷🇪", "🇷🇴",
     "🇷🇸", "🇷🇺", "🇷🇼", "🇸🇦", "🇸🇧", "🇸🇨", "🇸🇩", "🇸🇪", "🇸🇬", "🇸🇭", "🇸🇮", "🇸🇯", "🇸🇰", "🇸🇱", "🇸🇲", "🇸🇳", "🇸🇴", "🇸🇷", "🇸🇸", "🇸🇹",
     "🇸🇻", "🇸🇽", "🇸🇾", "🇸🇿", "🇹🇦", "🇹🇨", "🇹🇩", "🇹🇫", "🇹🇬", "🇹🇭", "🇹🇯", "🇹🇰", "🇹🇱", "🇹🇲", "🇹🇳", "🇹🇴", "🇹🇷", "🇹🇹", "🇹🇻", "🇹🇼",
     "🇹🇿", "🇺🇦", "🇺🇬", "🇺🇲", "🇺🇸", "🇺🇾", "🇺🇿", "🇻🇦", "🇻🇨", "🇻🇪", "🇻🇬", "🇻🇮", "🇻🇳", "🇻🇺", "🇼🇫", "🇼🇸", "🇽🇰", "🇾🇪", "🇾🇹", "🇿🇦",
     "🇿🇲", "🇿🇼"]

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

/// Returns a string with line breaks and emoji that represents the game
func transformGameIntoText(gameboard: [Player], noughtMark: String, crossMark: String, untouchedMark: String) -> String {
    var result = ""
    
    for (index, cell) in gameboard.enumerated() {
        
        switch cell {
        case .untouched:
            result += untouchedMark + " "
        case .nought:
            result += noughtMark + " "
        case .cross:
            result += crossMark + " "
        }
        
        if index == 2 || index == 5 || index == 8 {
            result += "\n"
        }
    }
        
    return result
}

/// Returns the first winning vector found or nil is there is no win
func searchForWin(_ gameBoard:[Player]) -> [Int]? {
    
    for vector in winningVectors {
        if gameBoard[vector[0]] != .untouched && gameBoard[vector[0]] == gameBoard[vector[1]] && gameBoard[vector[0]] == gameBoard[vector[2]] {
            return vector
        }
    }
    return nil
}


/// Returns true if the player has a winning vector on the gameboard
func seachForWinForPlayer(_ board:[Player], player:Player) -> Bool {
    
    for vector in winningVectors {
        if board[vector[0]] == player {
            if board[vector[1]] == player {
                if board[vector[2]] == player {
                    return true
                }
            }
        }
    }
    return false
}

/// Returns a vector [Int] of untouched cells or an empty vector [Int]
func calcOpenCells(gameBoard:[Player]) -> [Int] {
    var openCells = [Int]()
    for (index, cell) in gameBoard.enumerated() {
        if cell == .untouched {
            openCells.append(index)
        }
    }
    return openCells
}

/// Returns true if there is more than 1 open cell or if there is only 1 open
/// cell that nought can win if it takes that cell
func checkForWayToWin(_ gameBoard:[Player]) -> Bool {
    // TODO: This is pretty werid function. It is not a generalized check
    //       that there exists a way to win on the board.
    
    let openCells = calcOpenCells(gameBoard: gameBoard)
    // if there is one open cell
    if openCells.count == 1 {
        // make a modifiable copy of the gameBoard
        var testGameboard = gameBoard
        // adjust the gameBoard so that the last remaining open cell is a nought
        testGameboard[openCells[0]] = .nought
        // return the result of searching for a winning vector with the test gameBoard
        return seachForWinForPlayer(testGameboard, player: .nought)
    }
    return true
}

/// Returns true if there are open (untouched) cell on the board
func checkForUntouchedCells(_ gameBoard:[Player]) -> Bool {
    
    for cell in gameBoard {
        if cell == .untouched {
            return true
        }
    }
    return false

}

/// Returns array of cells with marks or emply array if there no open cells
/// NOTE: Used for both owned and taken cells
func calcOccupiedCells(_ gameBoard:[Player], for player: Player) -> [Int] {
    var occupiedCells = [Int]()
    for (index, cell) in gameBoard.enumerated() {
        if cell == player {
            occupiedCells.append(index)
        }
    }
    return occupiedCells
}

/// Returns an open cell id or nil with a probability of randomness
/// threshold = 0 means 0% chance of returning a random cell id (always nil)
/// threshold = 100 means  100% chance of returning a random cell id (never nil)
/// The game is usually played with a threshold of 30%
/// (Thus the ai has the potential to make a mistake 30% of time)
/// NOTE: the less open cells the more likely a random move will be a good move
func randomCell(_ gameBoard:[Player], threshold: Int) -> Int? {
    var result:Int?
    let openCells = calcOpenCells(gameBoard: gameBoard)
    
    // early return
    if openCells.count == 0 {
        return nil
    }
    
    let chanceToBeRandom = diceRoll(100)
    // print("chanceToBeRandom \(chanceToBeRandom)")
    if chanceToBeRandom <= threshold {
        result = openCells.count > 0 ? openCells[diceRoll(openCells.count)] : nil
        // print("result \(result!)")
    }
    return result
}

/// Returns a block moving for specificed player, one that would pervent opponent
/// from win or nil is there is no blocking move
func searchForBlockingMove(gameBoard: [Player], for player: Player) -> Int? {
    var result:Int?
    let openCells = calcOpenCells(gameBoard: gameBoard)
    
    // reverse player as we find a winning move for the opponent and 
    // return it as a blocking move for the player
    let opponent:Player = (player == .nought) ? .cross : .nought
    
    for cell in openCells {
        var testGameboard = gameBoard
        testGameboard[cell] = opponent
        
        if seachForWinForPlayer(testGameboard, player: opponent) {
            result = cell
        }
    }
    return result
}

/// Returns a cell index that the AI wants to mark
/// NOTE: AI is always cross and player is always nought (regardless of mark)
func aiChoose(_ gameBoard:[Player], unpredicible: Bool) -> Int? {
    
    var result:Int?
    
    var openCells = calcOpenCells(gameBoard: gameBoard)
    let occupiedCells = calcOccupiedCells(gameBoard, for: .nought)
    let ownedCells = calcOccupiedCells(gameBoard, for: .cross)

    // 1. Zero open cells
    if openCells.count > 0 {
        
        // 2. Unpredicible (need to turn this off to do a true test!)
        // x% of the time be unpredictible
        if result == nil && unpredicible {
            result = randomCell(gameBoard, threshold: 30)
        }
        
        // 3. Blocking move
        // Search for blocking move
        if result == nil {
                result = searchForBlockingMove(gameBoard: gameBoard, for: .cross)
        }
        
        // 4. Take another corner
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
        
        // 5. Grab a middle
        // AI has a corner grab a middle
        if result == nil {
            let results1 = [0,2,6,8].filter {ownedCells.contains($0)}
            if results1.count > 0 {
                let results2 = [1,3,5,7].filter {openCells.contains($0)}
                result = results2.count > 0 ? results2[diceRoll(results2.count)] : nil
            }
        }
        
        // 6. Grab a corner
        // Player has a middle grab a corner
        if result == nil {
            let results1 = [1,3,5,7].filter {occupiedCells.contains($0)}
            if results1.count > 0 {
                let results2 = [0,2,6,8].filter {openCells.contains($0)}
                result = results2.count > 0 ? results2[diceRoll(results2.count)] : nil
            }
        }
        
        // 7. Grab the center
        // Grab the center if it's open
        if result == nil {
            if openCells.contains(4) {
                result = 4
            }
        }
        
        // 8. Grab a middle position
        // if AI has the center grab middle position
        if result == nil {
            if ownedCells.contains(4) {
                let results = [1,3,5,7].filter {openCells.contains($0)}
                result = results[diceRoll(results.count)]
            }
        }
        
        // 9. Grab corner opposite opponent
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
        
        // 10. Winning Move
        // Search for winning move
        for cell in openCells {
            var testGameboard = gameBoard
            testGameboard[cell] = .cross
            if seachForWinForPlayer(testGameboard, player: .cross) {
                result = cell
            }
        }
        
        // 11. Any corner
        // Search for a corner
        if result == nil {
            let results = [0,2,6,8].filter {openCells.contains($0)}
            result = results.count > 0 ? results[diceRoll(results.count)] : nil
        }
        
        // 12. Random move
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

func loadEmojisIntoArray(from fileName: String, fileType: String) -> [String]? {
    
    let path:String = Bundle.main.path(forResource: fileName, ofType: fileType)!
    if let text = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) {
        var result = [String]()
        let lines = text.components(separatedBy: "\n")
        for line in lines {
            if line != "" {
                let characterLocationIndex = line.index(line.startIndex, offsetBy: 0)
                let myCharacter = line[characterLocationIndex]
                result.append(String(myCharacter))
            }
        }
        return result
        
    } else {
        print("unable to load \(fileName),\(fileType)")
    }
    
    return nil
}


let freshGameBoard:[Player] = [.untouched, .untouched, .untouched,
                               .untouched, .untouched, .untouched,
                               .untouched, .untouched, .untouched]

var emojiGame = TicTacToeGame(gameBoard:freshGameBoard,
                              noughtMark: "⭕️",
                              crossMark: "❌",
                              gameOver: false)



