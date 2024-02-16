//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import SwiftUI

@main
final class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sessionRole = connectingSceneSession.role
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: sessionRole)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
}

final class SceneDelegate: NSObject, UIWindowSceneDelegate {

    private var coordinator: HomeCoordinator?

    static var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        let navigationController = UINavigationController()
        SceneDelegate.window = UIWindow(windowScene: windowScene)
        SceneDelegate.window?.rootViewController = navigationController
        SceneDelegate.window?.makeKeyAndVisible()

        coordinator = HomeCoordinator(navigationController: navigationController)
        if let swiftUIView = coordinator?.start() {
            let viewController = UIHostingController(rootView: swiftUIView)
            navigationController.pushViewController(viewController, animated: false)
        }
    }
}
