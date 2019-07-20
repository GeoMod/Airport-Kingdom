//
//  CollisionTypes.swift
//  Airport Kingdom
//
//  Created by Daniel O'Leary on 6/19/19.
//  Copyright © 2019 Impulse Coupled Dev. All rights reserved.
//

import Foundation

enum CollisionTypes: UInt32 {
    case airplane = 1
    case runwayEdge = 2
    case tower = 4 // Unused
    case runwaysurface = 8
    case liveTree = 16
    case deadTree = 32
}
