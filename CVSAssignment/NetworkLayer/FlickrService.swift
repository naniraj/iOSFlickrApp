//
//  FlickrService.swift
//  CVSAssignment
//
//  Created by Rajesh Bandarupalli on 1/15/25.
//

import Foundation
import Combine

class FlickrService {
    
    func fetchImages(for tags: String) -> AnyPublisher<FlickrModel, Error> {
        let urlString = AppConstants.baseURL + tags.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: urlString)!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .receive(on: DispatchQueue.main)
            .decode(type: FlickrModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
