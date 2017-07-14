//
//  EmojiTicTacToe.swift
//  Emo Tac Toe
//
//  Created by John Pavley on 7/26/16.
//  Copyright © 2016 Epic Loot. All rights reserved.
//

// NOTE: Almost all functions names should start with the following prefixs:
//       - check: a query that returns true or false
//       - search: a query that returns results
//       - calc: a query that reutrns a value
//       - transform: mutate the input data type into the output data type

import Foundation

enum Player:String {
    case untouched, nought, cross
}

enum Cell: Int {
    case topLeft = 0
    case topMiddle = 1
    case topRight = 2
    case midLeft = 3
    case center = 4
    case midRight = 5
    case botLeft = 6
    case botMiddle = 7
    case botRight = 8
}

typealias GameBoard = [Player]

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
    var gameBoard:GameBoard
    var noughtMark:String
    var crossMark:String
    var gameOver:Bool
}

/// Returns a string with line breaks and emoji that represents the game
func transformGameIntoText(gameboard: GameBoard, noughtMark: String, crossMark: String, untouchedMark: String) -> String {
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

// TODO: Project the search functions: are all getting called? Are they in the
//       optimal order?

/// Returns the first winning vector found or nil is there is no win
func searchForWin(_ gameBoard:GameBoard) -> [Int]? {
    
    for vector in winningVectors {
        if gameBoard[vector[0]] != .untouched && gameBoard[vector[0]] == gameBoard[vector[1]] && gameBoard[vector[0]] == gameBoard[vector[2]] {
            return vector
        }
    }
    return nil
}


/// Returns true if the player has a winning vector on the gameboard
func seachForWinForPlayer(_ board:GameBoard, player:Player) -> Bool {
    
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

/// Returns true if there are open (untouched) cell on the board
/// ⬜️⬜️❌
/// ⬜️⬜️⬜️
/// ⬜️⬜️⭕️
func checkForUntouchedCells(_ gameBoard:GameBoard) -> Bool {
    // TODO: Generalize this for all player types (.cross, .nought, .untouched
    
    for cell in gameBoard {
        if cell == .untouched {
            return true
        }
    }
    return false

}

/// Returns a vector [Int] of untouched cells or an empty vector [Int]
/// ❌⬜️❌
/// ⬜️⬜️⬜️
/// ⭕️⬜️⭕️
func calcOpenCells(gameBoard:GameBoard) -> [Int] {
    // TODO: Generalize this for all player types (.cross, .nought, .untouched
    // TODO: Merge with calcOccupiedCells into a general calcCellInventory()

    var openCells = [Int]()
    for (index, cell) in gameBoard.enumerated() {
        if cell == .untouched {
            openCells.append(index)
        }
    }
    return openCells
}

/// Returns array of cells with marks or emply array if there no open cells
/// NOTE: Used for both owned and taken cells
/// ❓❓❌
/// ❓❓❓
/// ❓❓⭕️
func calcOccupiedCells(_ gameBoard:GameBoard, for player: Player) -> [Int] {
    // TODO: Merge with calcOccupiedCells into a general calcCellInventory()

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
/// ❓❓❌
/// ❓❓❓
/// ❓❓⭕️
func randomCell(_ gameBoard:GameBoard, threshold: Int) -> Int? {
    // TODO: change function name to calcRandomCell()
    
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

/// Returns true if there is more than 1 open cell or if there is only 1 open
/// cell that nought can win if it takes that cell
/// NOTE: This is pretty werid function. It is not a generalized check
///       that there exists a way to win on the board.
/// ⭕️❌❌
/// ⭕️❌❌
/// ❓⭕️⭕️
func checkForWayToWin(_ gameBoard:GameBoard) -> Bool {
    // TODO: Generalize this for all player types (.cross, .nought, .untouched
    // TODO: Generalize this into a true search for a way to win even if there
    //       is more than one cell open. (Don't just return true if openCells == 1)
    // TODO: Merge with searchForWayToWin()
    
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

/// Returns a block moving for specificed player, one that would pervent opponent
/// from win or nil is there is no blocking move
/// ⬜️❓❌
/// ⬜️⭕️⬜️
/// ⬜️⭕️⬜️
func searchForBlockingMove(gameBoard: GameBoard, for player: Player) -> Int? {
    // TODO: Merge with checkForWayToWin() as blocking move is a way to win 🤔
    
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

/// Returns a corner move for specific player if opponet has middle and a corner
/// and player has a corner or nil if no other corner move can be found
/// ❓⬜️❌
/// ⬜️⭕️⬜️
/// ❓⬜️⭕️
func searchForAnotherCornerIfOpponentHasMiddleAndCorner(gameBoard: GameBoard, for player: Player) -> Int? {
    // TODO: Is this ever called? searchForBlockingMove() should catch this use case!
    // TODO: Use specific var names (results1 and results2 too general)
    
    var result:Int?
    let openCells = calcOpenCells(gameBoard: gameBoard)
    let opponent:Player = (player == .nought) ? .cross : .nought
    let occupiedCells = calcOccupiedCells(gameBoard, for: opponent)
    let ownedCells = calcOccupiedCells(gameBoard, for: player)


    let results1 = [0,2,6,8].filter {occupiedCells.contains($0)}
    let flag1 = occupiedCells.contains(4)
    let results2 = [0,2,6,8].filter {ownedCells.contains($0)}
    
    if results1.count > 0 && flag1 && results2.count > 0 {
        let results3 = [0,2,6,8].filter {openCells.contains($0)}
        result = results3.count > 0 ? results3[diceRoll(results3.count)] : nil
    }
    return result
}

/// Returns a middle move if the player already has an corner or nil
/// NOTE: Middle is not center. Center is cell 4 while cells 1, 3, 5, 7 are middles
/// ⬜️❓❌
/// ❓⬜️❓
/// ⬜️❓⭕️
func searchForMiddleIfCorner(gameBoard: GameBoard, for player: Player) -> Int? {
    // TODO: Use specific var names (results1 and results2 too general)
    
    var result:Int?
    let openCells = calcOpenCells(gameBoard: gameBoard)
    let ownedCells = calcOccupiedCells(gameBoard, for: player)

    let results1 = [0,2,6,8].filter {ownedCells.contains($0)}
    if results1.count > 0 {
        let results2 = [1,3,5,7].filter {openCells.contains($0)}
        result = results2.count > 0 ? results2[diceRoll(results2.count)] : nil
    }
    return result
}

/// Returns a corner move if the opponent already has a middle or nil
/// NOTE: Middle is not center. Center is cell 4 while cells 1, 3, 5, 7 are middles
/// ❓⬜️❓
/// ⬜️❌⭕️
/// ❓⬜️❓
func searchForCornerIfOpponentHasMiddle(gameBoard: GameBoard, for player: Player) -> Int? {
    // TODO: Use specific var names (results1 and results2 too general)

    var result:Int?
    let openCells = calcOpenCells(gameBoard: gameBoard)
    let opponent:Player = (player == .nought) ? .cross : .nought
    let occupiedCells = calcOccupiedCells(gameBoard, for: opponent)

    let results1 = [1,3,5,7].filter {occupiedCells.contains($0)}
    if results1.count > 0 {
        let results2 = [0,2,6,8].filter {openCells.contains($0)}
        result = results2.count > 0 ? results2[diceRoll(results2.count)] : nil
    }
    return result
}

/// Returns a center move if open or nil if not.
/// ⬜️⬜️⬜️
/// ⬜️❓⬜️
/// ⬜️⬜️⬜️
func searchForCenterIfOpen(gameBoard: GameBoard) -> Int? {
    var result:Int?
    let openCells = calcOpenCells(gameBoard: gameBoard)

    if openCells.contains(4) {
        result = 4
    }
    
    return result
}

/// Returns a middle move if the player already has the center or nil
/// NOTE: Middle is not center. Center is cell 4 while cells 1, 3, 5, 7 are middles
/// ⬜️❓⬜️
/// ❓❌❓
/// ⬜️❓⭕️
func searchForMiddleIfCenter(gameBoard: GameBoard, for player: Player) -> Int? {
    // TODO: Use specific var names (results1 and results2 too general)

    var result:Int?
    let openCells = calcOpenCells(gameBoard: gameBoard)
    let ownedCells = calcOccupiedCells(gameBoard, for: player)

    if ownedCells.contains(4) {
        let results = [1,3,5,7].filter {openCells.contains($0)}
        result = results[diceRoll(results.count)]
    }
    return result
}

/// Returns a corner move opposite the opponents corner or nil
/// ❓⬜️⬜️
/// ⬜️⬜️⬜️
/// ⬜️⬜️⭕️
func searchForCornerOppositeOpponent(gameBoard: GameBoard, for player: Player) -> Int? {
    var result:Int?
    let openCells = calcOpenCells(gameBoard: gameBoard)
    let opponent:Player = (player == .nought) ? .cross : .nought
    let occupiedCells = calcOccupiedCells(gameBoard, for: opponent)

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
    return result
}

/// Returns a cell index that the AI wants to mark
/// NOTE: AI is always cross and player is always nought (regardless of mark)
func aiChoose(_ gameBoard:GameBoard, unpredicible: Bool) -> Int? {
    
    var result:Int?
    var openCells = calcOpenCells(gameBoard: gameBoard)

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
            result = searchForAnotherCornerIfOpponentHasMiddleAndCorner(gameBoard: gameBoard, for: .cross)
        }
        
        // 5. Grab a middle
        // AI has a corner grab a middle
        if result == nil {
            result = searchForMiddleIfCorner(gameBoard: gameBoard, for: .cross)
        }
        
        // 6. Grab a corner
        // Player has a middle grab a corner
        if result == nil {
            result = searchForCornerIfOpponentHasMiddle(gameBoard: gameBoard, for: .cross)
        }
        
        // 7. Grab the center
        // Grab the center if it's open
        if result == nil {
            result = searchForCenterIfOpen(gameBoard: gameBoard)
        }
        
        // 8. Grab a middle position
        // if AI has the center grab middle position
        if result == nil {
            result = searchForMiddleIfCenter(gameBoard: gameBoard, for: .cross)
        }
        
        // 9. Grab corner opposite opponent
        // Search for a corner opposite the opponent
        if result == nil {
            result = searchForCornerOppositeOpponent(gameBoard: gameBoard, for: .cross)
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


let freshGameBoard:GameBoard = [.untouched, .untouched, .untouched,
                               .untouched, .untouched, .untouched,
                               .untouched, .untouched, .untouched]

var emojiGame = TicTacToeGame(gameBoard:freshGameBoard,
                              noughtMark: "⭕️",
                              crossMark: "❌",
                              gameOver: false)



