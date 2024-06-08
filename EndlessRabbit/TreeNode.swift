
//  TreeNode.swift
//  EndlessRabbit
//  Created by Ahmed Khan on 04/06/2024.

//  The TreeNode class represents a tree obstacle in the game. It is an SCNNode subclass that loads and sets up the tree model from the "Tree.scn" scene file.

//  The tree model is loaded from the "art.scnassets/Tree.scn" file and added as child nodes to the TreeNode. The shadows of the child nodes are disabled to optimize performance.

//  The TreeNode is set up with a static physics body using a bounding box shape. The physics body is assigned a specific category bit mask to identify it as a tree obstacle during collision detection.

//  If the "Tree.scn" file is not found or fails to load, an error message is printed to the console.

import SceneKit

class TreeNode: SCNNode {
    static var bitMask: Int = 0
    
    override init() {
        super.init()
        
        if let treeScene = SCNScene(named: "art.scnassets/Tree.scn") {
            for childNode in treeScene.rootNode.childNodes {
                // Remove shadow
                childNode.castsShadow = false
                addChildNode(childNode)
            }
            
            let shape = SCNPhysicsShape(node: self, options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.boundingBox])
            physicsBody = SCNPhysicsBody(type: .static, shape: shape)
            physicsBody?.categoryBitMask = TreeNode.bitMask
            
            print("TreeNode initialized from Tree.scn")
        } else {
            print("Failed to load tree.scn")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
