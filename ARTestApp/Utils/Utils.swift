//
//  Utils.swift
//  ARTestApp
//
//  Created by Mehtab on 26/04/2018.
//  Copyright © 2018 Mehtab. All rights reserved.
//

import Foundation
import SceneKit

class Utils {
    
    class func degToRadians(degrees:Double) -> Double{
        return degrees * (Double.pi/2)
    }
    
    class func makePivotToCenter(for node: SCNNode) {
        var min = SCNVector3Zero
        var max = SCNVector3Zero
        node.__getBoundingBoxMin(&min, max: &max)
        node.pivot = SCNMatrix4MakeTranslation(
            min.x + (max.x - min.x)/2,
            min.y + (max.y - min.y)/2,
            min.z + (max.z - min.z)/2
        )
    }
}
