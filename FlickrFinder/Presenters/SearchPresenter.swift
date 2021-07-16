//
//  SearchPresenter.swift
//  FlickrFinder
//
//  Created by ilya Ramanenia on 24.07.21.
//

import Foundation

protocol SearchPresenter: ResultsDisplayPaginationDelegate {
    func loadedViewDelegate(_ viewDelegate: SearchPresenterViewDelegate?)
    func setSearchDelegate(_ searchDelegate: SearchPresenterSearchDelegate?)
    
    func history() -> [String]
    
    func queryChanged(_ query: String)
    func queryChangeEnded()
}

protocol SearchPresenterViewDelegate: AnyObject {
    func searchStarted()
    func searchFinished()
    func historyUpdated(results: [String])
}

protocol SearchPresenterSearchDelegate: AnyObject {
    func searchCompleted(_ results: [ImageSearchResultItem], resetExisting: Bool)
}

final class SearchPresenterImpl {
    
    // MARK: - Private
    
    private enum Const {
        static let queryTextInputDelay: TimeInterval = 0.8
    }
    
    private weak var viewDelegate: SearchPresenterViewDelegate?
    private weak var searchDelegate: SearchPresenterSearchDelegate?
    
    private var lastQuery: String = ""
    private var lastPage: Int = 1
    
    private let historyController: SearchHistoryController = SearchHistoryControllerImpl()
    private let searchQueue: DispatchQueue = .global(qos: .userInitiated)
    private let debouncer: Debouncer = .init(.seconds(Const.queryTextInputDelay))
    
    // MARK: - Methods
    
    init(searchDelegate: SearchPresenterSearchDelegate? = nil) {
        self.searchDelegate = searchDelegate
    }
    
    // MARK: - Private methods
    
    private func search(query: String, page: Int, completion: SuccessClosure?) {
        DispatchQueue.main.async {
            self.viewDelegate?.searchStarted()
        }
        searchQueue.async {
            let endpoint = ImageSearchEndpoint(
                apiKey: Config().apiKey, searchQuery: query, page: page)
            NetworkLoader().loadJSONModel(modelEndpoint: endpoint) { [weak self] result, error in
                let results = result?.photos.photo ?? []
                self?.viewDelegate?.searchFinished()
                self?.searchDelegate?.searchCompleted(results, resetExisting: page == 1)
                completion?(error == nil)
            }
        }
    }
}

extension SearchPresenterImpl: SearchPresenter {
    func setSearchDelegate(_ searchDelegate: SearchPresenterSearchDelegate?) {
        self.searchDelegate = searchDelegate
    }
    
    func loadedViewDelegate(_ viewDelegate: SearchPresenterViewDelegate?) {
        self.viewDelegate = viewDelegate
        viewDelegate?.historyUpdated(results: historyController.history)
    }
    
    func history() -> [String] { historyController.history }
    
    func queryChanged(_ query: String) {
        let normalizedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalizedQuery.isEmpty else { return }
        
        // Debouncing user's query input
        debouncer.callback = { [self] in
            lastPage = 1
            search(query: query, page: lastPage) { [self] succeed in
                guard succeed else { return }
                
                historyController.add(searchQuery: query)
                viewDelegate?.historyUpdated(results: historyController.history)
                lastQuery = normalizedQuery
            }
        }
        debouncer.call()
    }
    
    func queryChangeEnded() {
        // Running debounced query right away
        if let debouncingCallback = debouncer.callback {
            debouncingCallback()
            debouncer.callback = nil
        }
    }
}

extension SearchPresenterImpl: ResultsDisplayPaginationDelegate {
    func pageEnded(completion: SuccessClosure?) {
        lastPage += 1
        search(query: lastQuery, page: lastPage, completion: completion)
    }
}
