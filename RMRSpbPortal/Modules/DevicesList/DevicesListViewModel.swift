//
// DevicesListViewModel
// RMRSpbPortal
//
// Created by Amir Zigangaraev on 02 January 2020.
// Copyright (c) 2020 RedMadRobot. All rights reserved.
//

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

    private let loadActions: PassthroughSubject<(), Never>
    private var cancellables: Set<AnyCancellable> = []

    init(devicesManagementService: DevicesManagementService, devicesListSettingsService: DevicesListSettingsService) {
        loadActions = PassthroughSubject()

        let devicesListState = CurrentValueSubject<DevicesListState, Never>(.loading)
        devicesListStatePublisher = devicesListState.eraseToAnyPublisher()

        let combined = loadActions
            .combineLatest(
                devicesListSettingsService.osFilter,
                devicesListSettingsService.projectFilter,
                devicesListSettingsService.availableOnly
            )
            .map { ($1, $2, $3) }

        combined.sink(receiveValue: { _ in devicesListState.value = .loading })
            .store(in: &cancellables)

        combined.flatMap {
                devicesManagementService.loadDevices(with: $0, project: $1, available: $2)
                    .map { .devices($0) }
                    .catch { Just(.error($0)) }
            }
            .sink(receiveValue: { devicesListState.value = $0 })
            .store(in: &cancellables)

        devicesManagementService.deviceUpdates(deviceId: nil).sink(receiveValue: { [weak self] device in
            guard let self = self else { return }

            if case .devices(var devices) = devicesListState.value, let index = devices.firstIndex(where: { $0.id == device.id }) {
                devices[index] = device
                devicesListState.value = .devices(devices)
            }
        }).store(in: &cancellables)
    }
}
