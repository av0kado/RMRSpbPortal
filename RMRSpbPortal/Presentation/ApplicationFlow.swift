//
//  ApplicationFlow.swift
//  RMRSpbPortal
//
//  Created by Vladislav Maltsev on 02.11.2019.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import UIKit

class ApplicationFlow {
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        window.makeKeyAndVisible()
        let mainMenuFlow = MainMenuFlow()
        setRootViewController(mainMenuFlow.start())
    }

    private func setRootViewController(_ viewController: UIViewController) {
        viewController.loadViewIfNeeded()
        viewController.view.frame = window.bounds
        window.rootViewController = viewController
    }
}
