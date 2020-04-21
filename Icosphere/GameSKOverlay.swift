//
//  GameSKOverlay.swift
//  FlappyBird3D
//
//  Created by Test on 15.11.2017.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit
import SpriteKit

class GameSKOverlay: SKScene {
    
    weak var mainView: GameViewController?
    
    var playButtonNode = SKSpriteNode()
    var titleGame = SKSpriteNode()
    var replayButtonNode = SKSpriteNode()
    
    var scoreLabel = SKLabelNode(fontNamed: "Arial")
    var scoreNumber = 0
    
    convenience init(main: GameViewController, size: CGSize) {
        self.init(sceneSize: size)
        mainView = main
    }
    
    convenience init(sceneSize: CGSize) {
        self.init(size: sceneSize)
        
        let playTexture = SKTexture(image: UIImage(named: "Play")!)
        playButtonNode = SKSpriteNode(texture: playTexture)
        playButtonNode.size = CGSize(width: 100, height: 100)
        playButtonNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        playButtonNode.position = CGPoint(x: self.size.width / 2, y: (self.size.height / 2) - 100)
        playButtonNode.name = "playButton"
        
        let replayTexture = SKTexture(image: UIImage(named: "Replay")!)
        replayButtonNode = SKSpriteNode(texture: playTexture)
        replayButtonNode.size = CGSize(width: 100, height: 100)
        replayButtonNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        replayButtonNode.position = CGPoint(x: self.size.width / 2, y: (self.size.height / 2) - 200)
        replayButtonNode.name = "replayButton"
        
        self.addChild(playButtonNode)
        
        let titleTexture = SKTexture(image: UIImage(named: "Title")!)
        titleGame = SKSpriteNode(texture: titleTexture)
        titleGame.size = CGSize(width: 100, height: 150)
        titleGame.position = CGPoint(x: self.size.width / 2, y: (self.size.height / 2) + 180)
        
        self.addChild(titleGame)
        
        scoreLabel.text = "0"
        scoreLabel.fontColor = UIColor.white
        scoreLabel.fontSize = 64
        scoreLabel.position = CGPoint(x: self.size.width / 2, y: (self.size.height) - 72)
    }
    
    func addScoreLabel() {
        
        replayButtonNode.alpha = 0
        
        scoreNumber = 12
        scoreLabel.text = String(scoreNumber)
        
        self.addChild(scoreLabel)
    }
    
    func addReplayButton() {
        let opacityUp = SKAction.fadeAlpha(to: 1, duration: 0.5)
        
        self.addChild(replayButtonNode)
        replayButtonNode.run(opacityUp)
    }
    
    func addMenuItems() {
        self.addChild(titleGame)
        self.addChild(playButtonNode)
    }
    
    func updateScoreLabel() {
        scoreNumber += 1
        scoreLabel.text = String(scoreNumber)
    }
    
    func silentScoreUpdate() {
        self.addChild(scoreLabel)
        scoreLabel.text = " "
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let main = mainView {
            main.touchesFunction(touches, with: event)
        }
    }
}







