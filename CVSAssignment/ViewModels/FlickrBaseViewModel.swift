//
//  FlickrBaseViewModel.swift
//  CVSAssignment
//
//  Created by Rajesh Bandarupalli on 1/15/25.
//

import Foundation
import Combine

enum FlickrAPIState: Equatable {
    case idle
    case loading
    case success
    case empty
    case error(String)
}

class FlickrBaseViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var items = [FlickrItem]()
    @Published var apiState: FlickrAPIState = .idle
    
    private var cancellables = Set<AnyCancellable>()
    private let service = FlickrService()
    
    init() {
        $searchText
            .removeDuplicates()
            .sink { [weak self] text in
                self?.searchImages(for: text)
            }
            .store(in: &cancellables)
    }
    
    func searchImages(for tags: String) {
        guard !tags.isEmpty else {
            self.items = []
            self.apiState = .idle
            return
        }
        apiState = .loading
        service.fetchImages(for: tags)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.apiState = .error(error.localizedDescription)
                case .finished:
                    break
                }
                self.apiState = self.items.isEmpty ? .empty : .success
            }, receiveValue: { response in
                self.items = response.items ?? []
                self.apiState = self.items.isEmpty ? .empty : .success
            })
            .store(in: &cancellables)
    }
}
