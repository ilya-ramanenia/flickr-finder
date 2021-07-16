//
//  ImageSearchResult.swift
//  FlickrFinder
//
//  Created by ilya Ramanenia on 19.07.21.
//

import Foundation

struct ImageSearchResult: Codable {
    var photos: ImageSearchResultPhotos
    var stat: String
}

struct ImageSearchResultPhotos: Codable {
    var page: Int
    var pages: Int
    var perpage: Int
    var total: Int
    var photo: [ImageSearchResultItem]
}

struct ImageSearchResultItem: Identifiable, Codable {
    let id: String
    var owner: String
    var secret: String
    var server: String
    var farm: Int
    var title: String
    var ispublic: Int
    var isfriend: Int
    var isfamily: Int
}
