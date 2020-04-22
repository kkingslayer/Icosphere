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
    
    
    var runningUpdate = true
    var timeLast: Double?
    let speedConstant = -0.7
    let empty = SCNNode()
    
    
    
    func touchh() {
        if dead == false {
            // self.performSelector(onMainThread: #selector(GameViewController.updateScoreLabel), with: nil, waitUntilDone: false)
            if left == false {
                ball.removeAllActions()
                ball.runAction(SCNAction.repeatForever(SCNAction.move(by: SCNVector3Make(-50, 0, 0), duration: 20)))
                left = true
            } else {
                ball.removeAllActions()
                ball.runAction(SCNAction.repeatForever(SCNAction.move(by: SCNVector3Make(0, 0, -50), duration: 20)))
                left = false
            }
        }
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
        
        rootNode.addChildNode(textt)
        ball.addChildNode(textt)
        
        
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
        physicsWorld.gravity = SCNVector3Make(0, 0, 0)
        let rotate = SCNAction.rotate(toAxisAngle: SCNVector4(x: 0, y: 0.5, z: 0, w: .pi * 2), duration: 3.5)
        // let rotate =   SCNAction.
        let randomCoin = arc4random() % 5
        if randomCoin == 3 {
            let addCoinScene = SCNScene(named: "/art.scnassets/f.dae")
            let coin = addCoinScene?.rootNode.childNode(withName: "Icos", recursively: true)
            coin?.position = SCNVector3Make(box.position.x, box.position.y + 1, box.position.z)
            coin?.scale = SCNVector3Make(0.2, 0.2, 0.2)
            coin?.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: coin!, options: nil))
            coin?.physicsBody?.categoryBitMask = bodyType.Coin
            coin?.physicsBody?.collisionBitMask = bodyType.Ball
            coin?.physicsBody?.contactTestBitMask = bodyType.Ball
            coin?.physicsBody?.isAffectedByGravity = false
            rootNode.addChildNode(coin!)
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
        let prevBox = rootNode.childNode(withName: "\(firstBoxNumber)", recursively: true)
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
        rootNode.addChildNode(tempBox)
        addCoin(box: tempBox)
        fadeIn(node: tempBox)
    }
    
    
    
    
    func createBox() {
        
        let scoreDefaults = UserDefaults.standard
        if scoreDefaults.integer(forKey: "highscore") != 0 {
            highscore = scoreDefaults.integer(forKey: "highscore")
        } else {
            highscore = 0
        }
        //print(highscore)
        
        firstBoxNumber = 0
        prevBoxNumber = 0
        correctPath = true
        dead = false
        
        firstBox = SCNNode()
        
        let firstBoxGeometry = SCNBox(width: 1, height: 1.5, length: 1, chamferRadius: 0)
        firstBox.geometry = firstBoxGeometry
        let firstBoxMaterial = SCNMaterial()
        firstBoxMaterial.diffuse.contents = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        firstBoxGeometry.materials = [firstBoxMaterial]
        firstBox.position = SCNVector3Make(0, 0, 0)
        rootNode.addChildNode(firstBox)
        firstBox.name = "\(firstBoxNumber)"
        firstBox.opacity = 1
        
        for _ in 0...6 {createBoxes()}
    }
    
    func updateScoreLabel() {
        scoreLabel.text = "Score: \(score)"
        highscoreLabel.text = "Highscore: \(highscore)"
    }
    
    
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if dead == false {
            let deleteBox = self.rootNode.childNode(withName: "\(prevBoxNumber)", recursively: true)
            
            let currentBox = self.rootNode.childNode(withName: "\(prevBoxNumber + 1)", recursively: true)
            
            if deleteBox!.position.x > ball.position.x + 1 || deleteBox!.position.z > ball.position.z + 1 {
                prevBoxNumber += 1
                fadeOut(node: deleteBox!)
                createBoxes()
            }
            
            if ball.position.x > currentBox!.position.x - 0.5 && ball.position.x < currentBox!.position.x + 0.5 || ball.position.z > currentBox!.position.z - 0.5 && ball.position.z < currentBox!.position.z + 0.5 {
                //On Platform
            } else {
                die()
                dead = true
            }
        }
    }
    
    
    
    func setupCameraAndLights() {
        let cameraNode = SCNNode()
        
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.usesOrthographicProjection = true
        cameraNode.camera?.orthographicScale = 3
        cameraNode.position = SCNVector3Make(20,20, 20)
        cameraNode.eulerAngles = SCNVector3Make(-45, 45, 0)
        let constraint = SCNLookAtConstraint(target: ball)
        constraint.isGimbalLockEnabled = true
        cameraNode.constraints = [constraint]
        rootNode.addChildNode(cameraNode)
        ball.addChildNode(cameraNode)
        
        let light = SCNNode()
        light.light = SCNLight()
        light.light?.type = .directional
        light.eulerAngles = SCNVector3Make(-45, 45, 0)
        rootNode.addChildNode(light)
        
        let light2 = SCNNode()
        light2.light = SCNLight()
        light2.light?.type = .directional
        light2.eulerAngles = SCNVector3Make(45, 45, 0)
        rootNode.addChildNode(light2)
    }
    func die() {
        ball.runAction(SCNAction.move(to: SCNVector3Make(ball.position.x, ball.position.y - 10, ball.position.z), duration: 1.0))
        
        let wait = SCNAction.wait(duration: 0.5)
        
        let removeBall = SCNAction.run { (node) in
            self.rootNode.enumerateChildNodes({ (node, stop) in
                node.removeFromParentNode()
            })
        }
        
        let createScene = SCNAction.run { (node) in
            self.createBox()
            self.createBall()
            self.setupCameraAndLights()
            
        }
        
        let sequance = SCNAction.sequence([wait, removeBall, createScene])
        
        ball.runAction(sequance)
    }
    
    
    convenience init(create: Bool) {
        self.init()
        
        createBox()
        createBall()
        setupCameraAndLights()
        /*touchh()*/
        //   physicsWorld.contactDelegate = self
        
    }
}





