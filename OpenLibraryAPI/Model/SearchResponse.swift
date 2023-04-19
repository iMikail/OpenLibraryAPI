//
//  SearchResponse.swift
//  OpenLibraryAPI
//
//  Created by Misha Volkov on 19.04.23.
//

struct SearchResponse: Codable {
    let docs: [Doc]

    enum CodingKeys: String, CodingKey {
        case docs
    }
}

struct Doc: Codable {
    let key: String?
    let title: String?
    let firstPublishYear: Int?
    let coverI: Int?
    let ratingAverage: Double?

    enum CodingKeys: String, CodingKey {
        case key, title
        case firstPublishYear = "first_publish_year"
        case coverI = "cover_i"
        case ratingAverage = "ratings_average"
    }
}
