
//  ContentView.swift
//  EndlessRabbit
//  Created by Ahmed Khan on 04/06/2024.

//  This file contains the main content view of the app, which is built using SwiftUI. It manages the game state and  transitions between different screens (start screen, game screen, and game over screen).

//  The content view uses a `ZStack` to layer the different screens on top of each other and an `enum` to keep track of the current game state. It also manages the game score and binds it to the game view controller.

 //  The start screen, built entirely with SwiftUI, features an engaging design with an animated rabbit, decorative leaf images, and an enticing start button. When pressed, the game transitions seamlessly to the game screen using SwiftUI's navigation and animation capabilities, providing an immersive experience for the player.

//  The entire start and end screen is built using swiftUI's powerful animation capabilities.

//  The game screen contains the `GameViewControllerWrapper`, which is a `UIViewControllerRepresentable` that wraps
//  the `GameViewController` in swiftUI. It allows the integration of the SceneKit-based game view controller into the SwiftUI view hierarchy. The game screen also displays the current score using a text view.

//  The game over screen is shown when the game ends. It displays the final score and a restart button. When the
//  restart button is pressed, the game transitions back to the game screen, and the score is reset.

//  The content view also handles audio playback for the game over sound effect and the background music. It uses
//  `AVAudioPlayer` to play the sounds.

//  The `GameViewControllerWrapper` is responsible for creating and updating the `GameViewController` instance.
//  It receives the game over callback and score binding from the content view and passes them to the game view controller.


import SwiftUI
import AVFoundation

struct ContentView: View {
    enum GameState {
        case startScreen, gameScreen, gameOverScreen
    }
    
    @State private var gameState = GameState.startScreen
    @State private var score = 0
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        ZStack {
            switch gameState {
            case .startScreen:
                StartScreenView(startGame: startGame)
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .gameScreen:
                GameView(gameOver: gameOver, score: $score)
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .gameOverScreen:
                GameOverView(score: score, restartGame: restartGame)
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear {
                        playRabbitFallsSound()
                    }
            }
        }
    }
       
    func startGame() {
        withAnimation {
            gameState = .gameScreen
        }
        resetScore()
    }
    
    func gameOver() {
        withAnimation {
            gameState = .gameOverScreen
        }
    }
    
    func restartGame() {
        withAnimation {
            gameState = .gameScreen
        }
        resetScore()
    }
    
    func playRabbitFallsSound() {
        guard let soundURL = Bundle.main.url(forResource: "art.scnassets/rabbitFalls", withExtension: "wav") else {
            print("Failed to load rabbitFalls.wav")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }

    func playBackgroundSound() {
        guard let soundURL = Bundle.main.url(forResource: "bgSound", withExtension: "mp3", subdirectory: "art.scnassets") else {
            print("Failed to load bgSound.mp3")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.numberOfLoops = -1 
            audioPlayer?.play()
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }

    func resetScore() {
        score = 0
    }
}

struct StartScreenView: View {
    var startGame: () -> Void
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    
    var body: some View {
        ZStack {
          
            LinearGradient(gradient: Gradient(colors: [.teal, .brown]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
                
            
            
            VStack {
                HStack {
                    Image(systemName: "leaf.fill")
                        .resizable()
                        .frame(width: 90, height: 90) // Reverted size
                        .foregroundColor(.green)
                        .padding(.leading, 20)
                        .padding(.top, 20)
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: "leaf.fill")
                        .resizable()
                        .frame(width: 90, height: 90)
                        .foregroundColor(.green)
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                }
            }

            // Main content
            VStack {
                Image(systemName: "hare.fill")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                    .shadow(radius: 10)
                    .scaleEffect(scale)
                    .opacity(opacity)
                
                Text("Endless Rabbit")
                    .font(.system(size: 60, weight: .bold, design: .rounded)) // Reverted size
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                    .scaleEffect(scale)
                    .opacity(opacity)
                
                Button(action: startGame) {
                    Text("Start Game")
                        .font(.system(size: 35, weight: .bold, design: .rounded)) // Reverted size
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
                .padding(.top, 40)
                .scaleEffect(scale)
                .opacity(opacity)
            }
            .onAppear {
                withAnimation(.easeIn(duration: 1.5).delay(0.5)) {
                    scale = 1.0
                    opacity = 1.0
                }
            }
        }
    }
}

struct GameView: View {
    var gameOver: () -> Void
    @Binding var score: Int
    
    var body: some View {
        ZStack {
            GameViewControllerWrapper(gameOver: gameOver, score: $score)
            
            VStack {
                Spacer()
                
                Text("🥕: \(score)")
                    .font(.system(size: 50, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
}

struct GameOverView: View {
    var score: Int
    var restartGame: () -> Void
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.red, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Game Over")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                    .shadow(radius: 10)
                    .scaleEffect(scale)
                    .opacity(opacity)
                
                Text("Score: \(score)")
                    .font(.title)
                    .foregroundColor(.yellow)
                    .padding(.bottom, 40)
                    .shadow(radius: 10)
                    .scaleEffect(scale)
                    .opacity(opacity)
                
                Button(action: restartGame) {
                    Text("Restart")
                        .font(.title)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.red)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
                .padding(.top, 20)
                .scaleEffect(scale)
                .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: 1.5).delay(0.5)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}

struct GameViewControllerWrapper: UIViewControllerRepresentable {
    var gameOver: () -> Void
    @Binding var score: Int

    func makeUIViewController(context: Context) -> GameViewController {
        let gameViewController = GameViewController()
        gameViewController.gameOver = gameOver
        gameViewController.scoreBinding = $score
        return gameViewController
    }

    func updateUIViewController(_ uiViewController: GameViewController, context: Context) {
        // Update the view controller if needed
    }
}
