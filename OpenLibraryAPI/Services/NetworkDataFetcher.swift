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

    func getSearchingResult(forRequest request: String, completion: @escaping (SearchResponse?, Error?) -> Void) {
        let path = "/search.json"
        let parameters: [String: String] = ["q": request, "limit": String(LibraryAPI.booksLimit)]
        networkService.fetchData(path: path,
                                 host: LibraryAPI.libraryHost,
                                 parameters: parameters) { [weak self] (jsonData, error) in
            if let error = error {
                completion(nil, error)
            }

            guard let jsonData = jsonData else { return }
            if let booksResponse = self?.decodeJson(type: SearchResponse.self, data: jsonData) {
                completion(booksResponse, nil)
            }
        }
    }

    func getBooks(forKey key: String, completion: @escaping (DetailResponse?, DetailResponseEx?) -> Void) {
        let path = "\(key).json"
        let parameters: [String: String] = ["details": "true"]

        networkService.fetchData(path: path,
                                 host: LibraryAPI.libraryHost,
                                 parameters: parameters) { [weak self] (jsonData, _) in
            guard let self = self, let jsonData = jsonData else { return }

            if let detailResponse = self.decodeJson(type: DetailResponse.self, data: jsonData) {
                if detailResponse.description != nil {
                    completion(detailResponse, nil)
                    return
                }
            }
            if let detailResponseEx = self.decodeJson(type: DetailResponseEx.self, data: jsonData) {
                completion(nil, detailResponseEx)
                return
            }
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
