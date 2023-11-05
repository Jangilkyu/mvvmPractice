//
//  SceneDelegate.swift
//  SeoulCongestion
//
//  Created by jangilkyu on 2023/01/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(
        _ scene: UIScene, willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let useCase = CitiesUseCaseImpl(provider: CitiesProvider.shared.getMoyaProvider())
        let viewModel = CitiesViewModel()
        
        let rootViewController = CityListViewController(citiesUseCase: useCase, viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        window.overrideUserInterfaceStyle = .light
        self.window = window
        window.makeKeyAndVisible()

    }

    func sceneDidDisconnect(
        _ scene: UIScene
    ) {
    }

    func sceneDidBecomeActive(
        _ scene: UIScene
    ) {
    }

    func sceneWillResignActive(
        _ scene: UIScene
    ) {
    }

    func sceneWillEnterForeground(
        _ scene: UIScene
    ) {
    }

    func sceneDidEnterBackground(
        _ scene: UIScene
    ) {
    }
}
