//
//  SceneDelegate.swift
//  OpenLibraryAPI
//
//  Created by Misha Volkov on 19.04.23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let mainScene = (scene as? UIWindowScene) else { return }

        let mainVC = MainViewController()
        let navVC = UINavigationController(rootViewController: mainVC)
        window = UIWindow(windowScene: mainScene)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }
}
