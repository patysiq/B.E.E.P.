import SpriteKit
import GameplayKit

class LightFloorMoveComponent: GKComponent {
    
    private var node: SKSpriteNode {
        guard let node = entity?.component(ofType: SpriteComponent.self)?.node else {
            fatalError("This entity don't have node")
        }
        return node
    }
    
    override init() {
        super.init()
    }
    
    func move(direction: String) -> SKAction{
        
        let move: SKAction
        
        switch direction {
        case "up":
            move = SKAction.move(by: CGVector(dx: 32, dy: 16), duration: 0)
        case "left":
            move = SKAction.move(by: CGVector(dx: -32, dy: 16), duration: 0)
        case "down":
                move = SKAction.move(by: CGVector(dx: -32, dy: -16), duration: 0)
        case "right":
            move = SKAction.move(by: CGVector(dx: 32, dy: -16), duration: 0)
        default:
            move = SKAction.move(by: CGVector(dx: 0, dy: 0), duration: 0)
            
        }
        
        let sequence = SKAction.sequence([SKAction.wait(forDuration: 0.7), move])
        return sequence
    }
    func moveComplete(move: [SKAction]){
        
        let sequence = SKAction.sequence(move)
        node.run(sequence)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
