//
//  AppDelegate.swift
//  ThreeDotsAnimation
//
//  Created by Алексей Папин on 14.02.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    enum Screen: String {
        case dots
        case circles
        case layers

        var viewController: UIViewController {
            switch self {
            case .dots: return ThreeDotsViewController()
            case .circles: return CirclesViewController()
            case .layers: return AnimationsExpViewController()
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        setRoot(screen: .circles)
        return true
    }

    private func setRoot(screen: Screen) {
        window?.rootViewController = screen.viewController
        window?.makeKeyAndVisible()
    }
}

