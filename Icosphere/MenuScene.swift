

import SceneKit

class MenuScene: SCNScene, SCNSceneRendererDelegate {
    
    let emptyGrass1 = SCNNode()
    let emptyGrass2 = SCNNode()
    
    var runningUpdate = true
    var timeLast: Double?
    let speedConstant = -0.7
    
    let empty = SCNNode()
    var bird = SCNNode()
    
    
    convenience init(create: Bool) {
        self.init()
        
        setupCameraAndLights()
        setupScenery()
        
        let propsScene = SCNScene(named: "/art.scnassets/IcosphereCoin.dae")!
        emptyGrass1.scale = SCNVector3(easyScale: 0.15)
        emptyGrass1.position = SCNVector3(7, -1.36, 0)
        
        emptyGrass2.scale = SCNVector3(easyScale: 0.15)
        emptyGrass2.position = SCNVector3(0, -1.36, 0)
        
        let grass1 = propsScene.rootNode.childNode(withName: "IcosphereCoin", recursively: true)!
        grass1.position = SCNVector3(-17, 0.5, 0)
        
        let grass2 = grass1.clone()
        grass2.position = SCNVector3(0, 0.5, 0)
        
        emptyGrass1.addChildNode(grass1)
        emptyGrass2.addChildNode(grass2)
        
        rootNode.addChildNode(emptyGrass1)
        rootNode.addChildNode(emptyGrass2)
        
        
        let upMove = SCNAction.move(by: SCNVector3(0, 0.1, 0), duration: 0.1)
        upMove.timingMode = .easeInEaseOut
        
        let downMove = SCNAction.move(by: SCNVector3(0, -0.1, 0), duration: 0.1)
        downMove.timingMode = .easeInEaseOut
        
        let upDownSeq = SCNAction.sequence([upMove, downMove])
        
        empty.runAction(SCNAction.repeatForever(upDownSeq))
        
        rootNode.addChildNode(empty)
        
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
        groundGeo.firstMaterial!.diffuse.contents = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        groundGeo.firstMaterial!.specular.contents = UIColor.black
        groundGeo.firstMaterial!.emission.contents = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        let groundNode = SCNNode(geometry: groundGeo)
        let emptySand = SCNNode()
        emptySand.addChildNode(groundNode)
        emptySand.position.y = -1.63
        rootNode.addChildNode(emptySand)
        
    }
  
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let dt: Double
        if runningUpdate {
            if let lt = timeLast {
                dt = time - lt
            } else {
                dt = 0
            }
        } else {
            dt = 0
        }
        
        timeLast = time
        
        moveGrass(node: emptyGrass1, dt: dt)
        moveGrass(node: emptyGrass2, dt: dt)
    }
    
    func moveGrass(node: SCNNode, dt: Double) {
        node.position.x += Float(dt * speedConstant)
        
        if node.position.x <= -4.45 {
            node.position.x = 4.45
        }
    }
}
extension SCNVector3 {
    
    init(easyScale: Float) {
        self.init()
        self.x = easyScale
        self.y = easyScale
        self.z = easyScale
    }
}
