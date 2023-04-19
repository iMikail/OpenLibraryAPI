//
//  LoaderView.swift
//  OpenLibraryAPI
//
//  Created by Misha Volkov on 19.04.23.
//

import UIKit

final class LoaderView: UIActivityIndicatorView {

    override init(style: UIActivityIndicatorView.Style) {
        super.init(style: style)
        translatesAutoresizingMaskIntoConstraints = false
        isHidden = true
        hidesWhenStopped = true
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setHidden(_ hidden: Bool) {
        if hidden {
            stopAnimating()
        } else {
            isHidden = hidden
            startAnimating()
        }
    }
}
