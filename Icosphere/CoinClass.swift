//
//  CoinClass.swift
//  Icosphere
//
//  Created by Hisoka Morow on 06.05.2020.
//  Copyright © 2020 Hisoka Morow. All rights reserved.
//
import SceneKit

class CoinClass:  SCNScene {
    let  fade =  FadeClass()
    var count = Int();
    
   func addCoin(box: SCNNode) -> SCNNode!{
             physicsWorld.gravity = SCNVector3Make(0, 0, 0)
             let rotate = SCNAction.rotate(toAxisAngle: SCNVector4(x: 0, y: 0.5, z: 0, w: .pi * 2), duration: 3.5)
            // let randomCoin = arc4random() % 8
             //if randomCoin == 3 {
                 let addCoinScene = SCNScene(named: "/art.scnassets/coin_2.dae")
                 let coin = addCoinScene?.rootNode.childNode(withName: "Icos", recursively: true)
                 coin?.position = SCNVector3Make(box.position.x, box.position.y + 1, box.position.z)
                 coin?.scale = SCNVector3Make(0.2, 0.2, 0.2)
                 coin?.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: coin!, options: nil))
                 coin?.physicsBody?.categoryBitMask = bodyType.Coin
                 coin?.physicsBody?.collisionBitMask = bodyType.Ball
                 coin?.physicsBody?.contactTestBitMask = bodyType.Ball
                 coin?.physicsBody?.isAffectedByGravity = false
              //   rootNode.addChildNode(coin!)
                 coin?.runAction(SCNAction.repeatForever(rotate))
                 fade.fadeIn(node: coin!)
                return coin
           //  }
         }
    
}

