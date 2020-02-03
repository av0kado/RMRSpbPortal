//
// MockDevicesManagementService
// RMRSpbPortal
//
// Created by Amir Zigangaraev on 31 December 2019.
// Copyright (c) 2019 RedMadRobot. All rights reserved.
//

import Foundation
import Combine

class MockDevicesManagementService: DevicesManagementService {
    private let requestDelay: Double = 1
    private lazy var mockProjects: [Project] = [
        Project(id: UUID().uuidString, name: "Project one"),
        Project(id: UUID().uuidString, name: "Project two"),
        Project(id: UUID().uuidString, name: "Project three"),
        Project(id: UUID().uuidString, name: "Project four"),
        Project(id: UUID().uuidString, name: "Project five"),
        Project(id: UUID().uuidString, name: "Project six"),
        Project(id: UUID().uuidString, name: "Project seven"),
        Project(id: UUID().uuidString, name: "Project eight"),
        Project(id: UUID().uuidString, name: "Project nine"),
        Project(id: UUID().uuidString, name: "Project ten"),
        Project(id: UUID().uuidString, name: "Project eleven"),
        Project(id: UUID().uuidString, name: "Project twelve")
    ]
    private lazy var mockDevices: [Device] = [
        Device(
            id: UUID().uuidString,
            name: "iPhone 6",
            description: "White iPhone 6",
            status: .onStation,
            operatingSystem: .iOS("12.1"),
            projects: [
                mockProjects[0], mockProjects[1], mockProjects[2]
            ]
        ),
        Device(
            id: UUID().uuidString,
            name: "iPhone 6",
            description: "Black iPhone 6",
            status: .onStation,
            operatingSystem: .iOS("11.2"),
            projects: [
                mockProjects[2], mockProjects[3], mockProjects[4]
            ]
        ),
        Device(
            id: UUID().uuidString,
            name: "iPhone SE",
            description: "Gold iPhone SE",
            status: .userTaken(User(id: UUID().uuidString, name: "Ivanov Ivan")),
            operatingSystem: .iOS("12.1"),
            projects: [
                mockProjects[3], mockProjects[6], mockProjects[8]
            ]
        ),
        Device(
            id: UUID().uuidString,
            name: "iPhone SE",
            description: "Black iPhone SE",
            status: .onStation,
            operatingSystem: .iOS("13.1"),
            projects: [
                mockProjects[0], mockProjects[1], mockProjects[2]
            ]
        ),
        Device(
            id: UUID().uuidString,
            name: "iPhone 7",
            description: "Onyx iPhone 7",
            status: .onStation,
            operatingSystem: .iOS("13.2"),
            projects: [
                mockProjects[5], mockProjects[7], mockProjects[9]
            ]
        ),
        Device(
            id: UUID().uuidString,
            name: "iPhone X",
            description: "White iPhone X",
            status: .onStation,
            operatingSystem: .iOS("13.3.2"),
            projects: [
                mockProjects[0], mockProjects[1], mockProjects[2], mockProjects[3], mockProjects[4], mockProjects[5], mockProjects[6],
                mockProjects[7], mockProjects[8], mockProjects[9], mockProjects[10], mockProjects[11]
            ]
        ),
        Device(
            id: UUID().uuidString,
            name: "iPhone 11 Pro",
            description: "Green iPhone 11 Pro",
            status: .onStation,
            operatingSystem: .iOS("13.3.2"),
            projects: [
                mockProjects[0], mockProjects[1], mockProjects[2], mockProjects[10]
            ]
        ),
        Device(
            id: UUID().uuidString,
            name: "iPhone Xs Max",
            description: "Black iPhone Xs Max",
            status: .onStation,
            operatingSystem: .iOS("13.0"),
            projects: [
                mockProjects[0], mockProjects[10], mockProjects[11]
            ]
        )
    ]

    private let deviceUpdatesSubject: PassthroughSubject<Device, Never> = PassthroughSubject()

    func loadOperatingSystems() -> Future<[Device.OperatingSystem], Error> {
        Future { completion in
            DispatchQueue.main.asyncAfter(deadline: .now() + self.requestDelay) {
                completion(.success(Array(Set(self.mockDevices.map { $0.operatingSystem }))))
            }
        }
    }

    func loadDevices(
        with osConstraint: Device.OperatingSystem.Constraints?,
        project: Project?,
        available: Bool
    ) -> Future<[Device], Error> {
        Future { completion in
            DispatchQueue.main.asyncAfter(deadline: .now() + self.requestDelay) {
                completion(.success(self.mockDevices))
            }
        }
    }

    func device(with id: Device.ID) -> Future<Device, Error> {
        Future { completion in
            DispatchQueue.main.asyncAfter(deadline: .now() + self.requestDelay) {
                if let device = self.mockDevices.first(where: { $0.id == id }) {
                    completion(.success(device))
                } else {
                    completion(.failure(DeviceError.notFound))
                }
            }
        }
    }

    func update(device: Device) -> Future<(), Error> {
        Future { completion in
            DispatchQueue.main.asyncAfter(deadline: .now() + self.requestDelay) {
                if let index = self.mockDevices.firstIndex(where: { $0.id == device.id }) {
                    self.mockDevices[index] = device
                    completion(.success(()))
                    self.deviceUpdatesSubject.send(device)
                } else {
                    completion(.failure(DeviceError.notFound))
                }
            }
        }
    }

    func deviceUpdates(deviceId: Device.ID?) -> AnyPublisher<Device, Never> {
        if let deviceId = deviceId {
            return deviceUpdatesSubject.filter { $0.id == deviceId }.eraseToAnyPublisher()
        } else {
            return deviceUpdatesSubject.eraseToAnyPublisher()
        }
    }
}
