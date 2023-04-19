//
//  MainViewController.swift
//  OpenLibraryAPI
//
//  Created by Misha Volkov on 19.04.23.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: - Constants/variables
    private var books = [Doc]()
    private var dataFetcher = NetworkDataFetcher()

    // MARK: - Views
    private lazy var searchView = SearchView()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        setupTopBar()
        searchView.delegate = self
    }

    // MARK: - Functions
    private func setupTopBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.hidesBarsOnSwipe = true
        navigationItem.titleView = searchView
    }

}

// MARK: - SearchViewDelegate
extension MainViewController: SearchViewDelegate {
    func findInfo(forText text: String) {
        dataFetcher.getSearchingResult(forRequest: text) { [weak self] response in
            print(response.docs)
        }
    }
}
