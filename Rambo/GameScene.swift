//
//  GameScene.swift
//  Rambo
//
//  Created by Jose Eduardo Quintero Gutierrez on 28/10/16.
//  Copyright © 2016 Jose Eduardo Quintero Gutierrez. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameController

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    var ground: SKSpriteNode!

    
    var left_key: Bool = false
    var right_key: Bool = false
    var up_key: Bool = false
    var down_key: Bool = false
    
    var gun_direction: UInt16!
    var shooting: Bool = false
    
    let velocity: CGFloat = 300.0
    
    var bullets_array: [SKSpriteNode] = [SKSpriteNode]()
    
    var scene_camera: SKCameraNode!
    var scene_width: CGFloat!
    var scene_height: CGFloat!
    
    enum body_type: UInt32{
        case bullet = 1
        case ground = 2
        case another_body = 4
        case player = 8
    }
    
    override func didMove(to view: SKView) {
        
        setUpControllerObservers()
        connectControllers()
        
      
        //let ground = self.childNode(withName: "ground") as! SKSpriteNode
        enumerateChildNodes(withName: "ground*"){ node, stop in
            node.physicsBody?.restitution = 0.0
            node.physicsBody?.categoryBitMask = body_type.ground.rawValue | body_type.ground.rawValue
            node.physicsBody?.contactTestBitMask = body_type.ground.rawValue
            node.physicsBody?.collisionBitMask = body_type.ground.rawValue
        }
        
        player = self.childNode(withName: "player") as! SKSpriteNode
        player.physicsBody?.categoryBitMask = 0
        player.physicsBody?.contactTestBitMask = 0
        player.physicsBody?.collisionBitMask = body_type.ground.rawValue
        player.physicsBody?.isDynamic = true
        player.physicsBody?.friction = 0
        player.physicsBody?.restitution = 0.0
        player.physicsBody?.angularVelocity = 0.0
        player.physicsBody?.linearDamping = 8
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        scene_camera = self.childNode(withName: "camera") as! SKCameraNode
        scene_width = self.size.width / 2
        scene_height = self.size.width / 2
        
        self.camera = scene_camera
        
        

        
        self.physicsWorld.contactDelegate = self
    }
    
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {
   
    }
    
    func touchUp(atPoint pos : CGPoint) {
   
    }
    
    override func mouseDown(with event: NSEvent) {

    }
    
    override func mouseDragged(with event: NSEvent) {

    }
    
    override func mouseUp(with event: NSEvent) {

    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0:
            left_key = true
        case 1:
            down_key = true
        case 2:
            right_key = true
        case 13:
            up_key = true
        case 123, 124, 125, 126:
            gun_direction = event.keyCode
            shooting = true
        default:
            print("Nada")
        }
    }
    override func keyUp(with event: NSEvent) {
        switch event.keyCode {
        case 0:
            left_key = false
        case 1:
            down_key = false
        case 2:
            right_key = false
        case 13:
            up_key = false
        case 123, 124, 125, 126:
            shooting = false
        default:
            print("Nada \(event.keyCode)")
        }
    }
    func shoot(){
        let bullet: SKSpriteNode = SKSpriteNode(color: .red, size: CGSize(width: 10, height: 10))
        bullet.name = "bullet"
        bullet.physicsBody = SKPhysicsBody(bodies: [SKPhysicsBody.init(rectangleOf: bullet.size)])
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.categoryBitMask = body_type.another_body.rawValue
        bullet.physicsBody?.contactTestBitMask = body_type.ground.rawValue
        bullet.physicsBody?.collisionBitMask = body_type.ground.rawValue | body_type.another_body.rawValue
        bullet.physicsBody?.restitution = 0.005
        bullet.physicsBody?.affectedByGravity = false
        
        bullet.zPosition = 0
        
        bullet.position = player.position
        self.addChild(bullet)
        //bullets_array.append(bullet)
        
        let random = CGFloat(arc4random_uniform(40))
        
        let bullet_destination = CGPoint(x: random, y: self.frame.size.height + bullet.frame.size.height / 2)
        
        if(gun_direction == 123){
            print("123")
            bullet.physicsBody?.velocity = CGVector(dx: -1000, dy: random)
        }
        if(gun_direction == 125){
            print("124")
            bullet.physicsBody?.velocity = CGVector(dx: random, dy: -1000)
        }
        if(gun_direction == 124){
            print("125")
            bullet.physicsBody?.velocity = CGVector(dx: 1000, dy: random)
        }
        if(gun_direction == 126){
            bullet.physicsBody?.velocity = CGVector(dx: random, dy: 1000)
        }
       //let bullet_action = SKAction.moveBy(x: bullet_destination.x, y: bullet_destination.y, duration: 1)

        
        /*bullet.run(bullet_action, completion: {() -> Void in
            bullet.physicsBody?.categoryBitMask = 0
            bullet.physicsBody?.contactTestBitMask = 0
            bullet.physicsBody?.collisionBitMask = 0
            bullet.physicsBody = nil
          //self.removeChildren(in: [bullet])
        })*/
        
    }
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.contactTestBitMask == body_type.ground.rawValue {
            var bullet = contact.bodyB.node as! SKSpriteNode
            bullet.physicsBody?.categoryBitMask = 0
            bullet.color = .blue
            bullet.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.01)
            bullet.physicsBody?.angularVelocity = 0.0
            bullet.physicsBody?.linearDamping = 5.0
            bullet.physicsBody?.allowsRotation = false
        }
       /* if contact.bodyA.node?.name == contact.bodyB.node?.name{
            //self.removeChildren(in: [contact.bodyA.node!, contact.bodyB.node!])
            var bullet = contact.bodyA.node
            var bullet2 = contact.bodyB.node
            
            bullet?.physicsBody?.restitution = 0.0
            bullet2?.physicsBody?.restitution = 0.0
            bullet?.physicsBody?.friction = 0.0
            
            bullet?.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
            bullet2?.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)


            bullet2?.physicsBody = nil
            bullet?.physicsBody = nil

            //bullet?.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
            //bullet?.physicsBody?.categoryBitMask = 0
            //bullet?.physicsBody?.contactTestBitMask = 0
            //bullet?.physicsBody?.collisionBitMask = 0
            //bullet?.physicsBody = nil

        }*/
        /*if contact.bodyA.node?.name == "ground" {
            var bullet = contact.bodyB.node
            self.removeChildren(in: [bullet!])
        }*/
        
        /*if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
            var bullet = contact.bodyA.node
            bullet?.physicsBody?.restitution = 0.0
            //bullet?.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
            bullet?.physicsBody?.categoryBitMask = 0
            bullet?.physicsBody?.contactTestBitMask = 0
            bullet?.physicsBody?.collisionBitMask = 0
            bullet?.physicsBody = nil
            
        }*/
        
    }
    override func didSimulatePhysics() {
        //print("SImulando")
    }
    override func update(_ currentTime: TimeInterval) {
        if left_key == true{
            player.physicsBody?.velocity = CGVector(dx: -velocity, dy: (player.physicsBody?.velocity.dy)!)
            //player.position.x -= velocity
        }
        if up_key == true{
            player.physicsBody?.velocity = CGVector(dx: (player.physicsBody?.velocity.dx)!, dy: velocity)
            //player.position.y += velocity
        }
        if right_key == true{
            player.physicsBody?.velocity = CGVector(dx: velocity, dy: (player.physicsBody?.velocity.dy)!)
            //player.position.x += velocity
        }
        if down_key == true{
            player.physicsBody?.velocity = CGVector(dx: (player.physicsBody?.velocity.dx)!, dy: -velocity)
            //player.position.y -= velocity
        }
        if(shooting == true){
            shoot()
        }
        
        enumerateChildNodes(withName: "bullet*"){ node, stop in
            let bullet = node as! SKSpriteNode
            if (bullet.physicsBody?.isResting)! {
                bullet.name = "gone_bullet"
                bullet.physicsBody?.categoryBitMask = 0
                bullet.physicsBody?.contactTestBitMask = 0
                bullet.physicsBody?.collisionBitMask = 0
                bullet.physicsBody = nil
            }
            print("POSICION X \(self.player.position.x)   SCENE WIDTH \(self.scene_width!)")
            if(bullet.position.x < (self.scene_camera.position.x - self.scene_width! ) || bullet.position.x > (self.scene_camera.position.x + self.scene_width!) || bullet.position.y < (self.scene_camera.position.y - self.scene_height) || bullet.position.y > (self.scene_camera.position.y + self.scene_height)){
                self.removeChildren(in: [bullet])
            }
            
            
        }
        
        scene_camera.position.x -= (scene_camera.position.x - player.position.x)/5
        scene_camera.position.y -= (scene_camera.position.y - player.position.y)/5
        
        
    
       

    }
    
    
    func connectControllers(){
        print("no")
        for controller in GCController.controllers() {
            print("ncontrado")
            if (controller.extendedGamepad != nil ) {
                controller.extendedGamepad?.valueChangedHandler = nil
                print("Hardcore")
                setUpExtendedController (controller: controller)
            }  else if (controller.gamepad != nil ) {
                print("No hardcore")

                controller.gamepad?.valueChangedHandler = nil
                setUpStandardController (controller: controller)
            }
        }
    }
    func setUpStandardController( controller:GCController) {
        controller.gamepad?.valueChangedHandler = {
            (gamepad: GCGamepad, element:GCControllerElement) in
            if (gamepad.controller?.playerIndex == .index1) {
                // this is player 1 playing the controller
            } else if (gamepad.controller?.playerIndex == .index2) {
                // this is player 1 playing the controller
            }
            
            print(gamepad)
            if (gamepad.dpad == element) {
                
                if (gamepad.dpad.right.isPressed == true){
                    print("pressed dpad right")
                } else if (gamepad.dpad.right.isPressed == false){
                    print("let go of dpad right")
                }
                if (gamepad.dpad.left.isPressed == true){
                    print("pressed dpad left")
                } else if (gamepad.dpad.left.isPressed == false){
                    print("let go of dpad left")
                }
            } else if (gamepad.leftShoulder == element){
                if ( gamepad.leftShoulder.isPressed == true){
                    print("leftShoulder pressed")
                } else if ( gamepad.leftShoulder.isPressed == false) {
                    print("leftShoulder released")
                }
            }
            else if (gamepad.rightShoulder == element){
                if ( gamepad.rightShoulder.isPressed == true){
                    print("rightShoulder pressed")
                } else if ( gamepad.leftShoulder.isPressed == false) {
                    print("rightShoulder released")
                }
            }

            else if ( gamepad.buttonA == element) {
                if ( gamepad.buttonA.isPressed == true){
                    print("buttonA pressed")
                } else if ( gamepad.buttonA.isPressed == false) {
                    print("buttonA released")
                }
            } else if ( gamepad.buttonY == element) {
                if ( gamepad.buttonY.isPressed == true){
                    print("buttonY pressed")
                } else if ( gamepad.buttonY.isPressed == false) {
                    print("buttonY released")
                }
            } else if ( gamepad.buttonB == element) {
                if ( gamepad.buttonB.isPressed == true){
                    print("buttonB pressed")
                } else if ( gamepad.buttonB.isPressed == false) {
                    print("buttonB released")
                }
            } else if ( gamepad.buttonX == element) {
                if ( gamepad.buttonX.isPressed == true){
                    print("buttonX pressed")
                } else if ( gamepad.buttonX.isPressed == false) {
                    print("buttonX released")
                }
            }
        }
    }
    
    func setUpExtendedController( controller:GCController) {
        controller.extendedGamepad?.valueChangedHandler = {
            (gamepad: GCExtendedGamepad, element:GCControllerElement) in
            if (gamepad.controller?.playerIndex == .index1) {
                // this is player 1 playing the controller
            } else if (gamepad.controller?.playerIndex == .index2) {
                // this is player 1 playing the controller
            }
            
            if (gamepad.leftThumbstick == element) {
                if (gamepad.leftThumbstick.left.value > 0.2) {
                    print("pressed leftThumbstick left")
                } else if (gamepad.leftThumbstick.left.isPressed == false) {
                    print ("left go of leftThumbstick left")
                }
            } else if (gamepad.rightThumbstick == element) {
                if (gamepad.rightThumbstick.right.value > 0.2) {
                    print("pressed rightThumbstick right")
                } else if (gamepad.rightThumbstick.right.isPressed == false) {
                    print ("left go of rightThumbstick right")
                }
            } else if (gamepad.dpad == element) {
                if (gamepad.dpad.right.isPressed == true){
                    print("pressed dpad right")
                } else if (gamepad.dpad.right.isPressed == false){
                    print("let go of dpad right")
                }
                if (gamepad.dpad.left.isPressed == true){
                    print("pressed dpad left")
                } else if (gamepad.dpad.left.isPressed == false){
                    print("let go of dpad left")
                }
            } else if (gamepad.leftShoulder == element){
                if ( gamepad.leftShoulder.isPressed == true){
                    print("leftShoulder pressed")
                } else if ( gamepad.leftShoulder.isPressed == false) {
                    print("leftShoulder released")
                }
            }
            else if (gamepad.leftTrigger == element){
                if ( gamepad.leftTrigger.isPressed == true){
                    print("leftTrigger pressed")
                } else if ( gamepad.leftTrigger.isPressed == false) {
                    print("leftTrigger released")
                }
            }
            else if (gamepad.rightShoulder == element){
                if ( gamepad.rightShoulder.isPressed == true){
                    print("rightShoulder pressed")
                } else if ( gamepad.rightShoulder.isPressed == false) {
                    print("rightShoulder released")
                }
            }
            else if (gamepad.rightTrigger == element){
                if ( gamepad.rightTrigger.isPressed == true){
                    print("rightTrigger pressed")
                } else if ( gamepad.rightTrigger.isPressed == false) {
                    print("rightTrigger released")
                }
            } else if ( gamepad.buttonA == element) {
                if ( gamepad.buttonA.isPressed == true){
                    print("buttonA pressed")
                } else if ( gamepad.buttonA.isPressed == false) {
                    print("buttonA released")
                }
            } else if ( gamepad.buttonY == element) {
                if ( gamepad.buttonY.isPressed == true){
                    print("buttonY pressed")
                } else if ( gamepad.buttonY.isPressed == false) {
                    print("buttonY released")
                }
            } else if ( gamepad.buttonB == element) {
                if ( gamepad.buttonB.isPressed == true){
                    print("buttonB pressed")
                } else if ( gamepad.buttonB.isPressed == false) {
                    print("buttonB released")
                }
            } else if ( gamepad.buttonX == element) {
                if ( gamepad.buttonX.isPressed == true){
                    print("buttonX pressed")
                } else if ( gamepad.buttonX.isPressed == false) {
                    print("buttonX released")
                }
            }
        }
    }
}
