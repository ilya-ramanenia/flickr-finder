//
//  NetworkLoaderTests.swift
//  FlickrFinderTests
//
//  Created by ilya Ramanenia on 27.07.21.
//

import XCTest
@testable import FlickrFinder

class NetworkLoaderTests: XCTestCase {
    
    func testImageSearchPipeline() throws {
        /// At first test image search query
        
        // Given
        let searchEndpoint = ImageSearchEndpoint(
            apiKey: Config().apiKey,
            searchQuery: "fat dog meme", page: 1)
        // Let's hope there are always results for fat dog meme!
        
        // When
        let expectation = self.expectation(description: "Search fetching")
        var foundImageItems: [ImageSearchResultItem] = []
        NetworkLoader().loadJSONModel(modelEndpoint: searchEndpoint) { result, error in
            foundImageItems = result?.photos.photo ?? []
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(!foundImageItems.isEmpty)


        /// After let's try to downloand one of images
        
        // Given
        let imageItem = try XCTUnwrap(foundImageItems.randomElement())
        let imageDownloadEndpoint = ImageDataEndpoint(id: imageItem.id,
                                         farm: imageItem.farm,
                                         server: imageItem.server,
                                         secret: imageItem.secret)
        
        // When
        let imageDownloadExpectation = self.expectation(description: "Image download")
        var result: UIImage?
        NetworkLoader().loadImage(endpoint: imageDownloadEndpoint) { image, _ in
            result = image
            imageDownloadExpectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(result)
    }
}
