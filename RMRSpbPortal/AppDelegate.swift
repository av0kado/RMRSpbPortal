//
//  AppDelegate.swift
//  RMRSpbPortal
//
//  Created by Vladislav Maltsev on 02.11.2019.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private var applicationFlow: ApplicationFlow!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        applicationFlow = ApplicationFlow(window: window)
        applicationFlow.start()
        return true
    }
}

