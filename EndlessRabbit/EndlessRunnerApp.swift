
//  EndlessRunnerApp.swift
//  EndlessRabbit
//  Created by Ahmed Khan on 04/06/2024.

//  The EndlessRunnerApp struct serves as the entry point of the application. It defines the app's main scene and handles the transition from the launch screen to the main content view.

//  The app starts by displaying a dedicated launch screen (LaunchScreenView) for 2 seconds, featuring the game's title and a game controller icon. This launch screen provides a visually appealing introduction to the game while the app is loading.

//  After the specified duration, the app seamlessly transitions to the main content view (ContentView), which represents the core user interface and functionality of the game. The transition is achieved using a ZStack and a conditional statement based on the showLaunchScreen state variable.

//  The ContentView is configured to hide the status bar and ignore the safe area, allowing for a fully immersive gaming experience. The app's scene is set up to occupy the entire available screen space.


import SwiftUI


struct EndlessRunnerApp: App {
    @State private var showLaunchScreen = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showLaunchScreen {
                    LaunchScreenView()
                        .onAppear {
                           
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                showLaunchScreen = false
                            }
                        }
                } else {
                    ContentView()
                        .statusBar(hidden: true)
                        .ignoresSafeArea()
                }
            }
            .ignoresSafeArea(.all, edges: .all)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct LaunchScreenView: View {
    var body: some View {
    
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            
            VStack {
                Image(systemName: "gamecontroller.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    
                
                Text("Endless Rabbit")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    
            }
        }
    }
}
