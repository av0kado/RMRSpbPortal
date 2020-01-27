//
// DevicesListViewModel
// RMRSpbPortal
//
// Created by Amir Zigangaraev on 02 January 2020.
// Copyright (c) 2020 RedMadRobot. All rights reserved.
//

import UIKit
import Combine
import Legacy

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

    private let loadActions: PassthroughSubject<(), Never>

    func reload() {
        loadActions.send()
    }

    func select(device: Device) {
        didSelectDevice?(device.id)
    }

    // MARK: -

    private var cancellables: Set<AnyCancellable> = []

    init(devicesManagementService: DevicesManagementService, devicesListSettingsService: DevicesListSettingsService) {
        loadActions = PassthroughSubject()

        let devicesListState = CurrentValueSubject<DevicesListState, Never>(.loading)
        devicesListStatePublisher = devicesListState.eraseToAnyPublisher()

        loadActions
            .combineLatest(
                devicesListSettingsService.osFilter,
                devicesListSettingsService.projectFilter,
                devicesListSettingsService.availableOnly
            )
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in
                    devicesListState.value = .loading
                }
            )
            .store(in: &cancellables)

        loadActions
            .combineLatest(
                devicesListSettingsService.osFilter,
                devicesListSettingsService.projectFilter,
                devicesListSettingsService.availableOnly
            )
            .flatMap {
                devicesManagementService.loadDevices(with: $1, project: $2, available: $3)
                    .map { .devices($0) }
                    .catch { Just(.error($0)) }
            }
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { devicesListState.value = $0 }
            )
            .store(in: &cancellables)
    }
}
