//
//  NetworkDataFetcher.swift
//  OpenLibraryAPI
//
//  Created by Misha Volkov on 19.04.23.
//

import Foundation

enum ImageSize: String {
    case small = "S"
    case medium = "M"
    case large = "L"
}

final class NetworkDataFetcher {
    let networkService = NetworkService()

    func getSearchingResult(forRequest request: String, completion: @escaping (SearchResponse) -> Void) {
        let path = "/search.json"
        let parameters: [String: String] = ["q": request, "limit": String(LibraryAPI.booksLimit)]
        networkService.fetchData(path: path, host: LibraryAPI.libraryHost, parameters: parameters) { [weak self] jsonData in
            if let booksResponse = self?.decodeJson(type: SearchResponse.self, data: jsonData) {
                completion(booksResponse)
            }
        }
    }

    func getBooks(forKey key: String) {
        let path = "\(key).json"
        let parameters: [String: String] = ["details": "true"]

        networkService.fetchData(path: path, host: LibraryAPI.libraryHost, parameters: parameters) { jsonData in
            print(jsonData)
        }

    }

    func getImageUrl(forCoverId coverId: Int?, size: ImageSize) -> String? {
        guard let coverId = coverId else { return nil }

        var components = URLComponents()
        components.scheme = LibraryAPI.scheme
        components.host = LibraryAPI.coversHost
        components.path = "/b/id/\(coverId)-\(size.rawValue).jpg"

        return components.string
    }

    private func decodeJson<T: Decodable>(type: T.Type, data: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(type.self, from: data)
            return response
        } catch {
            print("Error decode: \(error)")
        }

        return nil
    }
}
