//
//  Input.swift
//  Icosphere
//
//  Created by Hisoka Morow on 06.05.2020.
//  Copyright © 2020 Hisoka Morow. All rights reserved.
//

import SceneKit

class BallClass:  SCNScene{
    var str = String()
    var hat:  SCNNode!
    var ball: SCNNode!
    var count_nimb: SCNNode!
    let  fade =  FadeClass()
    var count = Int();
    
    func createCount( ){
        fade.fadeCount(node: count_nimb)
        count_nimb = SCNNode()
        str = String(count)
        let whiteGeometry = SCNText(string: str, extrusionDepth: 0.3)
        whiteGeometry.font = UIFont.systemFont(ofSize: 1.0)
        whiteGeometry.firstMaterial?.diffuse.contents = UIColor(red: 220, green: 200, blue: 200, alpha: 1)
        count_nimb.geometry = whiteGeometry
        count_nimb.position  = SCNVector3Make(-0.18, 0.8, -0.45)
        ball.addChildNode(count_nimb)
    }
    
    func createBall() -> SCNNode{
        ball = SCNNode()
        let ballGeometry = SCNSphere(radius: 0.2)
        ball = SCNNode (geometry: ballGeometry)
        let ballMaterial = SCNMaterial()
        ballMaterial.diffuse.contents = UIColor(red: 0.71, green: 0.48, blue: 0.61, alpha: 1)
        ballGeometry.materials = [ballMaterial]
        ball.position = SCNVector3Make(0, 1.1, 0)
        ball.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: ball, options: nil))
        ball.physicsBody?.categoryBitMask = bodyType.Ball
        ball.physicsBody?.collisionBitMask = bodyType.Coin
        ball.physicsBody?.isAffectedByGravity = false
        
        count_nimb = SCNNode()
        str = String(count)
        let whiteGeometry = SCNText(string: str, extrusionDepth: 0.3)
        whiteGeometry.font = UIFont.systemFont(ofSize: 1.0)
        whiteGeometry.firstMaterial?.diffuse.contents = UIColor.white
        count_nimb.geometry = whiteGeometry
        count_nimb.position  = SCNVector3Make(-0.18, 0.8, -0.45)
        
        hat = SCNNode()
        let hatGeometry = SCNPyramid(width: 0.5, height: 0.35, length: 0.5)
        hat = SCNNode (geometry: hatGeometry)
        let hatMaterial = SCNMaterial()
        hatMaterial.diffuse.contents = UIColor(red: 0.94, green: 0.71, blue: 0.74, alpha: 1)
        hatGeometry.materials = [hatMaterial]
        hat.position = SCNVector3Make(0, 0.14, 0)
        
        ball.addChildNode(hat)
        ball.addChildNode(count_nimb)
        return ball
    }
}

