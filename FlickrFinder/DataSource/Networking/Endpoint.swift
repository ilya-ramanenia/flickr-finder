//
//  Endpoint.swift
//  FlickrFinder
//
//  Created by ilya Ramanenia on 19.07.21.
//

import Foundation

protocol Endpoint {
    var url: URL { get }
}

protocol ModelEndpoint: Endpoint {
    associatedtype Model: Decodable
}
