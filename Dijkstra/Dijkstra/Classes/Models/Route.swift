//
//  Route.swift
//  Dijkstra
//
//  Created by Gene Backlin on 10/12/19.
//  Copyright © 2019 Gene Backlin. All rights reserved.
//

import Foundation

public struct Route: Codable {
    public var id: String
    public var graphType: String
    public var vertexFrom: String
    public var vertexTo: String
    public var weight: String
}
