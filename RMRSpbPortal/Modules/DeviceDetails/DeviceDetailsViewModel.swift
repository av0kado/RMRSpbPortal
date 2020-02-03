//
// DeviceDetailsViewModel
// RMRSpbPortal
//
// Created by Amir Zigangaraev on 01 February 2020.
// Copyright (c) 2020 RedMadRobot. All rights reserved.
//

import Combine

enum DeviceDetailsState {
    case loading
    case device(Device)
    case error(Error)
}

protocol DeviceDetailsViewModel {
    var state: AnyPublisher<DeviceDetailsState, Never> { get }
    var canTake: AnyPublisher<Bool, Never> { get }
    var canReturn: AnyPublisher<Bool, Never> { get }

    func reload()
    func take()
    func `return`()
}

class DefaultDeviceDetailsViewModel: DeviceDetailsModule, DeviceDetailsViewModel {

    // MARK: - DeviceDetailsModule

    var deviceId: Device.ID? {
        get { deviceIdSubject.value }
        set { deviceIdSubject.value = newValue }
    }

    // MARK: - DeviceDetailsViewModel

    let state: AnyPublisher<DeviceDetailsState, Never>
    let canTake: AnyPublisher<Bool, Never>
    let canReturn: AnyPublisher<Bool, Never>

    func reload() {
        loadActions.send()
    }

    func take() {
        guard case .device(var device) = stateSubject.value else { return }

        device.status = .userTaken(User(id: "123", name: "USERNAME"))
        stateSubject.value = .loading
        devicesManagementService.update(device: device).sink(
            receiveCompletion: { _ in },
            receiveValue: { [weak self] in
                self?.stateSubject.value = .device(device)
            }
        ).store(in: &cancellables)
    }

    func `return`() {
        guard case .device(var device) = stateSubject.value else { return }

        device.status = .onStation
        stateSubject.value = .loading
        devicesManagementService.update(device: device).sink(
            receiveCompletion: { _ in },
            receiveValue: { [weak self] in
                self?.stateSubject.value = .device(device)
            }
        ).store(in: &cancellables)
    }

    // MARK: -
    private let devicesManagementService: DevicesManagementService
    private let deviceIdSubject: CurrentValueSubject<Device.ID?, Never>
    private let loadActions: PassthroughSubject<(), Never>
    private let stateSubject: CurrentValueSubject<DeviceDetailsState, Never>
    private var cancellables: Set<AnyCancellable> = []

    init(devicesManagementService: DevicesManagementService) {
        self.devicesManagementService = devicesManagementService
        deviceIdSubject = CurrentValueSubject(nil)
        loadActions = PassthroughSubject()
        let state = CurrentValueSubject<DeviceDetailsState, Never>(.loading)
        stateSubject = state
        self.state = state.eraseToAnyPublisher()

        let combined = loadActions.combineLatest(deviceIdSubject).map { $1 }

        combined.sink(receiveValue: { _ in state.value = .loading })
            .store(in: &cancellables)

        combined.filter { $0 != nil }
            .map { $0! }
            .flatMap {
                devicesManagementService.device(with: $0)
                    .map { .device($0) }
                    .catch { Just(.error($0)) }
            }
            .sink(receiveValue: { state.value = $0 })
            .store(in: &cancellables)

        canTake = state.map {
            if case .device(let device) = $0 {
                switch device.status {
                    case .userTaken, .onStation:
                        return true
                    case .unavailable:
                        return false
                }
            }
            return false
        }.eraseToAnyPublisher()

        canReturn = state.map {
            if case .device(let device) = $0 {
                switch device.status {
                    case .userTaken:
                        return true
                    case .onStation, .unavailable:
                        return false
                }
            }
            return false
        }.eraseToAnyPublisher()
    }
}
