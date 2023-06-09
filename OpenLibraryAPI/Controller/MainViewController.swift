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
    private lazy var noResultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .gray
        label.numberOfLines = 2
        label.textAlignment = .center

        return label
    }()

    private lazy var booksTable: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self

        return tableView
    }()

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: ImageKeys.openLibrary.rawValue)

        return imageView
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.backButtonTitle = "Назад"
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
    private func hideViews(_ isHidden: Bool) {
        if isHidden {
            noResultLabel.isHidden = isHidden
            logoImageView.isHidden = isHidden
            booksTable.isHidden = isHidden
            loaderView.setHidden(!isHidden)
        } else {
            let isEmpty = books.isEmpty
            noResultLabel.isHidden = !isEmpty
            logoImageView.isHidden = !isEmpty
            booksTable.isHidden = isEmpty
            loaderView.setHidden(!isHidden)
        }
    }

    private func setResultTitle(isError: Bool) {
        noResultLabel.text = isError ? "Ошибка сети.\nПопробуйте снова." : "Ничего не найдено."
    }

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
        view.addSubview(logoImageView)
        view.addSubview(loaderView)
        view.addSubview(noResultLabel)
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

        constraints.append(noResultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(noResultLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15))

        constraints.append(logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        constraints.append(logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9))

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
        hideViews(true)
        dataFetcher.getSearchingResult(forRequest: text) { [weak self] (response, error) in
            guard let self = self else { return }

            if error != nil {
                books = []
                setResultTitle(isError: true)
                hideViews(false)
                return
            }

            guard let response = response else { return }
            books = response.docs
            setResultTitle(isError: false)
            hideViews(false)
            booksTable.reloadData()
        }
    }
}
