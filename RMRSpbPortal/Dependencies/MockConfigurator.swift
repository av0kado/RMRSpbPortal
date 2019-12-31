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
        let container = Odin()
        let settingsService = { () -> SettingService in
            UserDefaultsSettingsService(userDefaults: .standard)
        }
        let builder = ContainerBuilder(container: container, settingsService: settingsService)
        return builder.container
    }
}
