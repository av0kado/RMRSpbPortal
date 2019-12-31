//
// ContainerBuilder
// RMRSpbPortal
//
// Created by Amir Zigangaraev on 30 December 2019.
// Copyright (c) 2019 RedMadRobot. All rights reserved.
//

import Legacy

struct ContainerBuilder {
    var container: DependencyInjectionContainer

    init(
        container: Odin,
        settingsService: @escaping () -> SettingService
    ) {
        self.container = container
        container.register { settingsService() }
        container.register { () -> DependencyInjectionContainer in
            self.container
        }
    }
}
