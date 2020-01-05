//
// DevicesListModule
// RMRSpbPortal
//
// Created by Amir Zigangaraev on 02 January 2020.
// Copyright (c) 2020 RedMadRobot. All rights reserved.
//

import Combine

protocol DevicesListModule {
    var operatingSystemConstraintsSubscriber: AnySubscriber<Device.OperatingSystem.Constraints?, Never> { get }
    var projectFilterSubscriber: AnySubscriber<Project?, Never> { get }
    var loadOnlyAvailableSubscriber: AnySubscriber<Bool, Never> { get }
}
