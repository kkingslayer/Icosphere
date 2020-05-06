//
//  MainScene.swift
//  testGame
//
//  Created by Hisoka Morow on 02.04.2020.
//  Copyright © 2020 Hisoka Morow. All rights reserved.
//
import SceneKit
import AudioToolbox

class MainScene:  SCNScene, SCNSceneRendererDelegate, SCNPhysicsContactDelegate {
    let  an = CameraAndLights()
    let  fade = FadeClass()
    let  ballClass = BallClass()
    let  coinClass = CoinClass()
    
    var scnview: SCNView!
    let scnScene = SCNScene()
    var firstBox: SCNNode!
    var tempBox: SCNNode!
    var ball: SCNNode!
    var coin: SCNNode!
    
    var left = Bool()
    var correctPath = Bool()
    var firstBoxNumber = Int()
    var prevBoxNumber = Int()
    var dead = Bool()
    
    var Light: SCNNode!
    
    func touchh() {
        if dead == false {
            if left == false {
                ball.removeAllActions()
                ball.runAction(SCNAction.repeatForever(SCNAction.move(by: SCNVector3Make(-50, 0, 0), duration: 13)))
                left = true
            } else {
                ball.removeAllActions()
                ball.runAction(SCNAction.repeatForever(SCNAction.move(by: SCNVector3Make(0, 0, -50), duration: 13)))
                left = false
            }
        }
    }
    
    
    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        if nodeA.physicsBody?.categoryBitMask == bodyType.Coin && nodeB.physicsBody?.categoryBitMask == bodyType.Ball {
            nodeA.removeFromParentNode()
            GameViewController.gameOverlay!.updateScoreLabel()
            self.ballClass.count += 1
            AudioServicesPlaySystemSound(1519)
            ballClass.createCount()
        }
        else if nodeA.physicsBody?.categoryBitMask == bodyType.Ball && nodeB.physicsBody?.categoryBitMask == bodyType.Coin {
            nodeB.removeFromParentNode()
            GameViewController.gameOverlay!.updateScoreLabel()
            self.ballClass.count += 1
            AudioServicesPlaySystemSound(1519)
            ballClass.createCount()
        }
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if dead == false {
            let deleteBox = self.rootNode.childNode(withName: "\(prevBoxNumber)", recursively: true)
            
            let currentBox = self.rootNode.childNode(withName: "\(prevBoxNumber + 1)", recursively: true)
            
            if deleteBox!.position.x > ball.position.x + 1 || deleteBox!.position.z > ball.position.z + 1 {
                prevBoxNumber += 1
                fade.fadeOut(node: deleteBox!)
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
        coin = coinClass.addCoin(box: tempBox)
        let randomCoin = arc4random() % 8
        if randomCoin == 3{ rootNode.addChildNode(coin)}
        fade.fadeIn(node: tempBox)
    }
    
    
    func createBox() {
        let scoreDefaults = UserDefaults.standard
        if scoreDefaults.integer(forKey: "highscore") != 0 {
            GameViewController.gameOverlay!.HighScoreNumber = scoreDefaults.integer(forKey: "highscore")
        } else {
            GameViewController.gameOverlay!.HighScoreNumber = 0
        }
        
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
    
    
    func die() {
        ball.runAction(SCNAction.move(to: SCNVector3Make(ball.position.x, ball.position.y - 10, ball.position.z), duration: 1.0))
        
        let wait = SCNAction.wait(duration: 0.5)
        
        let removeBall = SCNAction.run { (node) in
            self.rootNode.enumerateChildNodes({ (node, stop) in
                node.removeFromParentNode()
            })
        }
        ballClass.count = 0
        GameViewController.gameOverlay!.ScoreNumber = 0
        let createScene = SCNAction.run { (node) in
            self.createBox()
            self.ball = self.ballClass.createBall()
            self.rootNode.addChildNode(self.ball)
            self.an.setupCamera(Object: self.ball)
            self.Light = self.an.setupLights1()
            self.rootNode.addChildNode(self.Light)
        }
        
        let sequance = SCNAction.sequence([wait, removeBall, createScene])
        ball.runAction(sequance)
        
    }
    
    convenience init(create: Bool) {
        self.init()
        createBox()
        ball = ballClass.createBall()
        rootNode.addChildNode(ball)
        an.setupCamera(Object: ball)
        Light = an.setupLights1()
        rootNode.addChildNode(Light)
        
        physicsWorld.contactDelegate = self
    }
}








