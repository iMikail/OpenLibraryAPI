//
//  WebImageView.swift
//  OpenLibraryAPI
//
//  Created by Misha Volkov on 19.04.23.
//

import UIKit

final class WebImageView: UIImageView {
    private var currentUrlString: String?

    func setImage(from imageUrl: String?) {
        currentUrlString = imageUrl
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else {
            image = nil
            return
        }

        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            image = UIImage(data: cachedResponse.data)
            print("Image loaded from cache")
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print(error)
            }
            guard let self = self else { return }

            DispatchQueue.main.async {
                if let data = data, let response = response {
                    self.handleLoadedImage(data: data, response: response)
                    print("Image loaded from internet")
                }
            }
        }.resume()
    }

    private func handleLoadedImage(data: Data, response: URLResponse) {
        guard let responseUrl = response.url else { return }

        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseUrl))

        if responseUrl.absoluteString == currentUrlString {
            image = UIImage(data: data)
        }
    }
}
