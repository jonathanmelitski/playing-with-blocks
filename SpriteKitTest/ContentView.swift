//
//  ContentView.swift
//  SpriteKitTest
//
//  Created by Jonathan Melitski on 12/30/24.
//

import SwiftUI
import SpriteKit
import Foundation
import CoreMotion

class Game: SKScene {
    
    let motionManager = CMMotionManager()
    
    func onStart() {
        removeAllChildren()
    
        let redShades: [UIColor] = [
            UIColor(red: 1.0, green: 0.6, blue: 0.6, alpha: 1.0), // Soft Coral
            UIColor(red: 1.0, green: 0.4, blue: 0.4, alpha: 1.0), // Pastel Red
            UIColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0), // Bright Red
            UIColor(red: 0.8, green: 0.0, blue: 0.0, alpha: 1.0), // Crimson
            UIColor(red: 0.6, green: 0.0, blue: 0.0, alpha: 1.0), // Ruby
            UIColor(red: 0.4, green: 0.0, blue: 0.0, alpha: 1.0)  // Deep Maroon
        ]

        
        for _ in 1..<75 {
            let box = SKSpriteNode(color: redShades.randomElement()!, size: CGSize(width: 10, height: 10))
            box.position = CGPoint(x: Double.random(in: 0..<frame.width), y: Double.random(in: 0..<frame.height))
            box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 10))
            addChild(box)
        }
        
        motionManager.deviceMotionUpdateInterval = 1 / 60
        motionManager.startDeviceMotionUpdates(to: .main) { pos, error in
         if let pos {
             let attitude = pos.attitude
             self.physicsWorld.gravity = CGVector(dx: attitude.roll * 25, dy: attitude.pitch * -25)
         } else if let error {
             exit(1)
            }
        }
    }
    
    override func didMove(to view: SKView) {
        let start = StartButton(onStart: onStart)
        
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: UIScreen.main.bounds)
        self.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        addChild(start)
        
    }
}

class StartButton: SKNode {
    let onStart: () -> Void
    
    required init(onStart: @escaping () -> Void) {
        self.onStart = onStart
        super.init()
        let bg = SKShapeNode(rectOf: CGSize(width: 100, height: 100), cornerRadius: 5)
        bg.scene?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        bg.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        bg.fillColor = .blue
        bg.addChild(SKLabelNode(text: "Start"))
        addChild(bg)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        onStart()
    }
    
    
}

struct ContentView: View {
    var body: some View {
        ZStack {
            SpriteView(scene: Game())
                .ignoresSafeArea()
        }
    }
}
