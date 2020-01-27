//
//  InMemoryDevicesListSettingsService.swift
//  RMRSpbPortal
//
//  Created by Amir Zigangaraev on 26.01.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Combine

class InMemoryDevicesListSettingsService: DevicesListSettingsService {
    let projectFilter: CurrentValueSubject<Project?, Never>
    let osFilter: CurrentValueSubject<Device.OperatingSystem.Constraints?, Never>
    let availableOnly: CurrentValueSubject<Bool, Never>

    init() {
        projectFilter = CurrentValueSubject(nil)
        osFilter = CurrentValueSubject(nil)
        availableOnly = CurrentValueSubject(false)
    }
}
