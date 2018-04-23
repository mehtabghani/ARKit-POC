//
//  ViewController.swift
//  ARTestApp
//
//  Created by Mehtab on 09/04/2018.
//  Copyright © 2018 Mehtab. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

enum ControlTag : Int {
    case right = 1
    case left  = 2
    case up = 3
    case down = 4
}

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var node: SCNNode?

    var posX: CGFloat = 0.0
    var posY: CGFloat = 0.0
    var posZ: CGFloat = -0.2
    var translationFactor: CGFloat = 0.3
    let touchHandler = TouchHandler()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        //show Debug options
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        node = scene.rootNode.childNode(withName: "ship", recursively: true)
        // Set the scene to the view
        //sceneView.scene = scene

        
        sceneView.scene.rootNode.addChildNode(node!)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       updateNodePosition()
 
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
//    func addNode(parentNode pNode:SCNNode){
//        let node = SCNNode()
//        node.geometry = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)
//        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
//        node.position = SCNVector3(posX,posY,posZ)
//        //sceneView.scene.rootNode.addChildNode(node!)
//
//       // add child node to parent node
//        pNode.addChildNode(node)
//    }
    
    func updateNodePosition() {
        guard let n = node else {
            return
        }
        
        n.position = SCNVector3(posX, posY, posZ)
    }
    
    func degToRadians(degrees:Double) -> Double{
        return degrees * (Double.pi/2)
    }
    
    
    func rotateNodeTo(_ node: SCNNode, xPosition x:CGFloat, yPosition y:CGFloat, zPosition z:CGFloat, completion: @escaping() -> Void) {
        let action = SCNAction.rotateTo(x: x, y: y, z: z, duration: 0.5)
        node.runAction(action) {
            completion()
        }
    }
    

    //rotate node relative to its position
    func rotateNode(_ node: SCNNode, xPosition x:CGFloat, yPosition y:CGFloat, zPosition z:CGFloat, completion: @escaping() -> Void) {
        let action = SCNAction.rotateBy(x: x, y: y, z: z, duration: 0.5)
        node.runAction(action) {
            completion()
        }
        
    }
    
    func moveNode(_ node: SCNNode, xPosition x:CGFloat, yPosition y:CGFloat, zPosition z:CGFloat,
                  completion: @escaping () -> Void) {
        let action = SCNAction.moveBy(x: x, y: y, z: z, duration: 3)
        action.timingMode = .easeIn
        node.runAction(action) {
            completion()
        }
    }
    
    func moveToRight() {
        let zRotate:CGFloat = 0.5
        let xpos:CGFloat = 0.2

        self.moveNode(self.node!, xPosition: xpos, yPosition: 0, zPosition: 0, completion: {})
        rotateNode(node!, xPosition: 0, yPosition: 0, zPosition: -zRotate, completion: {})
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) { // change 2 to desired number of seconds
            self.rotateNode(self.node!, xPosition: 0, yPosition: 0, zPosition: zRotate, completion: {})
        }
    }
    
    func moveToLeft() {
        let zRotate:CGFloat = 0.5
        let xpos:CGFloat = -0.2
        self.moveNode(self.node!, xPosition: xpos, yPosition: 0, zPosition: 0, completion: {})
       rotateNode(node!, xPosition: 0, yPosition: 0, zPosition: zRotate, completion: {})
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) { // change 2 to desired number of seconds
            self.rotateNode(self.node!, xPosition: 0, yPosition: 0, zPosition: -zRotate, completion: {})
        }
    }
    
    
    func moveUP() {
        let xRotate:CGFloat = 0.1
        let ypos:CGFloat = 0.2

        rotateNode(node!, xPosition: xRotate, yPosition: 0, zPosition: 0, completion: {})
        self.moveNode(self.node!, xPosition: 0, yPosition: ypos, zPosition: 0, completion: {})
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { // change 2 to desired number of seconds
            self.rotateNode(self.node!, xPosition: -xRotate, yPosition: 0, zPosition: 0, completion: {})
        }
    }
    
    func moveDown() {
        let xRotate:CGFloat = 0.1
        let ypos:CGFloat = -0.2

        rotateNode(node!, xPosition: -xRotate, yPosition: 0, zPosition: 0, completion: {})
        self.moveNode(self.node!, xPosition: 0, yPosition: ypos, zPosition: 0, completion: {})
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { // change 2 to desired number of seconds
            self.rotateNode(self.node!, xPosition: xRotate, yPosition: 0, zPosition: 0, completion: {})
        }

    }
    
    func moveForward() {
        let zpos:CGFloat = -0.5;
        self.moveNode(self.node!, xPosition: 0, yPosition: 0, zPosition: zpos, completion: {})
    }
    func moveBackward() {
        let zpos:CGFloat = 0.5;
        self.moveNode(self.node!, xPosition: 0, yPosition: 0, zPosition: zpos, completion: {})
    }
 
    
//Touch events
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        print("touchesBegan")
        let touch: UITouch = touches.first!
        let tag = touch.view?.tag
        print("Tag: \(tag!)")
        touchHandler.onTouchBegan {
            if let tag = ControlTag(rawValue: tag!){
                switch tag {
                case .right:
                    self.moveToRight()
                case .left:
                    self.moveToLeft()
                case .up:
                    self.moveUP()
                case .down:
                    self.moveDown()
                }
            }
        }
        
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("touchesEnded")
        
        self.touchHandler.onTouchEnd {
        }
    }
    
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesCancelled(touches, with: event)
//        print("touchesCancelled")
//
//        self.touchHandler.onTouchEnd {
//        }
//    }
//

//Button action methods
    
 

    @IBAction func onForward(_ sender: Any) {
        moveForward()
    }
    
    
    @IBAction func onBack(_ sender: Any) {
        moveBackward()
    }
    


    
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        

        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required

    }
}
