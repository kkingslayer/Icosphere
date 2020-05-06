//
//  ObjectScene.swift
//  Icosphere
//
//  Created by Hisoka Morow on 04.05.2020.
//  Copyright © 2020 Hisoka Morow. All rights reserved.
//
import SceneKit
class FadeClass:  SCNScene {
 
    func fadeIn(node: SCNNode){
        node.opacity = 0;
        node.runAction(SCNAction.fadeIn(duration: 1.0))
    }
    
    func fadeCount(node: SCNNode){
        let move = SCNAction.move(to: SCNVector3Make(node.position.x, node.position.y + 2, node.position.z), duration: 0.1)
        node.runAction(move)
        node.runAction(SCNAction.fadeOut(duration: 0.1))
    }
    
    func fadeOut(node: SCNNode){
        let move = SCNAction.move(to: SCNVector3Make(node.position.x, node.position.y - 2, node.position.z), duration: 0.5)
        node.runAction(move)
        node.runAction(SCNAction.fadeOut(duration: 1.0))
    }
    
    
}








