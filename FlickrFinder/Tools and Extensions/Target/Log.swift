//
//  Log.swift
//  FlickrFinder
//
//  Created by ilya Ramanenia on 25.07.21.
//

import Foundation

public func log(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    print(items)
    #endif
}
