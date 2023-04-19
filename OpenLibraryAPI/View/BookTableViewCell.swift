//
//  BookTableViewCell.swift
//  OpenLibraryAPI
//
//  Created by Misha Volkov on 19.04.23.
//

import UIKit

final class BookTableViewCell: UITableViewCell {
    // MARK: - Constants/Variables
    static let identifier = "bookTableViewCell"
    static let imageViewHeight: CGFloat = 80.0
    private let imageViewWidth: CGFloat = 60.0

    // MARK: - UIViews
    private lazy var fotoImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .gray

        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.numberOfLines = 3
        label.textAlignment = .left

        return label
    }()
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textAlignment = .left

        return label
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitleLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally

        return stackView
    }()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        createConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions
    override func prepareForReuse() {
        fotoImageView.setImage(from: nil)
        titleLabel.text = nil
        subTitleLabel.text = nil
    }

    func setupCell(doc: Doc, image: String?) {
        fotoImageView.setImage(from: image)
        titleLabel.text = doc.title
        if let year = doc.firstPublishYear {
            subTitleLabel.text = "Первая публикация: \(year)"
        }
    }

    private func addSubviews() {
        contentView.addSubview(fotoImageView)
        contentView.addSubview(stackView)
    }

    private func createConstraints() {
        var constraints = [NSLayoutConstraint]()
        let space: CGFloat = 5.0

        constraints.append(fotoImageView.heightAnchor.constraint(equalToConstant: BookTableViewCell.imageViewHeight))
        constraints.append(fotoImageView.widthAnchor.constraint(equalToConstant: imageViewWidth))
        constraints.append(fotoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor))
        constraints.append(fotoImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: space))

        constraints.append(stackView.leftAnchor.constraint(equalTo: fotoImageView.rightAnchor, constant: space))
        constraints.append(stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: space))
        constraints.append(stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -space))
        constraints.append(stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -space))

        NSLayoutConstraint.activate(constraints)
    }
}
