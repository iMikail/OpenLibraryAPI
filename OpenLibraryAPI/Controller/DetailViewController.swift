//
//  DetailViewController.swift
//  OpenLibraryAPI
//
//  Created by Misha Volkov on 19.04.23.
//

import UIKit

final class DetailViewController: UIViewController {
    // MARK: - Constants/Variables
    private let imageViewHeight: CGFloat = 290.0
    private let imageViewWidth: CGFloat = 180.0
    var book: BookDetail?

    // MARK: - Views
    private lazy var fotoImageView: WebImageView = {
        let webView = WebImageView()
        webView.translatesAutoresizingMaskIntoConstraints = false

        return webView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 2

        return label
    }()

    private lazy var publishedTitleLabel = createTitleLabel("Первая публикация:")
    private lazy var firstPublishedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center

        return label
    }()
    private lazy var publishedStack = createVerticalStack(forView: publishedTitleLabel, otherView: firstPublishedLabel)

    private lazy var ratingsTitleLabel = createTitleLabel("Рейтинг:")
    private lazy var ratingsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center

        return label
    }()
    private lazy var ratingsStack = createVerticalStack(forView: ratingsTitleLabel, otherView: ratingsLabel)

    private lazy var horizontalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(publishedStack)
        stackView.addArrangedSubview(ratingsStack)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 5

        return stackView
    }()

    private lazy var descriptionTitle = createTitleLabel("Описание:")
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .darkGray

        return label
    }()

    private lazy var verticalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(horizontalStack)
        stackView.addArrangedSubview(descriptionTitle)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 15

        return stackView
    }()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        return scrollView
    }()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupBookInfo()
        setupConstraints()
    }

    // MARK: - Functions
    private func setupBookInfo() {
        guard let book = book else { return }

        fotoImageView.setImage(from: book.image)
        titleLabel.text = book.title
        firstPublishedLabel.text = book.firstPublishDate
        ratingsLabel.text = book.ratings
        descriptionLabel.text = book.description
    }

    private func setupViews() {
        view.addSubview(fotoImageView)
        view.addSubview(verticalStack)
        scrollView.addSubview(descriptionLabel)
        view.addSubview(scrollView)
    }

    private func setupConstraints() {
        var constrs = [NSLayoutConstraint]()
        let widthMultiplier: CGFloat = 0.9
        constrs.append(fotoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10))
        constrs.append(fotoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constrs.append(fotoImageView.heightAnchor.constraint(lessThanOrEqualToConstant: imageViewHeight))
        constrs.append(fotoImageView.widthAnchor.constraint(lessThanOrEqualToConstant: imageViewWidth))

        let topStackAnchor = verticalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30)
        topStackAnchor.priority = .defaultLow
        constrs.append(topStackAnchor)
        constrs.append(verticalStack.topAnchor.constraint(equalTo: fotoImageView.bottomAnchor, constant: 10))
        constrs.append(verticalStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: widthMultiplier))
        constrs.append(verticalStack.centerXAnchor.constraint(equalTo: view.centerXAnchor))

        constrs.append(scrollView.topAnchor.constraint(equalTo: verticalStack.bottomAnchor, constant: 10))
        constrs.append(scrollView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: widthMultiplier))
        constrs.append(scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constrs.append(scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20))

        constrs.append(descriptionLabel.topAnchor.constraint(equalTo: scrollView.topAnchor))
        constrs.append(descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: widthMultiplier))
        constrs.append(descriptionLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor))
        constrs.append(descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor))

        NSLayoutConstraint.activate(constrs)
    }

    private func createTitleLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .center

        return label
    }

    private func createVerticalStack(forView view: UIView, otherView: UIView) -> UIStackView {
        let stackView = UIStackView()
        stackView.addArrangedSubview(view)
        stackView.addArrangedSubview(otherView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical

        return stackView
    }
}
