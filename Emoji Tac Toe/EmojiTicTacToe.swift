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

enum PlayerRole:String {
    case untouched = "_"
    case nought = "o"
    case cross = "x"
}

typealias Gameboard = [PlayerRole]

// 0 1 2
// 3 4 5
// 6 7 8

let cellCorners = [0,2,6,8]
let cellMiddles = [1,3,5,7]
let cellCenter = 4
let cellTopLeftCorner = cellCorners[0]
let cellTopRightCorner = cellCorners[1]
let cellBottomleftCorner = cellCorners[2]
let cellBottomRightCorner = cellCorners[3]
let cells = [0,1,2,3,4,5,6,7,8]

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
    var gameboard: Gameboard
    var noughtMark: String
    var crossMark: String
    var untouchedMark: String
    var gameOver: Bool
    
    init(gameboard: Gameboard, noughtMark: String = "o", crossMark: String = "x",
         untouchedMark: String = "_", gameOver: Bool = false) {
        
        self.gameboard = gameboard
        self.noughtMark = noughtMark
        self.crossMark = crossMark
        self.untouchedMark = untouchedMark
        self.gameOver = gameOver
    }
    
    init(from text: String) {
        self.init(gameboard: transformTextIntoGameboard(textRepresentation: text) ?? freshGameboard)
    }
    
    var text: String {
        var result = ""
        
        for cell in gameboard {
            
            switch cell {
            case .untouched:
                result += "\(untouchedMark)"
            case .nought:
                result += "\(noughtMark)"
            case .cross:
                result += "\(crossMark)"
            }
        }
        
        return result
    }
    
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
            print("textRepresentation contains unexpected data--Abort!")
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
func seachForWinForPlayer(_ board:Gameboard, player:PlayerRole) -> Bool {
    
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
func calcOccupiedCells(_ gameboard: Gameboard, for player: PlayerRole) -> [Int] {
    return getUsedCells(gameboard, for: player)
}

/// Returns array of cells used by a mark or an empty array if none are found.
/// Player.untouched are open cells. Player.cross and Player.nought are
/// occupided cells.
func getUsedCells(_ gameboard: Gameboard, for mark: PlayerRole) -> [Int] {
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
func getRandomCell(_ gameboard: Gameboard, threshold: Int) -> Int? {
    
    let openCells = calcOpenCells(gameboard)
    if openCells.count == 0 {
        return nil
    }
    
    let chanceToBeRandom = diceRoll(100)
    if chanceToBeRandom <= threshold {
        return openCells.count > 0 ? openCells[diceRoll(openCells.count)] : nil
    }
    return nil
}

/// Returns true if there is 1 open cell and the player
/// can win if it takes that cell.
/// NOTE: This is pretty werid function. It is not a generalized check
///       that there exists a way to win on the board.
/// ⭕️❌❌
/// ⭕️❌❌
/// ❓⭕️⭕️
func isThereAFinalWinningMove(_ gameboard: Gameboard, for mark: PlayerRole) -> Bool {
    let openCells = calcOpenCells(gameboard)
    if openCells.count == 1 {
        return searchForWinningMove(gameboard, for: mark) != nil
    }
    return false
}

/// Returns a winning move for the player or nil
/// ⬜️❓⭕️
/// ⬜️❌⬜️
/// ⬜️❌⬜️
func searchForWinningMove(_ gameboard: Gameboard, for player: PlayerRole) -> Int? {
    let openCells = calcOpenCells(gameboard)
        
    for cell in openCells {
        var testGameboard = gameboard
        testGameboard[cell] = player
        
        if seachForWinForPlayer(testGameboard, player: player) {
            return cell
        }
    }
    return nil
}

/// Returns a block moving for specificed player, one that would pervent opponent
/// from win or nil is there is no blocking move
/// ⬜️❓❌
/// ⬜️⭕️⬜️
/// ⬜️⭕️⬜️
func searchForBlockingMove(_ gameboard: Gameboard, for player: PlayerRole) -> Int? {
    // reverse player as we find a winning move for the opponent and
    // return it as a blocking move for the player
    let opponent: PlayerRole = (player == .nought) ? .cross : .nought
    return searchForWinningMove(gameboard, for: opponent)
}

/// Returns a corner move for specific player if opponet has middle and a corner
/// and player has a corner or nil if no other corner move can be found
/// ❓⬜️❌
/// ⬜️⭕️⬜️
/// ❓⬜️⭕️
func searchForAnotherCornerIfOpponentHasMiddleAndCorner(_ gameboard: Gameboard, for player: PlayerRole) -> Int? {
    
    let occupiedCorners = getOccupiedCorners(gameboard, for: player)
    let occupiedMiddle = isMiddleOccupied(gameboard, for: player)
    let ownedCorners = getOwnedCorners(gameboard, for: player)
    
    return getStrategicCorner(gameboard, occupiedCorners, occupiedMiddle, ownedCorners)
}

fileprivate func getOwnedCorners(_ gameboard: Gameboard, for player: PlayerRole) -> [Int] {
    let ownedCells = calcOccupiedCells(gameboard, for: player)
    return cellCorners.filter {ownedCells.contains($0)}
}

fileprivate func isMiddleOccupied(_ gameboard: Gameboard, for player: PlayerRole) -> Bool {
    let opponent: PlayerRole = (player == .nought) ? .cross : .nought
    let occupiedCells = calcOccupiedCells(gameboard, for: opponent)
    return occupiedCells.contains(cellCenter)
}

fileprivate func getOccupiedCorners(_ gameboard: Gameboard, for player: PlayerRole) -> [Int] {
    let opponent: PlayerRole = (player == .nought) ? .cross : .nought
    let occupiedCells = calcOccupiedCells(gameboard, for: opponent)
    return cellCorners.filter {occupiedCells.contains($0)}
}

fileprivate func getStrategicCorner(_ gameboard: Gameboard,
                                    _ occupiedCorners: [Int],
                                    _ occupiedMiddle: Bool,
                                    _ ownedCorners: [Int]) -> Int? {

    let openCells = calcOpenCells(gameboard)
    if occupiedCorners.count > 0 && occupiedMiddle && ownedCorners.count > 0 {
        let availableCorners = cellCorners.filter {openCells.contains($0)}
        return availableCorners.count > 0 ? availableCorners[diceRoll(availableCorners.count)] : nil
    }
    return nil
}




/// Returns a middle move if the player already has an corner or nil
/// NOTE: Middle is not center. Center is cell 4 while cells 1, 3, 5, 7 are middles
/// ⬜️❓❌
/// ❓⬜️❓
/// ⬜️❓⭕️
func searchForMiddleIfCorner(_ gameboard: Gameboard, for player: PlayerRole) -> Int? {
    
    let ownedCorners = getOwnedCorners(gameboard, for: player)
    
    if ownedCorners.count > 0 {
        let openCells = calcOpenCells(gameboard)
        let openMiddles = cellMiddles.filter {openCells.contains($0)}
        return openMiddles.count > 0 ? openMiddles[diceRoll(openMiddles.count)] : nil
    }
    
    return nil
}

/// Returns a corner move if the opponent already has a middle or nil
/// NOTE: Middle is not center. Center is cell 4 while cells 1, 3, 5, 7 are middles
/// ❓⬜️❓
/// ⬜️❌⭕️
/// ❓⬜️❓
func searchForCornerIfOpponentHasMiddle(_ gameboard: Gameboard, for player: PlayerRole) -> Int? {

    let opponent:PlayerRole = (player == .nought) ? .cross : .nought
    let occupiedCells = calcOccupiedCells(gameboard, for: opponent)
    let occupiedMiddles = cellMiddles.filter {occupiedCells.contains($0)}
    
    if occupiedMiddles.count > 0 {
        let openCells = calcOpenCells(gameboard)
        let openCorners = cellCorners.filter {openCells.contains($0)}
        return openCorners.count > 0 ? openCorners[diceRoll(openCorners.count)] : nil
    }
    
    return nil
}

/// Returns a center move if open or nil if not.
/// ⬜️⬜️⬜️
/// ⬜️❓⬜️
/// ⬜️⬜️⬜️
func searchForCenterIfOpen(_ gameboard: Gameboard, for player: PlayerRole) -> Int? {
    let openCells = calcOpenCells(gameboard)
    return openCells.contains(cellCenter) ? cellCenter : nil
}

/// Returns a middle move if the player already has the center or nil
/// NOTE: Middle is not center. Center is cell 4 while cells 1, 3, 5, 7 are middles
/// ⬜️❓⬜️
/// ❓❌❓
/// ⬜️❓⭕️
func searchForMiddleIfCenter(_ gameboard: Gameboard, for player: PlayerRole) -> Int? {
    // TODO: Use specific var names (results1 and results2 too general)

    let ownedCells = calcOccupiedCells(gameboard, for: player)

    if ownedCells.contains(cellCenter) {
        let openCells = calcOpenCells(gameboard)
        let openMiddles = cellMiddles.filter {openCells.contains($0)}
        return openMiddles[diceRoll(openMiddles.count)]
    }
    
    return nil
}

/// Returns a corner move opposite the opponents corner or nil
// 0 1 2
// 3 4 5
// 6 7 8

/// ❓⬜️⬜️
/// ⬜️⬜️⬜️
/// ⬜️⬜️⭕️
func searchForCornerOppositeOpponent(_ gameboard: Gameboard, for player: PlayerRole) -> Int? {
    let openCells = calcOpenCells(gameboard)
    let opponent:PlayerRole = (player == .nought) ? .cross : .nought
    let occupiedCells = calcOccupiedCells(gameboard, for: opponent)
    
    if occupiedCells.contains(cellTopLeftCorner) {
        if openCells.contains(cellBottomRightCorner) {
            return cellBottomRightCorner
        }
    } else if occupiedCells.contains(cellTopRightCorner) {
        if openCells.contains(cellBottomleftCorner) {
            return cellBottomleftCorner
        }
    } else if occupiedCells.contains(cellBottomleftCorner) {
        if openCells.contains(cellTopRightCorner) {
            return cellTopRightCorner
        }
    } else if occupiedCells.contains(cellBottomRightCorner) {
        if openCells.contains(cellTopLeftCorner) {
            return cellTopLeftCorner
        }
    }
    return nil
}

/// Returns a random open corner move or nil
/// ❓⬜️❓
/// ⬜️⬜️⬜️
/// ❓⬜️❓
func searchForAnyOpenCorner(_ gameboard: Gameboard, for player: PlayerRole) -> Int? {
    let openCells = calcOpenCells(gameboard)
    let cornerCells = cellCorners.filter {openCells.contains($0)}
    return cornerCells.count > 0 ? cornerCells[diceRoll(cornerCells.count)] : nil
}

/// Returns a cell index that the AI wants to mark.
/// NOTE: AI is always cross and player is always nought (regardless of mark).
/// This is essentially a big switch statement. It starts from the top
/// and works its way to the end of the function. If, at anytime, result
/// != nil no other functions are called and the the result (the move)
/// is returned. Oney one result (move) can be returned.
func aiChoose(_ gameboard:Gameboard, unpredicible: Bool) -> (Int, String) {
    
    var cellChosen: Int?
    var moveChosen = ""
    let openCells = calcOpenCells(gameboard)

    // 1. Zero open cells
    if openCells.count > 0 {
        
        // 2. Unpredicible (need to turn this off to do a true test!)
        // x% of the time be unpredictible
        if cellChosen == nil && unpredicible {
            cellChosen = getRandomCell(gameboard, threshold: 30)
            if cellChosen != nil { moveChosen = "Any Move" }
        }
        
        // 10. Winning Move
        // Search for winning move
        if cellChosen == nil {
            cellChosen = searchForWinningMove(gameboard, for: .cross)
            if cellChosen != nil { moveChosen = "Winning Move" }
        }
        
        // 3. Blocking move
        // Search for blocking move
        if cellChosen == nil {
            cellChosen = searchForBlockingMove(gameboard, for: .cross)
            if cellChosen != nil { moveChosen = "Blocking Move" }
        }
        
        // 4. Take another corner
        // If player has middle and corner and AI has oposite corner take another corner
        if cellChosen == nil {
            cellChosen = searchForAnotherCornerIfOpponentHasMiddleAndCorner(gameboard, for: .cross)
            if cellChosen != nil { moveChosen = "Take Another Corner" }
        }
        
        // 5. Grab a middle
        // AI has a corner grab a middle
        if cellChosen == nil {
            cellChosen = searchForMiddleIfCorner(gameboard, for: .cross)
            if cellChosen != nil { moveChosen = "Grab A Middle If Corner" }
        }
        
        // 6. Grab a corner
        // Player has a middle grab a corner
        if cellChosen == nil {
            cellChosen = searchForCornerIfOpponentHasMiddle(gameboard, for: .cross)
            if cellChosen != nil { moveChosen = "Grab A Corner" }
        }
        
        // 7. Grab the center
        // Grab the center if it's open
        if cellChosen == nil {
            cellChosen = searchForCenterIfOpen(gameboard, for: .cross)
            if cellChosen != nil { moveChosen = "Grab The Center" }

        }
        
        // 8. Grab a middle position
        // if AI has the center grab middle position
        if cellChosen == nil {
            cellChosen = searchForMiddleIfCenter(gameboard, for: .cross)
            if cellChosen != nil { moveChosen = "Grab A Middle If Center" }
        }
        
        // 9. Grab corner opposite opponent
        // Search for a corner opposite the opponent
        if cellChosen == nil {
            cellChosen = searchForCornerOppositeOpponent(gameboard, for: .cross)
            if cellChosen != nil { moveChosen = "Corner Opposite Opponent" }
        }
        
        // 11. Any corner
        // Search for a corner
        if cellChosen == nil {
            cellChosen = searchForAnyOpenCorner(gameboard, for: .cross)
            if cellChosen != nil { moveChosen = "Any Corner" }
        }
        
        // 12. Random move
        // Search for random moves
        if cellChosen == nil {
            cellChosen = getRandomCell(gameboard, threshold: 100)
            if cellChosen != nil { moveChosen = "Any Move Any How" }

        }
    }
    
    if cellChosen != nil { print("moveChosen \(moveChosen), cellChosen \(cellChosen!)") }
    return (cellChosen!, moveChosen)
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


