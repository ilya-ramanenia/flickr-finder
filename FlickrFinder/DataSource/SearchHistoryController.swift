//
//  SearchResultsController.swift
//  FlickrFinder
//
//  Created by ilya Ramanenia on 24.07.21.
//

import Foundation

/// Saves results in historical (inverted) order in UserDefaults

// MARK: - Public

protocol SearchHistoryController {
    var history: [String] { get }
    
    func add(searchQuery: String)
    func clear()
}

// MARK: - Implementation

struct SearchHistoryControllerImpl {
    
    private enum Const {
        static let historyLimit = 20
        static let defaultsKey = "searchHistory"
    }
    
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
}


extension SearchHistoryControllerImpl: SearchHistoryController {
    
    var history: [String] { defaults.object(forKey: Const.defaultsKey) as? [String] ?? [] }
    
    func add(searchQuery: String) {
        var results = history
        
        // If new query extends the last one – merging
        if let previousQuery = results.first,
           searchQuery.hasPrefix(previousQuery) {
            results.remove(at: 0)
        }
        
        // Filtering duplicates from history
        results = results.filter { $0 != searchQuery }
        
        results.insert(searchQuery, at: 0)
        results = results.suffix(Const.historyLimit)
        defaults.setValue(results, forKey: Const.defaultsKey)
        defaults.synchronize()
    }
    
    func clear() {
        defaults.setValue([], forKey: Const.defaultsKey)
        defaults.synchronize()
    }
}
