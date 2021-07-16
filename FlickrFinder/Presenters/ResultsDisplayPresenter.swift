//
//  ResultsDisplayPresenter.swift
//  FlickrFinder
//
//  Created by ilya Ramanenia on 20.07.21.
//

import Foundation
import UIKit.UIImage

protocol ResultsDisplayPresenter: SearchPresenterSearchDelegate {
    func loadedViewDelegate(_ viewDelegate: ResultsDisplayViewDelegate?)
    func setPaginationDelegate(_ paginationDelegate: ResultsDisplayPaginationDelegate?)
    
    func searchResultsCount() -> Int
    func imageForSearchResult(index: Int, completion: ((UIImage?) -> Void)?)
}


protocol ResultsDisplayViewDelegate: AnyObject {
    func searchResultsUpdated(resetExisting: Bool)
}


protocol ResultsDisplayPaginationDelegate: AnyObject {
    func pageEnded(completion: SuccessClosure?)
}


final class ResultsDisplayPresenterImpl {
    
    // MARK: - Private
    
    private weak var viewDelegate: ResultsDisplayViewDelegate?
    private weak var paginationDelegate: ResultsDisplayPaginationDelegate?
    private var searchResults: [ImageSearchResultItem] = []
    private var isLoadingNextPage: Bool = false
    
    // MARK: - Methods
    
    
    // MARK: - Private methods
}

extension ResultsDisplayPresenterImpl: SearchPresenterSearchDelegate {
    
    func searchCompleted(_ results: [ImageSearchResultItem], resetExisting: Bool) {
        if resetExisting {
            searchResults = results
        }
        else {
            searchResults += results
        }
        viewDelegate?.searchResultsUpdated(resetExisting: resetExisting)
    }
}

extension ResultsDisplayPresenterImpl: ResultsDisplayPresenter {
    
    func loadedViewDelegate(_ delegate: ResultsDisplayViewDelegate?) {
        self.viewDelegate = delegate
    }
    
    func setPaginationDelegate(_ paginationDelegate: ResultsDisplayPaginationDelegate?) {
        self.paginationDelegate = paginationDelegate
    }
    
    func searchResultsCount() -> Int { searchResults.count }
    
    func imageForSearchResult(index: Int, completion: ((UIImage?) -> Void)?) {
        let item = searchResults[index]
        let endpoint = ImageDataEndpoint(id: item.id, farm: item.farm, server: item.server, secret: item.secret)
        NetworkLoader().loadImage(endpoint: endpoint) { result, _ in
            completion?(result)
        }
        
        // Load next page
        if index + Config().imagesLeftToLoadNextPage > searchResults.count && !isLoadingNextPage {
            isLoadingNextPage = true
            paginationDelegate?.pageEnded { [weak self] _ in
                self?.isLoadingNextPage = false
            }
        }
    }
}
