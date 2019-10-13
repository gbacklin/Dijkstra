//
//  Network.swift
//  Dijkstra
//
//  Created by Gene Backlin on 10/12/19.
//  Copyright © 2019 Gene Backlin. All rights reserved.
//

import UIKit

public class Network: NSObject {
    public static let sharedInstance = Network()
    
    public func get(url: String, completion: @escaping (_ json: Data?, _ error: NSError?) -> Void) {
        let request: URLRequest = URLRequest(url: URL(string: url)!)
        let sessionTask: URLSessionDataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // in case we want to know the response status code
            // let HTTPStatusCode = (response as! HTTPURLResponse).statusCode
            if error != nil {
                OperationQueue.main.addOperation({
                    if (error! as NSError).code == NSURLErrorAppTransportSecurityRequiresSecureConnection {
                        // if you get error NSURLErrorAppTransportSecurityRequiresSecureConnection (-1022),
                        // then your Info.plist has not been properly configured to match the target server.
                        //
                        completion(nil, error as NSError?)
                    } else {
                        completion(nil, error as NSError?)
                    }
                })
            } else {
                completion(data, nil)
            }
        }
        sessionTask.resume()
    }

}

