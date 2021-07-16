//
//  SearchHistoryControllerTests.swift
//  FlickrFinderTests
//
//  Created by ilya Ramanenia on 17.07.21.
//

import XCTest
@testable import FlickrFinder

class SearchHistoryControllerTests: XCTestCase {
    private var userDefaults: UserDefaults!
    private var controller: SearchHistoryController!

    override func setUpWithError() throws {
        // Using isolated user defaults
        userDefaults = UserDefaults(suiteName: #file)!
        userDefaults.removePersistentDomain(forName: #file)
        
        controller = SearchHistoryControllerImpl(defaults: userDefaults)
    }

    override func tearDownWithError() throws {
        userDefaults.removePersistentDomain(forName: #file)
    }

    func testAddingInOrder() throws {
        // Given
        XCTAssertTrue(controller.history.isEmpty)
        
        // When
        controller.add(searchQuery: "Foo")

        // Then
        XCTAssertEqual(controller.history, ["Foo"])
        
        // When 2
        controller.add(searchQuery: "Bar")
        
        // Then 2
        XCTAssertEqual(controller.history, ["Bar", "Foo"])
    }
    
    func testLimit() throws {
        // Given
        XCTAssertTrue(controller.history.isEmpty)
        
        // When
        for i in 1...100 { controller.add(searchQuery: "Foo " + String(i)) }

        // Then
        XCTAssertEqual(controller.history.count, 20)
    }
}
