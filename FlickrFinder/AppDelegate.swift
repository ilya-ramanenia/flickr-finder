//
//  AppDelegate.swift
//  FlickrFinder
//
//  Created by ilya Ramanenia on 17.07.21.
//

import UIKit
import IQKeyboardManagerSwift


// TODO: #v2
// UI tests
// Failed requests retry
// Try Combine state-managing


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Code-less solution to make keyboard not cover textfields
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 50
        
        // Configuring shared session
        URLSession.shared.configuration.urlCache?.diskCapacity = 20 * 1000 * 1000
        URLSession.shared.configuration.urlCache?.memoryCapacity = 10 * 1000 * 1000
        URLSession.shared.configuration.waitsForConnectivity = true
        
        return true
    }
}
