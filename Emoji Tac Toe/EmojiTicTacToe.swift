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

typealias Gameboard = [Player]

let emojiSections = [0, 171, 389, 654, 843]

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
     "🔫", "🏹", "🛡", "🔧", "🔩", "⚙", "🗜", "⚗", "⚖", "🔗", "⛓", "💉", "💊", "🚬", "⚰", "⚱", "🗿", "🛢", "🔮", "🏧",
     "🚮", "🚰", "♿", "🚹", "🚺", "🚻", "🚼", "🚾", "🛂", "🛃", "🛄", "🛅", "🚸", "⛔", "🚫", "☢", "☣", "🔄", "🛐", "⚛",
     "🕉", "☸", "☦", "☪", "☮", "🕎", "🔯", "♈", "♉", "♊", "♋", "♌", "♍", "♎", "♏", "♐", "♑", "♒", "♓", "⛎",
     "⚜", "🔰", "🔱", "⭕", "✅", "❌", "❎", "❓", "❗", "#️⃣", "*️⃣", "0️⃣", "1️⃣", "2️⃣", "3️⃣", "4️⃣", "5️⃣", "6️⃣", "7️⃣",
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
    var gameboard:Gameboard
    var noughtMark:String
    var crossMark:String
    var untouchedMark:String
    var gameOver:Bool
}

/// Returns a string with line breaks and emoji that represents the game
/// .nought    .untouched .nought
/// .untouched .cross      .untouched
/// .untouched .cross      .untouched
func transformGameIntoText(game g: TicTacToeGame) -> String {

    var result = ""
    
    for (index, cell) in g.gameboard.enumerated() {
        
        switch cell {
        case .untouched:
            result += "\(g.untouchedMark) "
        case .nought:
            result += "\(g.noughtMark) "
        case .cross:
            result += "\(g.crossMark) "
        }
        
        if index == 2 || index == 5 || index == 8 {
            result += "\n"
        }
    }
        
    return result
}

/// Returns a Gameboard based on a text representation of a game. The text must reprent a 
/// complete game with 9 cells. By default the marks o, x, and _ are used.
/// o_o
/// _x_
/// _x_
func transformTextIntoGameboard(textRepresentation: String,
                                noughtMark: String = "o",
                                crossMark: String = "x",
                                untouchedMark: String = "_") -> Gameboard? {
    var result:Gameboard?
    
    if textRepresentation.count < 9 {
        // incomplete gameboard
        return result
    }
    
    result = Gameboard()
    
    for mark in textRepresentation {
        switch mark {
        case Character(noughtMark):
            result?.append(.nought)
        case Character(crossMark):
            result?.append(.cross)
        case Character(untouchedMark):
            result?.append(.untouched)
        default:
            // textRepresentation contains unexpected data--Abort!
            result = nil
            break
        }
    }
    
    return result
}

// TODO: Profile the search functions: are all getting called? Are they in the
//       optimal order?

/// Returns the first winning vector found or nil if no winning vector is found.
/// (Regardless of player.)
func searchForWin(_ gameboard:Gameboard) -> [Int]? {
    
    for vector in winningVectors {
        if gameboard[vector[0]] != .untouched && gameboard[vector[0]] == gameboard[vector[1]] && gameboard[vector[0]] == gameboard[vector[2]] {
            return vector
        }
    }
    return nil
}


/// Returns true if the player has a winning vector on the gameboard
/// (Regardless of which vector.)
func seachForWinForPlayer(_ board:Gameboard, player:Player) -> Bool {
    
    for vector in winningVectors {
        if board[vector[0]] == player && board[vector[1]] == player && board[vector[2]] == player {
            return true
        }
    }

    return false
}

/// Returns true if there are open (untouched) cell on the board
/// ⬜️⬜️❌
/// ⬜️⬜️⬜️
/// ⬜️⬜️⭕️
func checkForUntouchedCells(_ gameboard: Gameboard) -> Bool {
    return getUsedCells(gameboard, for: .untouched).count != 0
}

/// Returns a vector [Int] of untouched cells or an empty vector [Int]
/// ❌⬜️❌
/// ⬜️⬜️⬜️
/// ⭕️⬜️⭕️
func calcOpenCells(_ gameboard: Gameboard) -> [Int] {
    return getUsedCells(gameboard, for: .untouched)
}

/// Returns array of cells with marks or emply array if there no open cells
/// NOTE: Used for both owned and taken cells
/// ❓❓❌
/// ❓❓❓
/// ❓❓⭕️
func calcOccupiedCells(_ gameboard: Gameboard, for player: Player) -> [Int] {
    return getUsedCells(gameboard, for: player)
}

/// Returns array of cells used by a mark or an empty array if none are found.
/// Player.untouched are open cells. Player.cross and Player.nought are
/// occupided cells.
func getUsedCells(_ gameboard: Gameboard, for mark: Player) -> [Int] {
    var cells = [Int]()
    for (index, cell) in gameboard.enumerated() {
        if cell == mark {
            cells.append(index)
        }
    }
    return cells
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
func calcRandomCell(_ gameboard: Gameboard, threshold: Int) -> Int? {
    
    var result:Int?
    let openCells = calcOpenCells(gameboard)
    
    if openCells.count == 0 {
        return nil
    }
    
    let chanceToBeRandom = diceRoll(100)
    if chanceToBeRandom <= threshold {
        result = openCells.count > 0 ? openCells[diceRoll(openCells.count)] : nil
    }
    return result
}

/// Returns true if there is 1 open cell and the player
/// can win if it takes that cell.
/// NOTE: This is pretty werid function. It is not a generalized check
///       that there exists a way to win on the board.
/// ⭕️❌❌
/// ⭕️❌❌
/// ❓⭕️⭕️
func isThereAFinalWinningMove(_ gameboard: Gameboard, for mark: Player) -> Bool {
    let openCells = calcOpenCells(gameboard)
    let winningMove = searchForWinningMove(gameboard, for: mark)
    return openCells.count == 1 && winningMove != nil
}

/// Returns a winning move for the player or nil
/// ⬜️❓⭕️
/// ⬜️❌⬜️
/// ⬜️❌⬜️
func searchForWinningMove(_ gameboard: Gameboard, for player: Player) -> Int? {
    var result:Int?
    let openCells = calcOpenCells(gameboard)
    
    for cell in openCells {
        var testGameboard = gameboard
        testGameboard[cell] = player
        
        if seachForWinForPlayer(testGameboard, player: player) {
            result = cell
        }
    }
    return result
}

/// Returns a block moving for specificed player, one that would pervent opponent
/// from win or nil is there is no blocking move
/// ⬜️❓❌
/// ⬜️⭕️⬜️
/// ⬜️⭕️⬜️
func searchForBlockingMove(gameboard: Gameboard, for player: Player) -> Int? {
    // TODO: Merge with checkForWayToWin() as blocking move is a way to win 🤔
    
    // reverse player as we find a winning move for the opponent and 
    // return it as a blocking move for the player
    let opponent: Player = (player == .nought) ? .cross : .nought
    
    return searchForWinningMove(gameboard, for: opponent)
}

/// Returns a corner move for specific player if opponet has middle and a corner
/// and player has a corner or nil if no other corner move can be found
/// ❓⬜️❌
/// ⬜️⭕️⬜️
/// ❓⬜️⭕️
func searchForAnotherCornerIfOpponentHasMiddleAndCorner(gameboard: Gameboard, for player: Player) -> Int? {
    // TODO: Is this ever called? searchForBlockingMove() should catch this use case!
    // TODO: Use specific var names (results1 and results2 too general)
    
    var result:Int?
    let openCells = calcOpenCells(gameboard)
    let opponent:Player = (player == .nought) ? .cross : .nought
    let occupiedCells = calcOccupiedCells(gameboard, for: opponent)
    let ownedCells = calcOccupiedCells(gameboard, for: player)


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
func searchForMiddleIfCorner(gameboard: Gameboard, for player: Player) -> Int? {
    // TODO: Use specific var names (results1 and results2 too general)
    
    var result:Int?
    let openCells = calcOpenCells(gameboard)
    let ownedCells = calcOccupiedCells(gameboard, for: player)

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
func searchForCornerIfOpponentHasMiddle(gameboard: Gameboard, for player: Player) -> Int? {
    // TODO: Use specific var names (results1 and results2 too general)

    var result:Int?
    let openCells = calcOpenCells(gameboard)
    let opponent:Player = (player == .nought) ? .cross : .nought
    let occupiedCells = calcOccupiedCells(gameboard, for: opponent)

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
func searchForCenterIfOpen(gameboard: Gameboard) -> Int? {
    var result:Int?
    let openCells = calcOpenCells(gameboard)

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
func searchForMiddleIfCenter(gameboard: Gameboard, for player: Player) -> Int? {
    // TODO: Use specific var names (results1 and results2 too general)

    var result:Int?
    let openCells = calcOpenCells(gameboard)
    let ownedCells = calcOccupiedCells(gameboard, for: player)

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
func searchForCornerOppositeOpponent(gameboard: Gameboard, for player: Player) -> Int? {
    var result:Int?
    let openCells = calcOpenCells(gameboard)
    let opponent:Player = (player == .nought) ? .cross : .nought
    let occupiedCells = calcOccupiedCells(gameboard, for: opponent)

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

/// Returns a random open corner move or nil
/// ❓⬜️❓
/// ⬜️⬜️⬜️
/// ❓⬜️❓
func searchForAnyOpenCorner(gameboard: Gameboard) -> Int? {
    var result:Int?
    let openCells = calcOpenCells(gameboard)

    let cornerCells = [0,2,6,8].filter {openCells.contains($0)}
    result = cornerCells.count > 0 ? cornerCells[diceRoll(cornerCells.count)] : nil
    return result
}

/// Returns a cell index that the AI wants to mark
/// NOTE: AI is always cross and player is always nought (regardless of mark)
func aiChoose(_ gameboard:Gameboard, unpredicible: Bool) -> Int? {
    
    var result:Int?
    let openCells = calcOpenCells(gameboard)

    // 1. Zero open cells
    if openCells.count > 0 {
        
        // 2. Unpredicible (need to turn this off to do a true test!)
        // x% of the time be unpredictible
        if result == nil && unpredicible {
            result = calcRandomCell(gameboard, threshold: 30)
            if result != nil { print("randomCell \(result!) threshold 30") }
        }
        
        // 3. Blocking move
        // Search for blocking move
        if result == nil {
            result = searchForBlockingMove(gameboard: gameboard, for: .cross)
            if result != nil { print("searchForBlockingMove \(result!)") }
        }
        
        // 4. Take another corner
        // If player has middle and corner and AI has oposite corner take another corner
        if result == nil {
            result = searchForAnotherCornerIfOpponentHasMiddleAndCorner(gameboard: gameboard, for: .cross)
            if result != nil { print("searchForAnotherCornerIfOpponentHasMiddleAndCorner \(result!)") }
        }
        
        // 5. Grab a middle
        // AI has a corner grab a middle
        if result == nil {
            result = searchForMiddleIfCorner(gameboard: gameboard, for: .cross)
            if result != nil { print("searchForMiddleIfCorner \(result!)") }
        }
        
        // 6. Grab a corner
        // Player has a middle grab a corner
        if result == nil {
            result = searchForCornerIfOpponentHasMiddle(gameboard: gameboard, for: .cross)
            if result != nil { print("have middle grab corner \(result!)") }
        }
        
        // 7. Grab the center
        // Grab the center if it's open
        if result == nil {
            result = searchForCenterIfOpen(gameboard: gameboard)
            if result != nil { print("grab center if open \(result!)") }

        }
        
        // 8. Grab a middle position
        // if AI has the center grab middle position
        if result == nil {
            result = searchForMiddleIfCenter(gameboard: gameboard, for: .cross)
            if result != nil { print("searchForMiddleIfCenter \(result!)") }
        }
        
        // 9. Grab corner opposite opponent
        // Search for a corner opposite the opponent
        if result == nil {
            result = searchForCornerOppositeOpponent(gameboard: gameboard, for: .cross)
            if result != nil { print("searchForCornerOppositeOpponent \(result!)") }
        }
        
        // 10. Winning Move
        // Search for winning move
         if result == nil {
            result = searchForWinningMove(gameboard, for: .cross)
            if result != nil { print("searchForWinningMove \(result!)") }
         }
        
        
        // 11. Any corner
        // Search for a corner
        if result == nil {
            result = searchForAnyOpenCorner(gameboard: gameboard)
            if result != nil { print("searchForAnyOpenCorner \(result!)") }
        }
        
        // 2. Random move
        // Search for random moves
        if result == nil {
            result = calcRandomCell(gameboard, threshold: 100)
            if result != nil { print("randomCell \(result!) threshold 100") }

        }
    } else {
        
        result = nil
    }
    if result != nil { print("result choosen \(result!)") }
    return result
}

/// Returns a random Int between 0 and chances
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


let freshGameboard:Gameboard = [.untouched, .untouched, .untouched,
                               .untouched, .untouched, .untouched,
                               .untouched, .untouched, .untouched]

var emojiGame = TicTacToeGame(gameboard:freshGameboard,
                              noughtMark: "⭕️",
                              crossMark: "❌",
                              untouchedMark: "⬜️",
                              gameOver: false)



