//
//  DefaultModuleFactory.swift
//  RMRSpbPortal
//
//  Created by Amir Zigangaraev on 26.01.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit
import Legacy

class DefaultModuleFactory: ModuleFactory, DependencyInjectionContainerDependency {
    var container: DependencyInjectionContainer!

    func devicesList() -> (DevicesListModule, UIViewController) {
        let viewModel = DefaultDevicesListViewModel(
            devicesManagementService: container.resolveOrDie(),
            devicesListSettingsService: container.resolveOrDie()
        )
        let view = DevicesListViewController(viewModel: viewModel)
        return (viewModel, view)
    }

    func deviceDetails() -> (DeviceDetailsModule, UIViewController) {
        let viewModel = DefaultDeviceDetailsViewModel(devicesManagementService: container.resolveOrDie())
        let view = DeviceDetailsViewController(viewModel: viewModel)
        return (viewModel, view)
    }
}
