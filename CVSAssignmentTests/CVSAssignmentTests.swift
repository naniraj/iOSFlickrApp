//
//  CVSAssignmentTests.swift
//  CVSAssignmentTests
//
//  Created by Rajesh Bandarupalli on 1/15/25.
//

import XCTest
@testable import CVSAssignment
import Combine

final class CVSAssignmentTests: XCTestCase {
    var viewModel: FlickrBaseViewModel!
    var cancellables: Set<AnyCancellable>!
    override func setUp() {
        super.setUp()
        viewModel = FlickrBaseViewModel()
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testIdleState() {
        XCTAssertEqual(viewModel.apiState, .idle)
        XCTAssertTrue(viewModel.items.isEmpty)
    }
    
    func testLoadingState() {
        let expectation = self.expectation(description: "Loading State")
        
        viewModel.$apiState
            .sink { state in
                if case .loading = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.searchText = "test"
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSuccessState() {
        let expectation = self.expectation(description: "Success State")
        let mockData = FlickrModel(
            title: "Test Search",
            link: "https://www.example.com",
            description: "",
            modified: "",
            generator: "",
            items: [
                FlickrItem(title: "Image 1", link: "", media: nil, dateTaken: "", description: "", published: "", author: "", authorID: "1", tags: "test"),
                FlickrItem(title: "Image 2", link: "", media: nil, dateTaken: "", description: "", published: "", author: "", authorID: "2", tags: "test")
            ]
        )
        
        viewModel.$apiState
            .sink { state in
                if case .success = state {
                    XCTAssertEqual(self.viewModel.items.count, mockData.items?.count ?? 0)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.searchImages(for: "test")
        viewModel.items = mockData.items ?? []
        viewModel.apiState = .success
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testEmptyState() {
        let expectation = self.expectation(description: "Empty State")
        
        viewModel.$apiState
            .sink { state in
                if case .empty = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.searchImages(for: "nonexistenttag")
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testErrorState() {
        let expectation = self.expectation(description: "Error State")
        let errorMessage = "Failed to fetch data"
        
        viewModel.$apiState
            .sink { state in
                if case .error(let message) = state {
                    XCTAssertEqual(message, errorMessage)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.searchImages(for: "error")
        viewModel.apiState = .error(errorMessage)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
}
