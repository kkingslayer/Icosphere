//
//  GameViewController.swift
//  Icosphere
//
//  Created by Hisoka Morow on 21.04.2020.
//  Copyright © 2020 Hisoka Morow. All rights reserved.
//
import SceneKit
import UIKit
import QuartzCore
import SceneKit
import AudioToolbox
struct bodyType {
    
    static let Ball = 0x1 << 1
    static let Coin = 0x1 << 2
}

class GameViewController: UIViewController {
    var scnView: SCNView!
    
    var ball: SCNNode!
    var gameScene: MainScene?
    var menuScene: MenuScene?
    static var gameOverlay: GameSKOverlay?
    
    let scnScene = SCNScene()
    let cameraNode = SCNNode()
    
    var textt: SCNNode!
    var firstText: SCNText!
    var left = Bool()
    var correctPath = Bool()
    var repeatt = Bool()
    var prevBoxNumber = Int()
    var scoreLabel = UILabel()
    var highscoreLabel = UILabel()
    var str = String()
    var showStatusBar = true
    var tesst:  SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScene()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if let overlay = GameViewController.gameOverlay {
            overlay.silentScoreUpdate()
        }
    }
    
    
    func changeScene(_ newScene: SCNScene?, newDelegate: SCNSceneRendererDelegate?, completion: (() -> Void)!) {
        if let scene = newScene, let skOverlay = GameViewController.gameOverlay, let delegate = newDelegate {
            skOverlay.removeAllChildren()
            scnView.scene = scene
            scnView.delegate = delegate
            completion()
        }
    }
    
    
    func setupView() {
        self.view.backgroundColor = UIColor(red: 0.94, green: 0.71, blue: 0.74, alpha: 0.74)
        scnView = self.view as? SCNView
    }
    
    func setupScene() {
        menuScene = MenuScene(create: true)
        GameViewController.gameOverlay = GameSKOverlay(main: self, size: self.view.frame.size)
        if let scene = menuScene, let overlay = GameViewController.gameOverlay {
            scnView.scene = scene
            scnView.isPlaying = true
            scnView.delegate = scene
            scnView.overlaySKScene = overlay
        }
    }
    
    func setupCamera() {
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.usesOrthographicProjection = true
        cameraNode.camera?.orthographicScale = 3
        cameraNode.position = SCNVector3Make(20,20,20)
        cameraNode.eulerAngles = SCNVector3Make(-45,45,0)
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    
    func setupLight() {
        let light = SCNNode()
        light.light = SCNLight()
        light.light?.type = SCNLight.LightType.directional
        light.eulerAngles = SCNVector3Make(-45,45,0)
        scnScene.rootNode.addChildNode(light)
        
        let light2 = SCNNode()
        light2.light = SCNLight()
        light2.light?.type = SCNLight.LightType.directional
        light2.eulerAngles = SCNVector3Make(45,45,0)
        scnScene.rootNode.addChildNode(light2)
    }
    
    func checkNodeAtPosition(_ touch: UITouch) -> String? {
        if let skOverlay = GameViewController.gameOverlay {
            
            let location = touch.location(in: scnView)
            let node = skOverlay.atPoint(CGPoint(x: location.x, y: self.scnView.frame.size.height - location.y))
            
            if let name = node.name {
                return name
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    func touchesFunction(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let scene = gameScene {
            
            scene.touchh()
        }
        
        if let touch = touches.first {
            if let name = checkNodeAtPosition(touch) {
                if name == "playButton" {
                    gameScene = MainScene(create: true)
                    changeScene(gameScene, newDelegate: gameScene, completion: {
                        GameViewController.gameOverlay!.addScoreLabel()
                        self.menuScene = nil
                    })
                    
                }
            }
        }
    }
    override var prefersStatusBarHidden: Bool {return true}
}
