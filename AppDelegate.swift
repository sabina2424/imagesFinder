//
//  AppDelegate.swift
//  ImagesFinder
//
//  Created by 003995_Mac on 04.07.22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let viewController = SearchViewController(viewModel: SearchViewModel(inputData: .init()))
        window?.rootViewController = UINavigationController(rootViewController: viewController)
        return true
    }

}

