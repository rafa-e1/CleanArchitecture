//
//  SceneDelegate.swift
//  CleanArchitecture
//
//  Created by RAFA on 2/25/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene),
              let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return
        }

        let coreData = UserCoreData(viewContext: appDelegate.persistentContainer.viewContext)
        let network = UserNetwork(manager: NetworkManager(session: UserSession()))
        let userRepository = UserRepository(coreData: coreData, network: network)
        let userUseCase = UserListUseCase(repository: userRepository)
        let userViewModel = UserListViewModel(useCase: userUseCase)
        let userViewController = UserListViewController(viewModel: userViewModel)
        let navigationController = UINavigationController(rootViewController: userViewController)

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
