

//  CarrotNode.swift
//  EndlessRabbit
//  Created by Ahmed Khan on 04/06/2024.

//  The CarrotNode class represents a carrot collectible in the game. It is an SCNNode subclass that loads and sets up the carrot model from the "Carrot.scn" scene file.

//  The carrot model is loaded from the "art.scnassets/Carrot.scn" file and added as child nodes to the CarrotNode. The shadows of the child nodes are disabled to optimize performance.

//  The CarrotNode is set up with a static physics body using a bounding box shape. The physics body is assigneda specific category bit mask to identify it as a carrot collectible during collision detection.

//  If the "Carrot.scn" file is not found or fails to load, an error message is printed to the console.



import SceneKit

class CarrotNode: SCNNode {
    static var bitMask: Int = 0
    
    override init() {
        super.init()
        
        if let carrotScene = SCNScene(named: "art.scnassets/carrot.scn") {
            for childNode in carrotScene.rootNode.childNodes {
                // Remove shadow
                childNode.castsShadow = false
                addChildNode(childNode)
            }
            

           

            // Add physics body to the carrot

            let shape = SCNPhysicsShape(node: self, options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.boundingBox])
            physicsBody = SCNPhysicsBody(type: .static, shape: shape)
            physicsBody?.categoryBitMask = CarrotNode.bitMask
            
            print("CarrotNode initialized from carrot.scn")
        } else {
            print("Failed to load carrot.scn")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
