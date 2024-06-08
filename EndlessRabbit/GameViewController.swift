
//  GameViewController.swift
//  EndlessRabbit
//  Created by Ahmed Khan on 04/06/2024.

//  This view controller is responsible for managing the game view and handling user interactions.
//  It sets up the SceneKit view, configures the game scene, and handles user gestures for controlling
//  the bunny's movement. It also responds to game over events and triggers the appropriate actions.
//
//  The view controller communicates with the game scene using the GameOverDelegate protocol to handle
//  game over events. It also binds the score from the game scene to update the score display in the
//  user interface.
//
//  It also manages the background audio playback and ensures that the game view is properly, laid out and displayed on the screen.


import UIKit
import SceneKit
import SwiftUI
import AVFoundation

protocol GameOverDelegate: AnyObject {
    func gameOverDidOccur()
}

class GameViewController: UIViewController, GameOverDelegate {
    var sceneView: SCNView!
    var gameScene: GameScene!
    var gameOver: (() -> Void)?
    var scoreBinding: Binding<Int>?
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create and configure the scene view
        sceneView = SCNView(frame: UIScreen.main.bounds)
        sceneView.allowsCameraControl = false
        sceneView.showsStatistics = false
        sceneView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sceneView.backgroundColor = .clear
        
        // Create and configure the game scene
        gameScene = GameScene()
        gameScene.background.contents = UIImage(named: "art.scnassets/MountainsPixelHd.png")
        
        gameScene.scoreBinding = scoreBinding
        gameScene.gameOverDelegate = self
        sceneView.scene = gameScene
        gameScene.moveCamera()
        
        view.addSubview(sceneView)
        
        setupGestures()
        playBackgroundSound()
    }
        
    func setupGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        sceneView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        sceneView.addGestureRecognizer(swipeRight)
    }
    
    @objc func handleSwipeLeft() {
        gameScene.handleSwipeLeft()
    }
    
    @objc func handleSwipeRight() {
        gameScene.handleSwipeRight()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneView.frame = view.bounds // Ensure the scene view takes the entire view
        sceneView.setNeedsLayout()
        sceneView.layoutIfNeeded()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    func triggerGameOver() {
        gameOver?()
    }
    
    func restartGame() {
       
        gameScene = GameScene()
        gameScene.scoreBinding = scoreBinding
        gameScene.gameOverDelegate = self
        sceneView.scene = gameScene
        gameScene.moveCamera()
    }

    func gameOverDidOccur() {
        triggerGameOver()
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
}
