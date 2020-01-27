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

class DevicesManagementFlow: DependencyInjectionContainerDependency, ModuleFactoryDependency {
    var container: DependencyInjectionContainer!
    var moduleFactory: ModuleFactory!

    func startViewController() -> UIViewController {
        return UINavigationController(rootViewController: devicesListViewController())
    }

    private func devicesListViewController() -> UIViewController {
        var (module, controller) = moduleFactory.devicesList()
        module.didSelectDevice = {
            print("Did select device: \($0)")
        }
        return controller
    }
}
