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
    var shipScene: ShipScene?

    var posX: CGFloat = 0.0
    var posY: CGFloat = 0.0
    var posZ: CGFloat = -0.2
    var translationFactor: CGFloat = 0.3
    let touchHandler = TouchHandler()
    var planeNode: SCNNode?

    
    func setupSceneView () {
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        //show Debug options
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        //node = scene.rootNode.childNode(withName: "ship", recursively: true)
        shipScene = ShipScene()
        
        guard let scene = shipScene else {
            print("failed to load scene")
            return;
        }
        
        node = scene.getSceneNode();
        
        sceneView.scene.rootNode.addChildNode(node!)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSceneView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        if #available(iOS 11.3, *) {
            configuration.planeDetection = [.horizontal, .vertical]
        } else {
            // Fallback on earlier versions
            configuration.planeDetection = .horizontal
        }

        // Run the view's session
        sceneView.session.run(configuration)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
 
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
                    self.shipScene!.moveToRight()
                case .left:
                    self.shipScene!.moveToLeft()
                case .up:
                    self.shipScene!.moveUP()
                case .down:
                    self.shipScene!.moveDown()
                }
            }
        }
        
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("touchesEnded")
        
        
        let touch: UITouch = touches.first!
        let tag = touch.view?.tag
        
        self.touchHandler.onTouchEnd {
            
            if let tag = ControlTag(rawValue: tag!){
                switch tag {
                case .right:
                    self.shipScene!.onMoveRightRelease()
                case .left:
                    self.shipScene!.onMoveLeftRelease()
                case .up:
                    self.shipScene!.onMoveUpRelease()
                case .down:
                    self.shipScene!.onMoveDownRelease()

                }
            }
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
        shipScene!.moveForward()
    }
    
    
    @IBAction func onBack(_ sender: Any) {
       shipScene!.moveBackward()
    }
    

    // Try with a floor node instead - this didn't work so well but leaving in for reference
    func createPlaneNode(anchor: ARPlaneAnchor) -> SCNNode {
        
        let node = SCNNode()
        node.geometry = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        node.position = SCNVector3Make(anchor.center.x,0,anchor.center.z)
        
        return node
    }

    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        
        // Remove existing plane nodes
        node.enumerateChildNodes {
            (childNode, _) in
            childNode.removeFromParentNode()
        }
        if let node = planeNode {
            node.removeFromParentNode()
        }

        planeNode = createPlaneNode(anchor: planeAnchor)
        
        node.addChildNode(planeNode!)
    }
    
    // When a detected plane is updated, make a new planeNode
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // Remove existing plane nodes
        node.enumerateChildNodes {
            (childNode, _) in
            childNode.removeFromParentNode()
        }
        
        if let node = planeNode {
            node.removeFromParentNode()
           
        }
        
        planeNode = createPlaneNode(anchor: planeAnchor)
        node.addChildNode(planeNode!)
    }
    
    // When a detected plane is removed, remove the planeNode
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        
        // Remove existing plane nodes
        node.enumerateChildNodes {
            (childNode, _) in
            childNode.removeFromParentNode()
        }

        if let _node = planeNode {
            _node.removeFromParentNode()
        }
        
    }

//    // Override to create and configure nodes for anchors added to the view's session.
//    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//        let node = SCNNode()
//
//        return node
//    }

    
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
