//
//  NodeAnimation.swift
//  ARTestApp
//
//  Created by Mehtab on 26/04/2018.
//  Copyright © 2018 Mehtab. All rights reserved.
//

import SceneKit
import Foundation

class NodeAnimation {
    static let rotateDuration = 0.5
    static let translateDuration = 2.0

    
    class func rotateNodeTo(_ node: SCNNode, xPosition x:CGFloat, yPosition y:CGFloat, zPosition z:CGFloat, completion: @escaping() -> Void) {
        let action = SCNAction.rotateTo(x: x, y: y, z: z, duration: rotateDuration)
        node.runAction(action) {
            completion()
        }
    }
    
    
    //rotate node relative to its position
    class func rotateNode(_ node: SCNNode, xPosition x:CGFloat, yPosition y:CGFloat, zPosition z:CGFloat, completion: @escaping() -> Void) {
        let action = SCNAction.rotateBy(x: x, y: y, z: z, duration: rotateDuration)
        node.runAction(action) {
            completion()
        }
        
    }
    
    class func moveNode(_ node: SCNNode, xPosition x:CGFloat, yPosition y:CGFloat, zPosition z:CGFloat,
                  completion: @escaping () -> Void) {
        let action = SCNAction.moveBy(x: x, y: y, z: z, duration: translateDuration)
        action.timingMode = .easeIn
        node.runAction(action) {
            completion()
        }
    }
}
