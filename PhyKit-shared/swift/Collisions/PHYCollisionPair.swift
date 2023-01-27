//
//  PHYCollisionPair.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-11.
//  Copyright © 2020 adam. All rights reserved.
//

/*
 THIS IS AN ALTERED VERSION OF THE ORIGINAL SOURCE AND IS NOT THE ORIGINAL SOFTWARE.
 */

import Foundation

/// Represents a pair of rigid bodies that have collided in the simulation
public class PHYCollisionPair {
    
    /// The first rigid body that has collided
    public weak var rigidBodyA: PHYRigidBody?
    
    /// The position, local to the first rigid body's transform, that the collision occured
    public let localPositionA: PHYVector3
    
    /// The second rigid body that has collided
    public weak var rigidBodyB: PHYRigidBody?
    
    /// The position, local to the second rigid body's transform, that the collision occured
    public let localPositionB: PHYVector3
    
    /// This normal points from B towards A, and is defined in world space.
    public let worldNormalB: PHYVector3
    
    public init(rigidBodyA: PHYRigidBody, localPositionA: PHYVector3, rigidBodyB: PHYRigidBody, localPositionB: PHYVector3, worldNormalB: PHYVector3) {
        self.rigidBodyA = rigidBodyA
        self.localPositionA = localPositionA
        self.rigidBodyB = rigidBodyB
        self.localPositionB = localPositionB
        self.worldNormalB = worldNormalB
    }
}
