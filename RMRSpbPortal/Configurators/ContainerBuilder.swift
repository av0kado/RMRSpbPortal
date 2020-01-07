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
        settingsService: SettingService,
        devicesManagementService: DevicesManagementService,
        projectsService: ProjectsService
    ) {
        let container = Odin()
        self.container = container
        container.register { (object: inout SettingsServiceDependency) in
            object.settingsService = settingsService
        }
        container.register { (object: inout DevicesManagementServiceDependency) in
            object.devicesManagementService = devicesManagementService
        }
        container.register { settingsService }
        container.register { devicesManagementService }
        container.register { projectsService }
        container.register { [unowned container] (object: inout DependencyInjectionContainerDependency) in
            object.container = container
        }
    }
}