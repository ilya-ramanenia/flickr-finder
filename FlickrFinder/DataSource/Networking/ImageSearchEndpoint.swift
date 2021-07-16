//
//  ImageSearchEndpoint.swift
//  FlickrFinder
//
//  Created by ilya Ramanenia on 19.07.21.
//

import Foundation

/// Example
/// https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=_&format=json&nojsoncallback=1&text=kittens

struct ImageSearchEndpoint: ModelEndpoint {
    typealias Model = ImageSearchResult
    
    var apiKey: String
    var searchQuery: String
    var page: Int
    let perPage: Int = Config().imagesPerPage
}

extension ImageSearchEndpoint: Endpoint {
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.flickr.com"
        components.path = "/services/rest/"
        components.queryItems = [
            .init(name: "method", value: "flickr.photos.search"),
            .init(name: "api_key", value: apiKey),
            .init(name: "format", value: "json"),
            .init(name: "nojsoncallback", value: "1"),
            .init(name: "text", value: searchQuery),
            .init(name: "page", value: String(page)),
            .init(name: "per_page", value: String(perPage))]

        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }

        return url
    }
}
