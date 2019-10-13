//
//  TestDijkstraTests.swift
//  TestDijkstraTests
//
//  Created by Gene Backlin on 10/13/19.
//  Copyright © 2019 Gene Backlin. All rights reserved.
//

import XCTest
import Dijkstra

let DATA_QUERY = "http://www.ehmz.org/dijkstra/dijkstra.php"
let VERTEX_QUERY = "http://www.ehmz.org/dijkstra/vertex.php"

class TestDijkstraTests: XCTestCase {
    var verticies: [RouteVertex] = [RouteVertex]()
    var vertexRoutes: [Route] = [Route]()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchVerticies() {
        // This is an example of a performance test case.
        measure {
            fetchVerticies(withData: false)
        }
    }

    func testFetchData() {
        measure {
            fetchVerticies(withData: true)
        }
    }

}

extension TestDijkstraTests {
    
    func fetchVerticies(withData: Bool) {
        let fetchExpectation = expectation(description: "GET \(DATA_QUERY)")

        Network.sharedInstance.get(url: VERTEX_QUERY) { [weak self] (responseData, error) in
            if error != nil {
                debugPrint("Error: \(error!.localizedDescription)")
            } else {
                //let str = String(decoding: responseData!, as: UTF8.self)
                let decoder = JSONDecoder()
                do {
                    let verticies = try decoder.decode([RouteVertex].self, from: responseData!)
                    XCTAssertEqual(verticies.count, 5, "Expected count of 5 was \(verticies.count)")
                    self!.verticies = verticies
                    if withData {
                        self!.fetchData()
                    }
                } catch {
                    debugPrint("Error: \(error.localizedDescription)")
                }
            }
            fetchExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3.0) { error in
            if let error = error {
                debugPrint("Error: \(error.localizedDescription)")
            }
        }
    }

    func fetchData() {
        Network.sharedInstance.get(url: DATA_QUERY) { [weak self] (responseData, error) in
            if error != nil {
                debugPrint("Error: \(error!.localizedDescription)")
            } else {
                let decoder = JSONDecoder()
                do {
                    let routes = try decoder.decode([Route].self, from: responseData!)
                    self!.vertexRoutes = routes
                    XCTAssertEqual(self!.vertexRoutes.count, 5, "Expected count of 3 was \(self!.vertexRoutes.count)")
                    let result: [String] = self!.analyzeRoutes(routeArray: routes, from: "Entrance", to: "Treasure")
                    XCTAssertEqual(result.count, 3, "Expected count of 3 was \(result.count)")
                } catch {
                    debugPrint("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    func analyzeRoutes(routeArray: [Route], from: String, to: String) -> [String] {
        let graph = AdjacencyList<String>()
        var result: [String] = [String]()

        if let dict: [String : Vertex<String>] = createVertexDictionary(list: graph) {
            for route: Route in routeArray {
                let graphType: EdgeType = route.graphType == "undirected" ? .undirected : .directed
                let vertexFrom: Vertex<String> = dict[route.vertexFrom]!
                let vertexTo: Vertex<String> = dict[route.vertexTo]!
                let weight: Double = Double(route.weight)!
                
                graph.add(graphType, from: vertexFrom, to: vertexTo, weight: weight)
            }
            
            if let edges = graph.dijkstra(from: dict[from]!, to: dict[to]!) {
                for edge in edges {
                    result.append("\(edge.source) -> \(edge.destination)")
                }
            }
        }
        return result
    }

    func createVertexDictionary(list: AdjacencyList<String>) -> [String : Vertex<String>]? {
        var dictionary: [String : Vertex<String>]?

        if verticies.count > 0 {
            dictionary = [String : Vertex<String>]()
            for vertex: RouteVertex in verticies {
                dictionary![vertex.type] = list.createVertex(data: vertex.type)
            }
        }
        return dictionary
    }

}
