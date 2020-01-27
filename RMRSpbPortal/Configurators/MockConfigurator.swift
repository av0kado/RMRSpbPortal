//
// MockConfigurator
// RMRSpbPortal
//
// Created by Amir Zigangaraev on 30 December 2019.
// Copyright (c) 2019 RedMadRobot. All rights reserved.
//

import Legacy

class MockConfigurator: Configurator {
    func build() -> DependencyInjectionContainer {
        let moduleFactory = DefaultModuleFactory()
        let settingsService = UserDefaultsSettingsService(userDefaults: .standard)
        let devicesManagementService = MockDevicesManagementService()
        let devicesListSettingsService = InMemoryDevicesListSettingsService()
        let projectsService = MockProjectsService()
        let builder = ContainerBuilder(
            moduleFactory: moduleFactory,
            settingsService: settingsService,
            devicesManagementService: devicesManagementService,
            devicesListSettingsService: devicesListSettingsService,
            projectsService: projectsService
        )
        let container = builder.container
        container.resolve(moduleFactory)
        return container
    }
}
