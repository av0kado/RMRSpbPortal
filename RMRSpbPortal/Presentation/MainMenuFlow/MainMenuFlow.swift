//
//  MainMenuFlow.swift
//  RMRSpbPortal
//
//  Created by Vladislav Maltsev on 02.11.2019.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import UIKit

class MainMenuFlow {
    func start() -> UIViewController {
        return redViewController()
    }

    private func redViewController() -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = .red
        return controller
    }
}
