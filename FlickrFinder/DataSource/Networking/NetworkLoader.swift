//
//  NetworkLoader.swift
//  FlickrFinder
//
//  Created by ilya Ramanenia on 17.07.21.
//

import Foundation
import UIKit.UIImage

struct NetworkResponse<Wrapped: Decodable>: Decodable {
    
    var result: Wrapped
}

/// Uses shared system URL session

struct NetworkLoader {
    
    var urlSession: URLSession = .shared
    var processingQueue: DispatchQueue = .global(qos: .userInitiated)
    var completionQueue: DispatchQueue = .main
    
    func loadJSONModel<E: ModelEndpoint>(modelEndpoint: E, completion: @escaping ((E.Model?, Error?) -> Void)) -> Void {
        processingQueue.async {
            let task = urlSession.dataTask(with: modelEndpoint.url) { data, response, error in
                if let error = error {
                    networkLog("\(#function): " + error.localizedDescription)
                }
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    networkLog(responseString)
                }
                
                completionQueue.async {
                    guard let data = data, let response = try? JSONDecoder().decode(E.Model.self, from: data) else {
                        completion(nil, error)
                        return
                    }
                    
                    completion(response, nil)
                }
            }

            task.resume()
        }
    }
    
    func loadImage(endpoint: Endpoint, completion: @escaping ((UIImage?, Error?) -> Void)) -> Void {
        processingQueue.async {
            let requestWithCache = URLRequest(url: endpoint.url,
                                              cachePolicy: .returnCacheDataElseLoad,
                                              timeoutInterval: Config().imageLoadTimeout)
            let task = urlSession.dataTask(with: requestWithCache) { data, response, error in
                if let error = error {
                    networkLog("\(#function): " + error.localizedDescription)
                }
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    networkLog(responseString)
                }
                
                completionQueue.async {
                    guard let data = data, let responseImage = UIImage(data: data) else {
                        completion(nil, error)
                        return
                    }
                    
                    completion(responseImage, nil)
                }
            }
            
            task.resume()
        }
    }
}

private extension NetworkLoader {
    
    func networkLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
//        Disabled
//        log("Network: " + items)
    }
}
