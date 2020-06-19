//
//  MapScene.swift
//  B.E.E.P.
//
//  Created by Nathália Cardoso on 09/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import SpriteKit
import GameplayKit

class MapScene:SKScene {
    
    var entityManager:EntityManager!
    var filamentScale:CGFloat = -1
    var posicao:Int = 0
    var locationAnterior:CGPoint = CGPoint(x: 0, y: 0)
    var touchesBeganLocation = CGPoint(x: 0, y: 0)
    
    lazy var backName:String = {return self.userData?["backSaved"] as? String ?? "mapScene"}()
    
    var map = ["stage-available","stage-unavailable","filament-available","filament-unavailable","light-floor-stage-available","robot-stage-available"]
    
    override func didMove(to view: SKView) {

        entityManager = EntityManager(scene: self)
        
        drawBackground()
        
        //drawn hint button

        addEntity(entity: HudButton(name: "hint-button"), nodeName: "hint-button", position: CGPoint(x: frame.maxX-100, y: frame.maxY-50), zPosition: 2, alpha: 1.0)
        //drawn config button
        addEntity(entity: HudButton(name: "config-button"), nodeName: "config-button", position: CGPoint(x: frame.maxX-150, y: frame.maxY-50), zPosition: 2, alpha: 1.0)

        buildMap()
    }
    
    func drawBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.name = "background"
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.size = CGSize(width: size.width, height: size.height)
        addChild(background)
    }
    
    func drawnMaps(height:Int, width:Int, tilesetReference: CGPoint, status:String, showRobot:Bool) {
        var lightFloorPosition = CGPoint(x: 0, y: 0)
        var stageUnavailablePosition = CGPoint(x: 0, y: 0)
        for i in 1...width {
            for j in 1...height {
                // posição do tileset
                let x = (CGFloat(32*(i - 1)) - CGFloat(32*(j - 1))) + tilesetReference.x
                let y = (CGFloat(-16*(i - 1)) - CGFloat(16*(j - 1))) + tilesetReference.y
                
                addEntity(entity:Tileset(status: status), nodeName: "stage-\(status)", position: CGPoint(x: x, y: y), zPosition: CGFloat(i + j), alpha: 1.0)
    
                if (i-1) == (width-1)/2 && (j-1) == (height-1)/2 {
                    if showRobot {
                        lightFloorPosition = CGPoint(x: x, y: y)
                        //desenhando o robo
                        addEntity(entity:Robot(), nodeName: "robot-stage-available", position: CGPoint(x: lightFloorPosition.x, y: lightFloorPosition.y+31), zPosition: 101, alpha: 1.0)
                        //desenhando o light floor
                        addEntity(entity: LightFloor(), nodeName: "light-floor-stage-available", position: lightFloorPosition, zPosition: 100, alpha: 0.7)
                    } else {
                        stageUnavailablePosition = CGPoint(x: x, y: y+21)
                      }
                }
            }
        }
        if status == "unavailable" {
            addEntity(entity: StageUnavailable(), nodeName: "stage-unavailable", position: stageUnavailablePosition, zPosition: 100, alpha: 1.0)
        }
    }
    
    func addEntity(entity:GKEntity, nodeName:String, position:CGPoint, zPosition:CGFloat, alpha: CGFloat) {
        
        if let spriteComponent = entity.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = position
            spriteComponent.node.zPosition = zPosition
            spriteComponent.node.name = nodeName
            spriteComponent.node.alpha = alpha
            
            if nodeName.contains("filament") {
                filamentScale *= -1
                spriteComponent.node.xScale = filamentScale
            }
            
        }
        
        entityManager.add(entity)
    }
    
    func buildMap() {
        let tilesetReferences = [CGPoint(x: frame.midX-280, y: frame.midY+170),CGPoint(x: frame.midX+101.5, y: frame.midY-28),CGPoint(x: frame.midX+393, y: frame.midY+155),CGPoint(x: frame.midX+741, y: frame.midY-59)]
        
        let filamentReferences = [CGPoint(x: frame.midX-69, y: frame.midY+16),CGPoint(x: frame.midX+278, y: frame.midY+16), CGPoint(x: frame.midX+602, y: frame.midY+2)]
        
        
        //drawn stage 1
        drawnMaps(height: 3, width: 5, tilesetReference: tilesetReferences[0], status: "available", showRobot:true)
        //drawn filament
        addEntity(entity: Filament(status: "unavailable"), nodeName: "filament-unavailable", position: filamentReferences[0], zPosition: 2, alpha: 0.35)
        
        //drawn stage 2
        drawnMaps(height: 5, width: 5, tilesetReference: tilesetReferences[1], status: "unavailable", showRobot:false)

        //drawn filament
        addEntity(entity: Filament(status: "unavailable"), nodeName: "filament-unavailable", position: filamentReferences[1], zPosition: 2, alpha: 0.35)
        
        //drawn stage 3
        drawnMaps(height: 3, width: 5, tilesetReference: tilesetReferences[2], status: "unavailable", showRobot:false)
        //drawn filament
        addEntity(entity: Filament(status: "unavailable"), nodeName: "filament-unavailable", position: filamentReferences[2], zPosition: 2, alpha: 0.35)
        
        //drawn stage 4
        drawnMaps(height: 3, width: 5, tilesetReference: tilesetReferences[3], status: "unavailable", showRobot:false)
        
        

    }
    
    func moveMap(direction: Direction) {
        for item in map {
            self.enumerateChildNodes(withName: item, using: ({
                (node,error) in
                if direction == Direction.backward {
                    node.position.x += 5
                } else {
                    node.position.x -= 5
                }
            }))
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            touchesBeganLocation = location
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if locationAnterior.x < location.x {
                if self.posicao > 0 {
                    moveMap(direction: Direction.backward)
                    self.posicao -= 1
                }
            } else {
                if self.posicao < 105 {
                    moveMap(direction: Direction.forward)
                    self.posicao += 1
                }
            }
            locationAnterior = location
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if location == touchesBeganLocation {
                let nodes = self.nodes(at: location)
                if nodes[0].name?.contains("stage-available") ?? false {
                    let gameScene = GameScene(size: view!.bounds.size)
                    view!.presentScene(gameScene)
                }
                if nodes[0].name?.contains("config-button") ?? false {
                    let configScene = ConfigScene(size: view!.bounds.size)
                    configScene.userData = configScene.userData ?? NSMutableDictionary()
                    configScene.userData!["backSaved"] = backName
                    view!.presentScene(configScene)
                }
            }
        }
        
    }
    
}

