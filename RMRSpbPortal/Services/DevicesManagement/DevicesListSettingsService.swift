//
//  DevicesListSettingsService.swift
//  RMRSpbPortal
//
//  Created by Amir Zigangaraev on 26.01.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Combine

protocol DevicesListSettingsService {
    var projectFilter: CurrentValueSubject<Project?, Never> { get }
    var osFilter: CurrentValueSubject<Device.OperatingSystem.Constraints?, Never> { get }
    var availableOnly: CurrentValueSubject<Bool, Never> { get }
}
