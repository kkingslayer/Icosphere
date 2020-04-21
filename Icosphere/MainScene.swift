//
//  MainScene.swift
//  testGame
//
//  Created by Hisoka Morow on 02.04.2020.
//  Copyright © 2020 Hisoka Morow. All rights reserved.
//

import SceneKit
import UIKit
import QuartzCore
import SceneKit
import AudioToolbox

class MainScene:  SCNScene, SCNSceneRendererDelegate, SCNPhysicsContactDelegate {
    
      var scnView: SCNView!
      let scnScene = SCNScene()
      let cameraNode = SCNNode()
      var firstBox: SCNNode!
      var tempBox: SCNNode!
      var ball: SCNNode!
      var textt: SCNNode!
      var firstText: SCNText!
      var left = Bool()
      var correctPath = Bool()
      var repeatt = Bool()
      var firstBoxNumber = Int()
      var count = Int() ;
      var prevBoxNumber = Int()
      var score = Int()
      var highscore = Int()
      var dead = Bool()
      var scoreLabel = UILabel()
      var highscoreLabel = UILabel()
      var str = String()
      var showStatusBar = true
      var tesst:  SCNNode!
    
     let emptyGrass1 = SCNNode()
     let emptyGrass2 = SCNNode()
     
     var runningUpdate = true
     var timeLast: Double?
     let speedConstant = -0.7
     
     let empty = SCNNode()
     var bird = SCNNode()
     
     
     convenience init(create: Bool) {
         self.init()
           
           let rotationAction1 = SCNAction.rotate(toAxisAngle: SCNVector4(1, 0, 0, 0.78), duration: 0)
           let rotationAction2 = SCNAction.rotate(toAxisAngle: SCNVector4(1, 0, 0, -1.57), duration: 2)
           rotationAction2.timingMode = .easeOut
           
         //  rotationSeq = SCNAction.sequence([rotationAction1, rotationAction2])
          
           setupCameraAndLights()
           setupScenery()
           
           physicsWorld.gravity = SCNVector3(0, -5.0, 0)
           physicsWorld.contactDelegate = self
           
           let propsScene = SCNScene(named: "/art.scnassets/Icospheres.dae")!
           emptyGrass1.scale = SCNVector3(easyScale: 0.15)
           emptyGrass1.position = SCNVector3(0, -1.3, 0)
           
           emptyGrass2.scale = SCNVector3(easyScale: 0.15)
           emptyGrass2.position = SCNVector3(4.45, -1.3, 0)
           
           let grass1 = propsScene.rootNode.childNode(withName: "Icosphere", recursively: true)!
           grass1.position = SCNVector3(-5.0, 0, 0)
           
           let grass2 = grass1.clone()
           grass2.position = SCNVector3(-5.0, 0, 0)
           
           emptyGrass1.addChildNode(grass1)
           emptyGrass2.addChildNode(grass2)
           
           rootNode.addChildNode(emptyGrass1)
           rootNode.addChildNode(emptyGrass2)
         
     }
     
    func setupCameraAndLights() {
          let cameraNode = SCNNode()
          cameraNode.camera = SCNCamera()
          cameraNode.camera!.usesOrthographicProjection = false
          cameraNode.position = SCNVector3(0, 0, 0)
          cameraNode.pivot = SCNMatrix4MakeTranslation(0, 0, -3)
          rootNode.addChildNode(cameraNode)
          
          let lightOne = SCNLight()
          lightOne.type = .spot
          lightOne.spotOuterAngle = 90
          lightOne.attenuationStartDistance = 0.0
          lightOne.attenuationFalloffExponent = 2
          lightOne.attenuationEndDistance = 30.0
          
          let lightNodeSpot = SCNNode()
          lightNodeSpot.light = lightOne
          lightNodeSpot.position = SCNVector3(0, 10, 1)
          rootNode.addChildNode(lightNodeSpot)
          
          let lightNodeFront = SCNNode()
          lightNodeFront.light = lightOne
          lightNodeFront.position = SCNVector3(0, 1, 15)
          rootNode.addChildNode(lightNodeFront)
          
          let emptyAtCenter = SCNNode()
          emptyAtCenter.position = SCNVector3Zero
          rootNode.addChildNode(emptyAtCenter)
          
          lightNodeSpot.constraints = [SCNLookAtConstraint(target: emptyAtCenter)]
          lightNodeFront.constraints = [SCNLookAtConstraint(target: emptyAtCenter)]
          cameraNode.constraints = [SCNLookAtConstraint(target: emptyAtCenter)]
          
          let ambientLight = SCNNode()
          ambientLight.light = SCNLight()
          ambientLight.light!.type = .ambient
          ambientLight.light!.color = UIColor(white: 0.05, alpha: 1.0)
          rootNode.addChildNode(ambientLight)
      }
      
      func setupScenery() {
          
          let groundGeo = SCNBox(width: 4, height: 0.5, length: 0.4, chamferRadius: 0)
          groundGeo.firstMaterial!.diffuse.contents = #colorLiteral(red: 1, green: 0.7685058713, blue: 0, alpha: 1)
          groundGeo.firstMaterial!.specular.contents = UIColor.black
          groundGeo.firstMaterial!.emission.contents = #colorLiteral(red: 0.6220703125, green: 0.3915527463, blue: 0.06076388889, alpha: 1)
          
          let groundNode = SCNNode(geometry: groundGeo)
          
          let emptySand = SCNNode()
          emptySand.addChildNode(groundNode)
          emptySand.position.y = -1.63

          rootNode.addChildNode(emptySand)
          
          let collideGround = SCNNode(geometry: groundGeo)
          collideGround.opacity = 0
          collideGround.physicsBody = SCNPhysicsBody.kinematic()
          collideGround.physicsBody!.mass = 1000
          
          collideGround.position.y = -1.36
          
          rootNode.addChildNode(collideGround)
          
      }
    func addScore() {
             score += 1
            self.count += 1
            AudioServicesPlaySystemSound(1519)
            
            self.performSelector(onMainThread: #selector(GameViewController.updateScoreLabel), with: nil, waitUntilDone: false)
             if score > highscore {
                 highscore = score
                 let scoreDefaults = UserDefaults.standard
                 scoreDefaults.set(highscore, forKey: "highscore")
             }
         }
    
    
    func createCount( ){
               fadeCount(node: textt)
               textt = SCNNode()
               str = String(count)
               let whiteGeometry = SCNText(string: str, extrusionDepth: 0.3)
               whiteGeometry.font = UIFont.systemFont(ofSize: 1.0)
              // whiteGeometry.firstMaterial?.diffuse.contents = UIColor(red: 220, green: 200, blue: 200, alpha: 1)
               textt.geometry = whiteGeometry
           textt.position  = SCNVector3Make(-0.18, 0.8, -0.45)

                  // scnScene.rootNode.addChildNode(textt)
           self.ball.addChildNode(textt)


          }
    
    
        func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
            let nodeA = contact.nodeA
            let nodeB = contact.nodeB
            if nodeA.physicsBody?.categoryBitMask == bodyType.Coin && nodeB.physicsBody?.categoryBitMask == bodyType.Ball {
                nodeA.removeFromParentNode()
                addScore()
              //  if count > 0
             //   {( m: false)}
               createCount()
            }
            else if nodeA.physicsBody?.categoryBitMask == bodyType.Ball && nodeB.physicsBody?.categoryBitMask == bodyType.Coin {
                   nodeB.removeFromParentNode()
                addScore()
                createCount()
                // if count > 0 { createCount(m: false)}
               //    else { createCount( m: true)}
            }
        }
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
    
    
       func addCoin(box: SCNNode){
           scnScene.physicsWorld.gravity = SCNVector3Make(0, 0, 0)
           let rotate = SCNAction.rotate(toAxisAngle: SCNVector4(x: 0, y: 0.5, z: 0, w: .pi * 2), duration: 3.5)
        // let rotate =   SCNAction.
           let randomCoin = arc4random() % 5
                       if randomCoin == 3 {
                           let addCoinScene = SCNScene(named: "/art.scnassets/f.dae")
                           let coin = addCoinScene?.rootNode.childNode(withName: "Icosphere", recursively: true)
                           coin?.position = SCNVector3Make(box.position.x, box.position.y + 1, box.position.z)
                         coin?.scale = SCNVector3Make(0.2, 0.2, 0.2)
                           coin?.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: coin!, options: nil))
                           coin?.physicsBody?.categoryBitMask = bodyType.Coin
                           coin?.physicsBody?.collisionBitMask = bodyType.Ball
                           coin?.physicsBody?.contactTestBitMask = bodyType.Ball
                           coin?.physicsBody?.isAffectedByGravity = false
                           scnScene.rootNode.addChildNode(coin!)
                         coin?.runAction(SCNAction.repeatForever(rotate))
                         fadeIn(node: coin!)
                       }
       }
    
    func createBall(){
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
        
        textt = SCNNode()
             str = String(count)
             let whiteGeometry = SCNText(string: str, extrusionDepth: 0.3)
             whiteGeometry.font = UIFont.systemFont(ofSize: 1.0)
                                    whiteGeometry.firstMaterial?.diffuse.contents = UIColor.white
                    textt.geometry = whiteGeometry
        textt.position  = SCNVector3Make(-0.18, 0.8, -0.45)
        
        tesst = SCNNode()
        
        let tesstGeometry = SCNPyramid(width: 0.5, height: 0.35, length: 0.5)
               tesst = SCNNode (geometry: tesstGeometry)
               let tesstMaterial = SCNMaterial()
        tesstMaterial.diffuse.contents = UIColor(red: 0.94, green: 0.71, blue: 0.74, alpha: 1)
               tesstGeometry.materials = [tesstMaterial]
        tesst.position = SCNVector3Make(0, 0.14, 0)
        
        ball.addChildNode(tesst)
        ball.addChildNode(textt)
        rootNode.addChildNode(ball)
    }
    
    func createBoxes(){
                    tempBox = SCNNode(geometry: firstBox.geometry)
                    let prevBox = scnScene.rootNode.childNode(withName: "\(firstBoxNumber)", recursively: true)
                    firstBoxNumber += 1
                    tempBox.name = "\(firstBoxNumber)"
                    let randomNumber = arc4random() % 2
                    switch randomNumber {
                    case 0:
                        tempBox.position = SCNVector3Make((prevBox?.position.x)! - firstBox.scale.x, (prevBox?.position.y)!, (prevBox?.position.z)!)
                        if correctPath  == true{
                        correctPath = false
                            left = false}
                        break
                    case 1:
                         tempBox.position = SCNVector3Make((prevBox?.position.x)!, (prevBox?.position.y)!, (prevBox?.position.z)! - firstBox.scale.z)
                         if correctPath  == true{
                                        correctPath = false
                                            left = true}
                        break
                    default:
                        break
                    }
                    self.scnScene.rootNode.addChildNode(tempBox)
                addCoin(box: tempBox)
                fadeIn(node: tempBox)
        }
    
       func createBox(){
           let scoreDefaults = UserDefaults.standard
           if scoreDefaults.integer(forKey: "highscore") != 0 {
               highscore = scoreDefaults.integer(forKey: "highscore")}
               else {
                   highscore = 0
               }
           firstBoxNumber = 0
           prevBoxNumber = 0
           correctPath = true
           dead = false
           firstBox = SCNNode()
           let firstBoxGeomtry = SCNBox(width: 1, height: 1.5, length: 1, chamferRadius: 0)
           firstBox.geometry = firstBoxGeomtry
           let firstBoxMaterial = SCNMaterial()
           firstBoxMaterial.diffuse.contents = UIColor(red: 205, green: 92, blue: 92, alpha: 1)
           firstBoxGeomtry.materials = [firstBoxMaterial]
           firstBox.position = SCNVector3Make(0,0,0)
           scnScene.rootNode.addChildNode(firstBox)
           firstBox.name = "\(firstBoxNumber)"
           for _ in 0...7 {
              createBoxes()
    }
      

        func updateScoreLabel() {
              scoreLabel.text = "Score: \(score)"
              highscoreLabel.text = "Highscore: \(highscore)"
          }

        
        func die(){
                      ball.runAction(SCNAction.move(to: SCNVector3Make(ball.position.x, ball.position.y - 10, ball.position.z), duration: 1.0))
               let wait = SCNAction.wait(duration: 0.5)
               let removeBall = SCNAction.run { (node) in
                   self.scnScene.rootNode.enumerateChildNodes({ (node, stop) in node.removeFromParentNode()})
                   self.count = 0
                   self.score = 0
                   updateScoreLabel()
                  }
               
            func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
                   if dead == false{
                   let deleteBox = self.scnScene.rootNode.childNode(withName: "\(prevBoxNumber)", recursively: true)
                   let currentBox = self.scnScene.rootNode.childNode(withName: "\(prevBoxNumber + 1)", recursively: true)
                      if (deleteBox?.position.x)!  > ball.position.x + 1 || (deleteBox?.position.z)! > ball.position.z + 1 {
                          prevBoxNumber += 1
                         fadeOut(node: deleteBox!)
                          createBoxes()
                      }
                   if ball.position.x > currentBox!.position.x - 0.5 && ball.position.x < currentBox!.position.x + 0.5 ||
                       ball.position.z > currentBox!.position.z - 0.5 && ball.position.z < currentBox!.position.z + 0.5 //on platform
                   {}
                  else {die()
                       dead = true
                       }
                  }
               }
            
   

        
}
}
}
