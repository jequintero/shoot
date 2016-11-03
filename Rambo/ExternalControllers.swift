//
//  ExternalControllers.swift
//  Rambo
//
//  Created by Jose Eduardo Quintero Gutierrez on 31/10/16.
//  Copyright © 2016 Jose Eduardo Quintero Gutierrez. All rights reserved.
//

import Foundation
import SpriteKit
import GameController

extension GameScene{
    func setUpControllerObservers(){
        NotificationCenter.default.addObserver(self, selector: Selector(("connectControllers")), name: NSNotification.Name.GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: Selector(("controllerDisconnected")), name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
    }
}
