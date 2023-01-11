//
//  PHYGeometry+ARKit.swift
//  PhyKit
//
//  Created by Grant Jarvis on 1/4/23.
//

/*
 THIS IS AN ALTERED VERSION OF THE ORIGINAL SOURCE AND IS NOT THE ORIGINAL SOFTWARE.
 */

import Foundation
import ARKit

public extension PHYGeometry {

    @available(iOS 13.4, *)
    internal static func getGeometry(_ meshAnchor: ARMeshAnchor) -> CPHYGeometry {
        
        let vertexPositions = Self.getVertexPositions(meshAnchor.geometry)
        
        
        let polygons = Self.getPolygons(meshAnchor.geometry, vertexPositions: vertexPositions)
        let mesh = CPHYMesh(polygons: polygons)
        
        let internalGeometry = CPHYGeometry(meshs: [mesh])
        return internalGeometry
    }
    
    @available(iOS 13.4, *)
    private static func getPolygons(_ geometry: ARMeshGeometry, vertexPositions: [PHYVector3]) -> [CPHYPolygon] {
        
        var polygons: [CPHYPolygon] = []
        
        for i in 0..<geometry.faces.count {
            
            let vertexIndices = geometry.vertexIndicesOf(faceWithIndex: i)
            
            let v1 = CPHYVertex(position: vertexPositions[Int(vertexIndices[0])])
            let v2 = CPHYVertex(position: vertexPositions[Int(vertexIndices[1])])
            let v3 = CPHYVertex(position: vertexPositions[Int(vertexIndices[2])])
            
            let polygon = CPHYPolygon(vertices: [v1, v2, v3])
            
            polygons.append(polygon)
            
        }
            
            return polygons
            
        }
        
    @available(iOS 13.4, *)
        private static func getVertexPositions(_ geometry: ARMeshGeometry) -> [PHYVector3] {
            assert(geometry.vertices.format == MTLVertexFormat.float3, "Expected three floats (twelve bytes) per vertex.")
            
            let source = geometry.vertices
            
            let vectors = [SCNVector3](repeating: SCNVector3Zero, count: source.count)
            let vertices = vectors.enumerated().map({ (index: Int, element: SCNVector3) -> PHYVector3 in
                
                let vertexPointer = source.buffer.contents().advanced(by: source.offset + (source.stride * Int(index)))
                let vertex = vertexPointer.assumingMemoryBound(to: (Float, Float, Float).self).pointee
                return PHYVector3(vertex.0, vertex.1, vertex.2)
                
            })
            return vertices
        }
}


    /*
     Copyright © 2020 Apple Inc.

     Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

     The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
     */

@available(iOS 13.4, *)
    extension ARMeshGeometry {
        func vertex(at index: UInt32) -> (Float, Float, Float) {
            assert(vertices.format == MTLVertexFormat.float3, "Expected three floats (twelve bytes) per vertex.")
            let vertexPointer = vertices.buffer.contents().advanced(by: vertices.offset + (vertices.stride * Int(index)))
            let vertex = vertexPointer.assumingMemoryBound(to: (Float, Float, Float).self).pointee
            return vertex
        }
        
        func vertexIndicesOf(faceWithIndex faceIndex: Int) -> [UInt32] {
            assert(faces.bytesPerIndex == MemoryLayout<UInt32>.size, "Expected one UInt32 (four bytes) per vertex index")
            let vertexCountPerFace = faces.indexCountPerPrimitive
            let vertexIndicesPointer = faces.buffer.contents()
            var vertexIndices = [UInt32]()
            vertexIndices.reserveCapacity(vertexCountPerFace)
            for vertexOffset in 0..<vertexCountPerFace {
                let vertexIndexPointer = vertexIndicesPointer.advanced(by: (faceIndex * vertexCountPerFace + vertexOffset) * MemoryLayout<UInt32>.size)
                vertexIndices.append(vertexIndexPointer.assumingMemoryBound(to: UInt32.self).pointee)
            }
            return vertexIndices
        }
        
        func verticesOf(faceWithIndex index: Int) -> [(Float, Float, Float)] {
            let vertexIndices = vertexIndicesOf(faceWithIndex: index)
            let vertices = vertexIndices.map { vertex(at: $0) }
            return vertices
        }
    }
