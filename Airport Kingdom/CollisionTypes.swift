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
    case runwaysurface = 6
    case tree = 12
}
