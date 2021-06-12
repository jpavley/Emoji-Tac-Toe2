//
//  AppDelegate.swift
//  Emo Tac Toe
//
//  Created by John Pavley on 7/13/16.
//  Copyright © 2016 Epic Loot. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            let _ = handleShortcut(shortcutItem.localizedTitle)
        }
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleShortcut(shortcutItem.localizedTitle))
    }
    
    let newGameID = "New Game"
    let singlePlayerID  = "Single Player"
    let twoPlayerID = "Two Player"
    let mainStoryboardID = "Main"
    let newGameViewControllerID = "NewGame"
    let gameBoardViewControllerID = "GameBoard"
    
    func handleShortcut(_ shortcutValue: String) -> Bool {
        
        switch shortcutValue {
        case newGameID:
            newGame()
        case singlePlayerID:
            singlePlayer()
        case twoPlayerID:
            twoPlayer()
        default:
            print("error in handleShortcut()")
        }
        
        return true
    }
    
    fileprivate func newGame() {
        let storyboard = UIStoryboard(name: mainStoryboardID, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: newGameViewControllerID) as! NewGameViewController
        makeWindowVisible(with: vc)
    }
    
    fileprivate func singlePlayer() {
        let storyboard = UIStoryboard(name: mainStoryboardID, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: gameBoardViewControllerID) as! ViewController
        makeWindowVisible(with: vc)
        gameEngine.aiEnabled = true
    }
    
    fileprivate func twoPlayer() {
        let storyboard = UIStoryboard(name: mainStoryboardID, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: gameBoardViewControllerID) as! ViewController
        makeWindowVisible(with: vc)
        gameEngine.aiEnabled = false
    }
    
    fileprivate func makeWindowVisible(with vc: UIViewController) {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }
}

