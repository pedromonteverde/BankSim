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
        sceneConfig.accessibilityActivate()
        return sceneConfig
    }
}

final class SceneDelegate: NSObject, UIWindowSceneDelegate {

    static var navigationController: UINavigationController? {
        window?.rootViewController as? UINavigationController
    }

    private static var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true

        SceneDelegate.window = UIWindow(windowScene: windowScene)
        SceneDelegate.window?.rootViewController = navigationController
        SceneDelegate.window?.makeKeyAndVisible()

        if NSClassFromString("XCTestCase") == nil {
            HomeCoordinator(navigationController: navigationController).start()
        }
    }
}
