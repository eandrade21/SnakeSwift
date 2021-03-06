//
//  PlayerMock.swift
//  VelovedGame
//
//  Created by eandrade21 on 3/15/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

class PlayerMock: Player {

    convenience init() {
        self.init(locations: [StageLocation(x: 0, y: 0)], direction: Direction.randomDirection())
    }
    
    override init(locations: [StageLocation], direction: Direction) {
        super.init(locations: locations, direction: direction)
    }

    required internal init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}