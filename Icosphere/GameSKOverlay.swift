import UIKit
import SpriteKit

class GameSKOverlay: SKScene {
    
    weak var mainView: GameViewController?
    
    var playButtonNode = SKSpriteNode()
    var titleGame = SKSpriteNode()
    
    var ScoreLabel = SKLabelNode(fontNamed: "Arial")
    var HighScoreLabel = SKLabelNode(fontNamed: "Arial")
    
    var ScoreNumber = 0
    var HighScoreNumber = 0
    
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
        
        self.addChild(playButtonNode)
        
        let titleTexture = SKTexture(image: UIImage(named: "Title")!)
        titleGame = SKSpriteNode(texture: titleTexture)
        titleGame.size = CGSize(width: 100, height: 150)
        titleGame.position = CGPoint(x: self.size.width / 2, y: (self.size.height / 2) + 180)
        self.addChild(titleGame)
        
        HighScoreLabel.text = "0"
        HighScoreLabel.fontColor = UIColor.white
        HighScoreLabel.fontSize = 20
        HighScoreLabel.position = CGPoint(x: self.size.width/2, y: (self.size.height)/10 - 48)
    }
    
    func addScoreLabel() {
        ScoreNumber = 0
        HighScoreLabel.text =  String("HighScore:\(HighScoreNumber)")
        self.addChild(HighScoreLabel)
    }
    
    
    func addMenuItems() {
        self.addChild(titleGame)
        self.addChild(playButtonNode)
    }
    
    func updateScoreLabel() {
        ScoreNumber += 1
        if ScoreNumber > HighScoreNumber {
            HighScoreNumber = ScoreNumber
            let scoreDefaults = UserDefaults.standard
            scoreDefaults.set(HighScoreNumber, forKey: "highscore")
            HighScoreLabel.text = String(HighScoreNumber)
        }
    }
    
    func silentScoreUpdate() {
        self.addChild(ScoreLabel)
        ScoreLabel.text = " "
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let main = mainView {
            main.touchesFunction(touches, with: event)
        }
    }
}







