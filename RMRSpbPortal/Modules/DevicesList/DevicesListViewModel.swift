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
    var loadActionsSubscriber: AnySubscriber<(), Never> { get }
}

class DefaultDevicesListViewModel: DevicesListModule, DevicesListViewModel {
    // MARK: - DevicesListModule

    let operatingSystemConstraintsSubscriber: AnySubscriber<Device.OperatingSystem.Constraints?, Never>
    private let operatingSystemConstraints: CurrentValueSubject<Device.OperatingSystem.Constraints?, Never>

    let projectFilterSubscriber: AnySubscriber<Project?, Never>
    private let projectFilter: CurrentValueSubject<Project?, Never>

    let loadOnlyAvailableSubscriber: AnySubscriber<Bool, Never>
    private let loadOnlyAvailable: CurrentValueSubject<Bool, Never>

    // MARK: - DevicesListViewModel

    let devicesListStatePublisher: AnyPublisher<DevicesListState, Never>

    let loadActionsSubscriber: AnySubscriber<(), Never>
    private let loadActions: PassthroughSubject<(), Never>

    // MARK: -

    private var cancellables: Set<AnyCancellable> = []

    init(devicesManagementService: DevicesManagementService) {
        operatingSystemConstraints = CurrentValueSubject(nil)
        operatingSystemConstraintsSubscriber = operatingSystemConstraints.anySubscriber()

        projectFilter = CurrentValueSubject(nil)
        projectFilterSubscriber = projectFilter.anySubscriber()

        loadOnlyAvailable = CurrentValueSubject(false)
        loadOnlyAvailableSubscriber = loadOnlyAvailable.anySubscriber()

        loadActions = PassthroughSubject()
        loadActionsSubscriber = loadActions.anySubscriber()

        let devicesListState = CurrentValueSubject<DevicesListState, Never>(.loading)
        devicesListStatePublisher = devicesListState.eraseToAnyPublisher()

        loadActions.combineLatest(operatingSystemConstraints, projectFilter, loadOnlyAvailable)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in
                    devicesListState.value = .loading
                }
            )
            .store(in: &cancellables)

        loadActions.combineLatest(operatingSystemConstraints, projectFilter, loadOnlyAvailable)
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
