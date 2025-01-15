//
//  FlickrModel.swift
//  CVSAssignment
//
//  Created by Rajesh Bandarupalli on 1/15/25.
//
import SwiftUI

struct FlickrModel: Codable {
    let title: String?
    let link: String?
    let description: String?
    let modified: String?
    let generator: String?
    let items: [FlickrItem]?
}

struct FlickrItem: Codable, Identifiable {
    var id: String { link }
    let title: String?
    let link: String
    let media: Media?
    let dateTaken: String?
    let description: String?
    let published: String?
    let author: String?
    let authorID: String?
    let tags: String?
    var image: Image? = nil // Use this to feed fetched image to the respective item
    
    enum CodingKeys: String, CodingKey {
        case title, link, media
        case dateTaken = "date_taken"
        case description, published, author
        case authorID = "author_id"
        case tags
    }
}

struct Media: Codable {
    let m: String?
}

extension FlickrItem: Hashable {
    static func == (lhs: FlickrItem, rhs: FlickrItem) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
