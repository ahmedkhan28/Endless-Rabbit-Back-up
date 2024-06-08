
//  AppDelegate.swift
//  EndlessRabbit
//  Created by Ahmed Khan on 04/06/2024.

//  The AppDelegate class is responsible for managing the application's lifecycle and setting up the initial window and root view controller. It handles the app's launch process and coordinates with the SceneDelegate.


import UIKit
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
            
        
        let rootView = ContentView()
        let hostingController = UIHostingController(rootView: rootView)
        window?.rootViewController = hostingController
        
      
        window?.makeKeyAndVisible()
        
        return true
    }
    
    // MARK: - UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
       
        let sceneConfiguration = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        
 
        sceneConfiguration.sceneClass = UIWindowScene.self
        
       
        sceneConfiguration.delegateClass = SceneDelegate.self
        
        return sceneConfiguration
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
       
        window = UIWindow(windowScene: windowScene)
        

        let rootView = ContentView()
        let hostingController = UIHostingController(rootView: rootView)
        window?.rootViewController = hostingController
        
        
        window?.makeKeyAndVisible()
        

    }
}
