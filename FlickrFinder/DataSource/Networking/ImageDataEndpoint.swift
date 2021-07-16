//
//  ImageDataEndpoint.swift
//  FlickrFinder
//
//  Created by ilya Ramanenia on 19.07.21.
//

import Foundation

/// Example
/// http://farm1.static.flickr.com/578/23451156376_8983a8ebc7.jpg

struct ImageDataEndpoint {
    
    var id: String
    var farm: Int
    var server: String
    var secret: String
}

extension ImageDataEndpoint: Endpoint {
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "farm\(farm).static.flickr.com"
        components.path = "/\(server)/\(id)_\(secret).jpg"

        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }

        return url
    }
}
