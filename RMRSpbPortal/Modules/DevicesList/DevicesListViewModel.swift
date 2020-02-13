//
// DevicesListViewModel
// RMRSpbPortal
//
// Created by Amir Zigangaraev on 02 January 2020.
// Copyright (c) 2020 RedMadRobot. All rights reserved.
//

import Foundation
import Combine

enum DevicesListState {
    case loading
    case devices([Device])
    case error(Error)
}

protocol DevicesListViewModel {
    var devicesListStatePublisher: AnyPublisher<DevicesListState, Never> { get }

    func reload()
    func select(device: Device)
}

class DefaultDevicesListViewModel: DevicesListModule, DevicesListViewModel {

    // MARK: - DevicesListModule

    var didSelectDevice: ((Device.ID) -> Void)?

    // MARK: - DevicesListViewModel

    let devicesListStatePublisher: AnyPublisher<DevicesListState, Never>

    func reload() {
        loadActions.send()
    }

    func select(device: Device) {
        didSelectDevice?(device.id)
    }

    // MARK: -

    private let loadActions: PassthroughSubject<Void, Never>

    init(devicesManagementService: DevicesManagementService, devicesListSettingsService: DevicesListSettingsService) {
        loadActions = PassthroughSubject()

        let updates = loadActions
            .combineLatest(
                devicesListSettingsService.osFilter,
                devicesListSettingsService.projectFilter,
                devicesListSettingsService.availableOnly
            )

        devicesListStatePublisher = updates
            .map { _, _, _, _ in DevicesListState.loading }
            .merge(
                with: updates
                    .flatMap { _, os, project, available in
                        devicesManagementService.loadDevices(with: os, project: project, available: available)
                            .map { DevicesListState.devices($0) }
                            .catch { Just(.error($0)) }
                    }
            )
            .eraseToAnyPublisher()
    }
}
