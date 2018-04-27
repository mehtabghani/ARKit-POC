
//
//  File.swift
//  ARTestApp
//
//  Created by Mehtab on 26/04/2018.
//  Copyright © 2018 Mehtab. All rights reserved.
//

import Foundation
import ARKit
import SceneKit


class ShipScene {
    var node: SCNNode?
    
    func loadScene() -> SCNScene {
        return SCNScene(named: "art.scnassets/ship.scn")!
    }
    
    func getSceneNode() -> SCNNode {
        let scene = loadScene()
        
        node = scene.rootNode.childNode(withName: "ship", recursively: true)
        Utils.makePivotToCenter(for: node!)
        return node!
    }
    
    
    // MARK: - Right controls

    
    func moveToRight() {
        SCNTransaction.animationDuration = 0.5
        node!.rotation = SCNVector4Make(0.0, 0.0, -0.5, 0.5)
        SCNTransaction.animationDuration = 0.5
        node!.position.x = node!.position.x + 0.2
    }
    func onMoveRightRelease() {
        SCNTransaction.animationDuration = 0.5
        node!.rotation = SCNVector4Make(0.0, 0.0, 0.0, 0.0)
    }
    
    // MARK: - Left controls
    
    func moveToLeft() {
        
        SCNTransaction.animationDuration = 0.5
        node!.rotation = SCNVector4Make(0.0, 0.0, 0.5, 0.5)
        SCNTransaction.animationDuration = 0.5
        node!.position.x = node!.position.x - 0.2
    }
    
    func onMoveLeftRelease() {
        SCNTransaction.animationDuration = 0.5
        node!.rotation = SCNVector4Make(0.0, 0.0, 0.0, 0.0)
    }
    
    // MARK: - Up controls
    func moveUP() {
        
        SCNTransaction.animationDuration = 0.5
        node!.rotation = SCNVector4Make(0.02, 0.0, 0.0, 0.5)
        SCNTransaction.animationDuration = 0.5
        node!.position.y = node!.position.y + 0.1
    }
    
    func onMoveUpRelease() {
        SCNTransaction.animationDuration = 0.5
        node!.rotation = SCNVector4Make(0.0, 0.0, 0.0, 0.0)
       
    }
    
    
    // MARK: - Down controls


    func moveDown() {
        SCNTransaction.animationDuration = 0.5
        node!.rotation = SCNVector4Make(-0.02, 0.0, 0.0, 0.5)
        SCNTransaction.animationDuration = 0.5
        node!.position.y = node!.position.y - 0.1
        
    }
    
    func onMoveDownRelease() {
        SCNTransaction.animationDuration = 0.5
        node!.rotation = SCNVector4Make(0.0, 0.0, 0.0, 0.0)
    }
    
    
    func moveForward() {
        let zpos:CGFloat = -0.5;
        NodeAnimation.moveNode(self.node!, xPosition: 0, yPosition: 0, zPosition: zpos, completion: {})
    }
    
    func moveBackward() {
        let zpos:CGFloat = 0.5;
        NodeAnimation.moveNode(self.node!, xPosition: 0, yPosition: 0, zPosition: zpos, completion: {})
    }
    
    
}
