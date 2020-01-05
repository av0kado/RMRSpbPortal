//
// DevicesManagementFlow
// RMRSpbPortal
//
// Created by Amir Zigangaraev on 02 January 2020.
// Copyright (c) 2020 RedMadRobot. All rights reserved.
//

import UIKit
import Combine
import Legacy

class DevicesManagementFlow: DependencyInjectionContainerDependency {
    var container: DependencyInjectionContainer?

    func startViewController() -> UIViewController {
        return UINavigationController(rootViewController: devicesListViewController())
    }

    private func devicesListViewController() -> UIViewController {
        fatalError("Not implemented")
    }
}
