//
//  EmojiTacToeViewController.swift
//  Emoji Tac Toe
//  television
//
//  Created by John Pavley on 8/14/16.
//  Copyright © 2016 Epic Loot. All rights reserved.
//

import UIKit

class EmojiTacToeViewController: UIViewController {
    
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocusInContext(context, withAnimationCoordinator: coordinator)
        
        if let nextFocusedView = context.nextFocusedView {
            if 1...9 ~= nextFocusedView.tag {
                let button = view.viewWithTag(nextFocusedView.tag) as! UIButton
                button.backgroundColor = UIColor.yellowColor()
            }
        }
        
        if let previouslyFocusedView = context.previouslyFocusedView {
            if 1...9 ~= previouslyFocusedView.tag {
                let button = view.viewWithTag(previouslyFocusedView.tag) as! UIButton
                button.backgroundColor = UIColor.whiteColor()
            }
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
