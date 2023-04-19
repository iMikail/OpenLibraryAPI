//
//  DetailResponse.swift
//  OpenLibraryAPI
//
//  Created by Misha Volkov on 19.04.23.
//

struct DetailResponse: Codable {
    let title: String?
    let description: String?
    let firstPublishDate: String?

    enum CodingKeys: String, CodingKey {
            case title, description
            case firstPublishDate = "first_publish_date"
        }
}

struct DetailResponseEx: Codable {
    let title: String?
    let description: BookDescription?
    let firstPublishDate: String?

    enum CodingKeys: String, CodingKey {
            case title, description
            case firstPublishDate = "first_publish_date"
        }
}

struct BookDescription: Codable {
    let value: String?
}

struct BookDetail {
    var image: String?
    var title: String?
    var description: String?
    var firstPublishDate: String?
    var ratings: String
}
