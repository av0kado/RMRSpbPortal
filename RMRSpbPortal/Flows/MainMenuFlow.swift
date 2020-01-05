//
//  MainMenuFlow.swift
//  RMRSpbPortal
//
//  Created by Vladislav Maltsev on 02.11.2019.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import Legacy
import UIKit

class MainMenuFlow: DependencyInjectionContainerDependency {
    var container: DependencyInjectionContainer?

    func start() -> UIViewController {
        return devicesManagementFlow()
    }

    private func devicesManagementFlow() -> UIViewController {
        let flow = DevicesManagementFlow()
        container?.resolve(flow)
        return flow.startViewController()
    }
}
