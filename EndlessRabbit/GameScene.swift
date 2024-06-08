
//  GameScene.swift
//  EndlessRabbit
//  Created by Ahmed Khan on 04/06/2024.

//  This file contains the main game scene class, which is responsible for setting up and managing the game elements.
//  It handles the game logic, including spawning obstacles (carrots and trees), detecting collisions, updating the score, and triggering game over events.

//  The game scene is built using entirely using SceneKit and utilizes physics-based collision detection. It communicates with the game view controller using the GameOverDelegate protocol to notify when the game is over.

//  The game scene sets up the camera, lighting, ground, and the player character (bunny). It also handles user input
//  for controlling the bunny's movement between lanes.

//  The scene continuously spawns obstacles (carrots and trees) and moves them towards the player. The player's objective
//  is to collect carrots while avoiding collisions with trees. The score is incremented for each carrot collected and
//  is bound to the game view controller for updating the user interface.

//  The game scene also manages audio playback for sound effects, such as collecting carrots and the game over sound.

//  When a collision with a tree occurs, the game scene triggers the game over event and notifies the game view controller
//  to handle the game over state.

import SceneKit
import SwiftUI

class GameScene: SCNScene, SCNPhysicsContactDelegate {
    
    var cameraNode: SCNNode!
    var groundNode: SCNNode!
    var objectNode: SCNNode?
    var bunnyNode: SCNNode?
    var lanes: [Float] = [-1.7, 0, 1.7] //Three Lanes
    var currentLaneIndex = 1
    
    var score = 0
    var scoreBinding: Binding<Int>?
    
    weak var gameOverDelegate: GameOverDelegate?
    
    override init() {
        super.init()
        
        //All scenes
        setupCamera()
        setupLight()
        setupGround()
        setupBunny()
        setupCollisions()
        
        print("GameScene initialized")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 5, z: 10)
        cameraNode.eulerAngles = SCNVector3(x: -Float.pi / 12, y: 0, z: 0)
        rootNode.addChildNode(cameraNode)
        print("Camera set up")
    }
    
    func setupLight() {
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor(white: 0.75, alpha: 1.0)
        rootNode.addChildNode(ambientLightNode)
        
        let directionalLightNode = SCNNode()
        directionalLightNode.light = SCNLight()
        directionalLightNode.light!.type = .directional
        directionalLightNode.light!.color = UIColor(white: 1.0, alpha: 1.0)
        directionalLightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        rootNode.addChildNode(directionalLightNode)
        
        print("Light set up")
    }
    
    func setupGround() {
        groundNode = SCNNode()
        let groundGeometry = SCNFloor()
        groundGeometry.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/grassHd.png")
        
      
        groundGeometry.reflectivity = 0.0
        
        groundNode.geometry = groundGeometry
        groundNode.position = SCNVector3(x: 0, y: -0.1, z: 0)
        
     
        let groundShape = SCNPhysicsShape(geometry: groundGeometry, options: nil)
        let groundBody = SCNPhysicsBody(type: .static, shape: groundShape)
        groundNode.physicsBody = groundBody
        
        rootNode.addChildNode(groundNode)
        print("Ground set up")
    }
    
    func setupBunny() {
        guard let bunnyScene = SCNScene(named: "art.scnassets/rabbit.scn") else {
            print("Failed to load rabbit.scn")
            return
        }

        bunnyNode = bunnyScene.rootNode.childNodes.first!.clone()
        bunnyNode!.position = SCNVector3(x: lanes[currentLaneIndex], y: 0, z: 0)

        // Set the diffuse contents to Bunny.png
        if let bunnyGeometry = bunnyNode!.geometry {
            let material = SCNMaterial()
            material.diffuse.contents = UIImage(named: "art.scnassets/Bunny.png")
            bunnyGeometry.materials = [material]
        } else {
            bunnyNode!.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/Bunny.png")
        }

        bunnyNode!.enumerateChildNodes { (node, _) in
            node.castsShadow = false
        }

        let shape = SCNPhysicsShape(node: bunnyNode!, options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.boundingBox])
        let physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        physicsBody.isAffectedByGravity = false
        physicsBody.categoryBitMask = 1
        physicsBody.contactTestBitMask = 2 | 4
        bunnyNode!.physicsBody = physicsBody

        rootNode.addChildNode(bunnyNode!)
        print("Bunny set up")
    }
    func setupCollisions() {
       
        CarrotNode.bitMask = 2
        TreeNode.bitMask = 4
        
      
        physicsWorld.contactDelegate = self
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        
        if nodeA.physicsBody?.categoryBitMask == CarrotNode.bitMask || nodeB.physicsBody?.categoryBitMask == CarrotNode.bitMask {
            // Bunny collided with a carrot
            let carrotNode = (nodeA.physicsBody?.categoryBitMask == CarrotNode.bitMask) ? nodeA : nodeB
            carrotNode.removeFromParentNode()
            playChimpupSound()
            incrementScore()
            
        } else if nodeA.physicsBody?.categoryBitMask == TreeNode.bitMask || nodeB.physicsBody?.categoryBitMask == TreeNode.bitMask {
            // Bunny collided with a tree
            gameOver()
        }
    }
    
    func playChimpupSound() {
        guard let chimpupSound = SCNAudioSource(fileNamed: "art.scnassets/chimeup.mp3") else {
            print("Failed to load chimeup.mp3")
            return
        }
        chimpupSound.load()
        chimpupSound.volume = 1.0
        chimpupSound.isPositional = false
        let chimpupAction = SCNAction.playAudio(chimpupSound, waitForCompletion: false)
        rootNode.runAction(chimpupAction)
    }
    
    func incrementScore() {
        score += 1
        scoreBinding?.wrappedValue = score
    }
  
    
    func resetScore() {
        score = 0
        scoreBinding?.wrappedValue = score
    }

    func spawnObject() {
        let lane = lanes[Int.random(in: 0..<lanes.count)]
        let objectType = Bool.random() ? "tree" : "carrot"
        
        let objectNode: SCNNode
        
        if objectType == "tree" {
            objectNode = TreeNode()
        } else {
            objectNode = CarrotNode()
        }
        objectNode.position = SCNVector3(x: lane, y: 0, z: cameraNode.position.z - 50)
        
        DispatchQueue.main.async {
            self.rootNode.addChildNode(objectNode)
        }
        
        self.objectNode = objectNode
        print("\(objectType.capitalized) spawned")
    }
    
    func updateScene() {
        if let objectNode = objectNode {
            if objectNode.position.z > cameraNode.position.z {
                DispatchQueue.main.async {
                    objectNode.removeFromParentNode()
                }
                spawnObject()
            }
        } else {
            spawnObject()
        }
        
       
        bunnyNode?.position.z = cameraNode.position.z - 9
    }
    
    func moveCamera() {
        let moveCamera = SCNAction.moveBy(x: 0, y: 0, z: -3, duration: 0.3)
        let updateAction = SCNAction.run { _ in self.updateScene() }
        let sequence = SCNAction.sequence([moveCamera, updateAction])
        let repeatAction = SCNAction.repeatForever(sequence)
        cameraNode.runAction(repeatAction)
        print("Camera movement started")
    }
    
    func handleSwipeLeft() {
        if currentLaneIndex > 0 {
            currentLaneIndex -= 1
            moveRunningBunnyToLane(index: currentLaneIndex)
        }
    }
    
    func handleSwipeRight() {
        if currentLaneIndex < lanes.count - 1 {
            currentLaneIndex += 1
            moveRunningBunnyToLane(index: currentLaneIndex)
        }
    }
    
    func moveRunningBunnyToLane(index: Int) {
        let action = SCNAction.moveBy(x: CGFloat(lanes[index] - bunnyNode!.position.x), y: 0, z: 0, duration: 0.2)
        bunnyNode!.runAction(action)
    }
    
    func playRabbitFallsSound() {
        guard let rabbitFallsSound = SCNAudioSource(fileNamed: "art.scnassets/rabbitFalls.wav") else {
            print("Failed to load rabbitFalls.wav")
            return
        }
        rabbitFallsSound.load()
        rabbitFallsSound.volume = 1.0
        rabbitFallsSound.isPositional = false
        let rabbitFallsAction = SCNAction.playAudio(rabbitFallsSound, waitForCompletion: false)
        rootNode.runAction(rabbitFallsAction)
    }
    
    func gameOver() {
    
        cameraNode?.removeAllActions()
        
        
        playRabbitFallsSound()
        
        gameOverDelegate?.gameOverDidOccur()
    }
}
