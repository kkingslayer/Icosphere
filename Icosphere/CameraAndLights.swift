//
//  AngleScene.swift
//  Icosphere
//
//  Created by Hisoka Morow on 03.05.2020.
//  Copyright © 2020 Hisoka Morow. All rights reserved.
//
import SceneKit
class CameraAndLights: SCNScene {
    
    let cameraNode = SCNNode()
    let light1 = SCNNode()
    let light2 = SCNNode()
    func setupCamera(Object: SCNNode) {
        
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.usesOrthographicProjection = true
        cameraNode.camera?.orthographicScale = 3
        cameraNode.position = SCNVector3Make(20,20, 20)
        cameraNode.eulerAngles = SCNVector3Make(-45, 45, 0)
        let constraint = SCNLookAtConstraint(target: Object)
        constraint.isGimbalLockEnabled = true
        cameraNode.constraints = [constraint]
        rootNode.addChildNode(cameraNode)
        Object.addChildNode(cameraNode)
        
    }
    
    func setupLights1() ->SCNNode {
        
        light1.light = SCNLight()
        light1.light?.type = .directional
        light1.eulerAngles = SCNVector3Make(-45, 45, 0)
        
        light2.light = SCNLight()
        light2.light?.type = .directional
        light2.eulerAngles = SCNVector3Make(45, 45, 0)
        
        light1.addChildNode(light2)
        return light1
        
    }
    
}
