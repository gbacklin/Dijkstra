//
//  ViewController.swift
//  TestDijkstra
//
//  Created by Gene Backlin on 10/13/19.
//  Copyright © 2019 Gene Backlin. All rights reserved.
//

import UIKit
import Dijkstra

let DATA_QUERY = "http://www.ehmz.org/dijkstra/dijkstra.php"
let VERTEX_QUERY = "http://www.ehmz.org/dijkstra/vertex.php"

class ViewController: UIViewController {
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!

    var verticies: [RouteVertex] = [RouteVertex]()
    var vertexRoutes: [Route] = [Route]()
    var searchResult: [String] = [String]()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - REST data fetch

    func fetchVerticies() {
        Network.sharedInstance.get(url: VERTEX_QUERY) { [weak self] (responseData, error) in
            if error != nil {
                self!.handleError(error: error!)
            } else {
                //let str = String(decoding: responseData!, as: UTF8.self)
                let decoder = JSONDecoder()
                do {
                    let verticies = try decoder.decode([RouteVertex].self, from: responseData!)
                    self!.verticies = verticies
                    self!.fetchData()
                } catch {
                    self!.handleError(error: error)
                }
            }
        }
    }
    
    func fetchData() {
        Network.sharedInstance.get(url: DATA_QUERY) { [weak self] (responseData, error) in
            if error != nil {
                self!.handleError(error: error!)
            } else {
                let decoder = JSONDecoder()
                do {
                    let routes = try decoder.decode([Route].self, from: responseData!)
                    DispatchQueue.main.async {
                        self!.vertexRoutes = routes
                        self!.searchResult = self!.analyzeRoutes(routeArray: routes, from: self!.fromLabel.text!, to: self!.toLabel.text!)
                        self!.tableView.reloadData()
                    }
                } catch {
                    self!.handleError(error: error)
                }
            }
        }
    }
    
    // MARK: - Route analysis
    
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
            
            textView.text = graph.description as? String

            if let edges = graph.dijkstra(from: dict[from]!, to: dict[to]!) {
                for edge in edges {
                    result.append("\(edge.source) -> \(edge.destination)")
                }
            }
        }
        return result
    }
    
    // MARK: - @IBAction methods

    @IBAction func beginAnalyzing(_ sender: Any) {
        textView.text = ""
        fetchVerticies()
    }
    
    // MARK: - Utility methods

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

// MARK: - Error Utility methods

extension ViewController {
    
    func handleError(error: Error) {
        let errorMessage = error.localizedDescription
        
        let alert: UIAlertController = UIAlertController(title: NSLocalizedString("Cannot complete the process", comment: ""), message: errorMessage, preferredStyle: .actionSheet)
        let OKAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { (action) in
        }
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }

    func createError(domain: String, code: Int, text: String) -> Error {
        let userInfo: [String : String] = [NSLocalizedDescriptionKey: text]
        
        return NSError(domain: domain, code: code, userInfo: userInfo)
    }
    
}

// MARK: - Table View DataSource

extension ViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let path: String = searchResult[indexPath.row]
        cell.textLabel!.text = path
        
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var titleText = ""
        if searchResult.count > 0 {
            titleText = "Shortest Path"
        }
        return titleText
    }
}
