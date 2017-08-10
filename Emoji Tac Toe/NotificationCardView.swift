//
//  NotificationCardView.swift
//  Emoji Tac Toe
//
//  Created by John Pavley on 8/9/17.
//  Copyright © 2017 Epic Loot. All rights reserved.
//

import UIKit

@IBDesignable class NotificationCardView: UIView {

    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 24.0)
        UIColor.lightGray.setFill()
        path.fill()
    }
}
