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
    private lazy var booksTable: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self

        return tableView
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopBar()
        setupViews()
        setupConstraints()
        searchView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupStatusBar()
    }

    // MARK: - Functions
    private func setupTopBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.hidesBarsOnSwipe = true
        navigationItem.titleView = searchView
    }

    private func setupStatusBar() {
        if let statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame {
            let statusBar = UIView(frame: statusBarFrame)
            statusBar.backgroundColor = navigationController?.navigationBar.backgroundColor
            view.addSubview(statusBar)
        }
    }

    private func setupViews() {
        view.addSubview(booksTable)

    }

    private func setupConstraints() {
        var constraints = [NSLayoutConstraint]()

        constraints.append(booksTable.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(booksTable.topAnchor.constraint(equalTo: view.topAnchor))
        constraints.append(booksTable.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(booksTable.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        constraints.append(booksTable.centerXAnchor.constraint(equalTo: view.centerXAnchor))

        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.identifier,
                                                       for: indexPath) as? BookTableViewCell else { return UITableViewCell() }

        let image = dataFetcher.getImageUrl(forCoverId: books[indexPath.row].coverI, size: .small)
        cell.setupCell(doc: books[indexPath.row], image: image)

        return cell
    }


}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
}
// MARK: - SearchViewDelegate
extension MainViewController: SearchViewDelegate {
    func findInfo(forText text: String) {
        dataFetcher.getSearchingResult(forRequest: text) { [weak self] response in
            guard let self = self else { return }
            self.books = response.docs
            self.booksTable.reloadData()
        }
    }
}
