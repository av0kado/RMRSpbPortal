//
//  AppDelegate.swift
//  RMRSpbPortal
//
//  Created by Vladislav Maltsev on 02.11.2019.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import Legacy
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, DependencyInjectionContainerDependency {
    var container: DependencyInjectionContainer?

    private var applicationFlow: ApplicationFlow!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        configurator().build().resolve(self)

        let window = UIWindow(frame: UIScreen.main.bounds)
        applicationFlow = ApplicationFlow(window: window)
        container?.resolve(applicationFlow)
        applicationFlow.start()
        return true
    }

    private func configurator() -> Configurator {
        #if MOCK
        return MockConfigurator()
        #else
        guard let endpoint = Bundle.main.configurationParameters.endpoint else {
            fatalError("Endpoint is not specified")
        }
        return NetworkConfigurator(endpoint: endpoint)
        #endif
    }
}

