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
    private lazy var loaderView = LoaderView(style: .large)
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
        view.addSubview(loaderView)
    }

    private func setupConstraints() {
        var constraints = [NSLayoutConstraint]()

        constraints.append(booksTable.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(booksTable.topAnchor.constraint(equalTo: view.topAnchor))
        constraints.append(booksTable.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(booksTable.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        constraints.append(booksTable.centerXAnchor.constraint(equalTo: view.centerXAnchor))

        constraints.append(loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor))

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
        let selectedBook = books[indexPath.row]
        guard let key = selectedBook.key else { return }

        dataFetcher.getBooks(forKey: key) { [weak self] (detailResponse, detailResponseEx) in
            guard let self = self else { return }

            let book = createDetailBook(selectedBook: selectedBook, detailResponse: detailResponse,
                                        detailResponseEx: detailResponseEx)
            let detailVC = DetailViewController()
            detailVC.book = book
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    private func createDetailBook(selectedBook: Doc, detailResponse: DetailResponse?,
                                  detailResponseEx: DetailResponseEx?) -> BookDetail {
        var ratings = ""
        if let currentRating = selectedBook.ratingAverage {
            ratings = String(format: "%.2f", currentRating)
        } else {
            ratings = "-"
        }
        let image = dataFetcher.getImageUrl(forCoverId: selectedBook.coverI, size: .medium)
        var description: String? = ""
        var firstPublishDate = ""
        if let year = selectedBook.firstPublishYear {
            firstPublishDate = "\(year)г."
        }

        if let detailResponse = detailResponse {
            description = detailResponse.description
            if let firstDate = detailResponse.firstPublishDate {
                firstPublishDate = firstDate
            }
        } else if let detailResponseEx = detailResponseEx {
            description = detailResponseEx.description?.value
            if let firstDate = detailResponseEx.firstPublishDate {
                firstPublishDate = firstDate
            }
        }
        let bookDetail = BookDetail(image: image, title: selectedBook.title, description: description,
                              firstPublishDate: firstPublishDate, ratings: ratings)

        return bookDetail
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
}
// MARK: - SearchViewDelegate
extension MainViewController: SearchViewDelegate {
    func findInfo(forText text: String) {
        loaderView.setHidden(false)
        dataFetcher.getSearchingResult(forRequest: text) { [weak self] response in
            guard let self = self else { return }
            self.books = response.docs
            self.loaderView.setHidden(true)
            self.booksTable.reloadData()
        }
    }
}
