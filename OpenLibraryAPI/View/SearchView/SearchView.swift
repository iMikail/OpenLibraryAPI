//
//  SearchView.swift
//  OpenLibraryAPI
//
//  Created by Misha Volkov on 19.04.23.
//

import UIKit

protocol SearchViewDelegate: AnyObject {
    func findInfo(forText text: String)
}

final class SearchView: UIView {
    weak var delegate: SearchViewDelegate?
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }

    private lazy var searchTextField = SearchTextField()
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Найти", for: .normal)
        button.tintColor = .blue


        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        searchTextField.delegate = self
        searchButton.addTarget(self, action: #selector(searching), for: .touchUpInside)
        setupViews()
        setupConstraints()
    }

    @objc private func searching() {
        guard let text = searchTextField.text, !text.isEmpty else { return }

        searchTextField.resignFirstResponder()
        delegate?.findInfo(forText: text)
    }

    private func setupViews() {
        addSubview(searchTextField)
        addSubview(searchButton)
    }

    private func setupConstraints() {
        var constraints = [NSLayoutConstraint]()
        constraints.append(searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor))
        constraints.append(searchTextField.topAnchor.constraint(equalTo: topAnchor))
        constraints.append(searchTextField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor))
        constraints.append(searchTextField.bottomAnchor.constraint(equalTo: bottomAnchor))

        constraints.append(searchButton.topAnchor.constraint(equalTo: topAnchor))
        constraints.append(searchButton.trailingAnchor.constraint(equalTo: trailingAnchor))
        constraints.append(searchButton.heightAnchor.constraint(equalTo: searchTextField.heightAnchor, multiplier: 1))
        constraints.append(searchButton.widthAnchor.constraint(equalToConstant: 70))

        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searching()
        return true
    }
}
