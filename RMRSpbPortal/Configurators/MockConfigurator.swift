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
        let settingsService = UserDefaultsSettingsService(userDefaults: .standard)
        let devicesManagementService = MockDevicesManagementService()
        let builder = ContainerBuilder(
            settingsService: settingsService,
            devicesManagementService: devicesManagementService
        )
        return builder.container
    }
}
