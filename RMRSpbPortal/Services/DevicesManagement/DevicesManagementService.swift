//
// DevicesManagementService
// RMRSpbPortal
//
// Created by Amir Zigangaraev on 30 December 2019.
// Copyright (c) 2019 RedMadRobot. All rights reserved.
//

import Combine

enum DeviceError: Error {
    case notFound
}

protocol DevicesManagementService {
    /// Loads all available operating system options.
    func loadOperatingSystems() -> Future<[Device.OperatingSystem], Error>
    /// Loads devices list, may be specified with constraints.
    ///
    /// - Parameters:
    ///   - osConstraint: Constraint on devices operating system. Applied if not nil.
    ///   - project: Constraint on device project property. If specified, only devices that have this project in `projects` property will be
    ///     returned.
    ///   - available: Constraint on device availability status. If `true`, then all returned devices will have `.onStation` status.
    func loadDevices(
        with osConstraint: Device.OperatingSystem.Constraints?,
        project: Project?,
        available: Bool
    ) -> Future<[Device], Error>
    func device(withId id: String) -> Future<Device, Error>
    func update(device: Device) -> Future<(), Error>
}

extension Device.OperatingSystem {
    struct Constraints {
        let minimum: Device.OperatingSystem?
        let maximum: Device.OperatingSystem?

        init?(minimum: Device.OperatingSystem?, maximum: Device.OperatingSystem?) {
            switch (minimum, maximum) {
                case (nil, nil):
                    return nil
                case (nil, let maximum?):
                    self.minimum = nil
                    self.maximum = maximum
                case (let minimum?, nil):
                    self.minimum = minimum
                    self.maximum = nil
                case (.iOS(let minimumVersion)?, .iOS(let maximumVersion)?),
                     (.android(let minimumVersion)?, .android(let maximumVersion)?):
                    guard minimumVersion < maximumVersion else { return nil }

                    self.minimum = minimum
                    self.maximum = maximum
                case (.iOS?, .android?), (.android?, .iOS?):
                    return nil
            }
        }
    }
}
