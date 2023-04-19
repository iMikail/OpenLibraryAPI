//
//  NetworkService.swift
//  OpenLibraryAPI
//
//  Created by Misha Volkov on 19.04.23.
//

import Foundation

final class NetworkService {
    func fetchData(path: String,
                   host: String,
                   parameters: [String: String],
                   completion: @escaping (Data) -> Void) {
        guard let url = self.url(from: path, host: host, parameters: parameters) else {
            print("Url invalid")
            return
        }
        print("Fetching url: \(url.description)")

        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let data = data {
                DispatchQueue.main.async {
                    completion(data)
                    print("jsonData fetched")
                }
            } else if let error = error {
                print(error)
            }
        }.resume()
    }

    private func url(from path: String, host: String, parameters: [String: String]) -> URL? {
        var components = URLComponents()
        components.scheme = LibraryAPI.scheme
        components.host = host
        components.path = path
        components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }

        return components.url
    }
}
