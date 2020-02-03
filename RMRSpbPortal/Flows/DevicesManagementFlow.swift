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

    weak var navigationController: UINavigationController?

    func startViewController() -> UIViewController {
        let navigationController = UINavigationController(rootViewController: devicesListViewController())
        self.navigationController = navigationController
        return navigationController
    }

    private func devicesListViewController() -> UIViewController {
        var (module, controller) = moduleFactory.devicesList()
        module.didSelectDevice = { self.navigationController?.present(self.deviceDetailsViewController(deviceId: $0), animated: true) }
        return controller
    }

    private func deviceDetailsViewController(deviceId: Device.ID) -> UIViewController {
        var (module, controller) = moduleFactory.deviceDetails()
        module.deviceId = deviceId
        return controller
    }
}
