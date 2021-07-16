//
//  Config.swift
//  FlickrFinder
//
//  Created by ilya Ramanenia on 25.07.21.
//

import Foundation

struct Config {
    
    let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as! String
    let imageLoadTimeout: TimeInterval = 30
    
    let imagesPerPage = 10
    let imagesLeftToLoadNextPage = 2
}
